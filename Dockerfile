# this Dockerfile is so we can try CREST without having to install anything
# we build upon a jupyter/scipy installation that was extended with z3
# within this docker only fast things happen (install graphviz, copy files, do pip things)

# take a Jupyter-docker with z3 already installed!
FROM stklik/scipy-notebook-z3:1.0

LABEL maintainer="Stefan Klikovits <crestdsl@klikovits.net>"
USER root

# install graphviz and curl
RUN mkdir /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y  --no-install-recommends graphviz libgraphviz-dev curl dvipng && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install jupyter extensions
RUN pip install --no-cache-dir jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --system

RUN jupyter nbextension enable init_cell/main
RUN jupyter nbextension enable hide_input/main
RUN jupyter nbextension enable python-markdown/main
RUN jupyter nbextension enable code_prettify/code_prettify
RUN jupyter nbextension enable toc2/main
RUN jupyter nbextension enable codefolding/main

# install crestdsl
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade crestdsl

# copy the notebooks, so we have some inital stuff
COPY GettingStarted.ipynb ${HOME}/

# some cleanup
RUN rmdir work

USER $NB_USER

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

# copy a GettingStarted notebook
COPY GettingStarted.ipynb ${HOME}/

# some cleanup
RUN rmdir work

USER $NB_USER

# use latest, because they have daily builds, no real versions
FROM jupyter/scipy-notebook:latest

LABEL maintainer="Stefan Klikovits <crestdsl@klikovits.net>"
USER root

# install (patched) z3
RUN git clone https://github.com/stklik/z3.git
WORKDIR z3
RUN python scripts/mk_make.py --python
RUN cd build && make
RUN cd build && make install
WORKDIR ..
RUN rm -rf z3   # cleanup

# install graphviz and curl
RUN mkdir /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y  --no-install-recommends graphviz libgraphviz-dev curl dvipng && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# update conda packages deliberately
RUN conda update -n base conda
RUN conda update numpy
RUN conda update pandas
RUN conda update matplotlib
RUN conda update scipy
RUN conda update networkx

# install crestdsl
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade crestdsl

# install jupyter extensions
RUN pip install --no-cache-dir jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --system

RUN jupyter nbextension enable init_cell/main
RUN jupyter nbextension enable hide_input/main
RUN jupyter nbextension enable python-markdown/main
RUN jupyter nbextension enable code_prettify/code_prettify
RUN jupyter nbextension enable toc2/main
RUN jupyter nbextension enable codefolding/main


# copy a GettingStarted notebook
COPY GettingStarted.ipynb ${HOME}/

# some cleanup
RUN rmdir work

USER $NB_USER

LABEL maintainer="Brian Chen<brianchen.chen@mail.utoronto.ca"
FROM arm32v7/python:3.9-bullseye

# Set the variables
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /root

USER root
RUN echo "CHANGEME" | passwd --stdin root

# Install both Python 2 and 3
RUN apt-get update && apt-get upgrade && apt-get install -y python-dev \
	python3-dev \
	python3-pip \
	build-essential\
	libssl-dev \
	libffi-dev \
	python-dev \
	ca-certificates \
	libncurses5-dev \
	curl \
	bash \
	nodejs \
	npm 

# needed for python cryptography
RUN apt-get install -y rustc  


# jupyterhub dependencies
RUN pip3 install --upgrade pip
RUN pip3 install cryptography
RUN pip3 install readline jupyter jupyterhub jupyterlab notebook 
RUN npm install -g configurable-http-proxy

# Fix Python3 kernel since IPykernel 5.0.0 has dependency issues.
RUN pip3 install "ipykernel==4.10.0" --force-reinstall 


# jupyter c kernel

RUN pip3 install jupyter-c-kernel
RUN install_c_kernel --sys-prefix


COPY jupyterhub_config.py jupyterhub_config.py

EXPOSE 8000


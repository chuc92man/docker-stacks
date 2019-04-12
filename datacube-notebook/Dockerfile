FROM jupyter/minimal-notebook:4cdbc9cdb7d1

# Get the latest image tag at:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook/Dockerfile

USER root

# Install nbgitpuller to synchronize a folder in a user's filesystem
# with a git repository whenever the user starts their server.
RUN pip install --no-cache-dir nbgitpuller

USER $NB_UID

# Data Cube installation and configuration...

# Certificate verification is currently failing, so disable it for now
RUN conda config --set ssl_verify no

ADD environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml

RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension
RUN jupyter nbextension enable --py --sys-prefix ipyleaflet

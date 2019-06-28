# Refer to https://zero-to-jupyterhub.readthedocs.io/en/latest/user-environment.html#customize-an-existing-docker-image
# Get the latest image tag at:
#   https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
#   https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook/Dockerfile
FROM jupyter/minimal-notebook:4cdbc9cdb7d1

LABEL maintainer="Luigi Di Fraia"

# Install nbgitpuller to synchronize a folder in a user's filesystem
# with a git repository whenever the user starts their server.
RUN pip install --no-cache-dir nbgitpuller

# Data Cube installation (Python 3.6 is recommended)
RUN conda create --yes --name cubeenv python=3.6 \
	datacube=1.7 && \
	conda clean -tipsy && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

# Install the following useful packages to run Earth Observation Notebooks (such as DCAL)
RUN conda install --quiet --yes --name cubeenv \
	boto3=1.9.179 \
	dask=2.0.0 \
	descartes=1.1.0 \
	distributed=2.0.1 \
	folium=0.9.1 \
	geopandas=0.5.0 \
	hdmedians=0.13 \
	ipyleaflet=0.10.8 \
	matplotlib=3.1.0 \
	rasterstats=0.13.1 \
	ruamel=1.0 \
	ruamel.yaml=0.15.96 \
	scikit-image=0.15.0 \
	scikit-learn=0.21.2 \
	scipy=1.3.0 \
	seaborn=0.9.0 \
	shapely=1.6.4 && \
	conda clean -tipsy && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

# Install the following useful miscellaneous packages
RUN conda install --quiet --yes --name cubeenv \
	vim=8.1.1343 \
	awscli=1.16.189 && \
	conda clean -tipsy && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

# Make the cubeenv kernel available in Jupyter
RUN conda install --quiet --yes nb_conda_kernels && \
	conda install --quiet --yes --name cubeenv \
	ipykernel=5.1.1 && \
	conda clean -tipsy && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

# Enable Lab extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
	jupyter labextension install jupyter-leaflet && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

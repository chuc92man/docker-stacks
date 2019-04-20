FROM jupyter/minimal-notebook:4cdbc9cdb7d1

# Get the latest image tag at:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook/Dockerfile

# Install nbgitpuller to synchronize a folder in a user's filesystem
# with a git repository whenever the user starts their server.
RUN pip install --no-cache-dir nbgitpuller

# Data Cube installation (Python 3.6 is recommended)
RUN conda create --yes --name cubeenv python=3.6 \
	datacube=1.6.2 && \
	conda clean -tipsy && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

# Downgrade the following packages
RUN conda install --quiet --yes --name cubeenv \
	gdal=2.3.3 \
	sqlalchemy=1.2.18 && \
	conda clean -tipsy && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

# Install the following useful packages to run Earth Observation Notebooks (such as DCAL)
RUN conda install --quiet --yes --name cubeenv \
	descartes=1.1.0 \
	folium=0.8.3 \
	geopandas=0.4.1 \
	hdmedians=0.13 \
	ipyleaflet=0.10.1 \
	rasterstats=0.13.1 \
	scikit-image=0.15.0 \
	scikit-learn=0.20.3 \
	seaborn=0.9.0 && \
	conda clean -tipsy && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

# Make the cubeenv kernel available in Jupyter
RUN conda install --quiet --yes nb_conda_kernels && \
	conda install --quiet --yes --name cubeenv ipykernel && \
	conda clean -tipsy && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

# Enable Lab extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
	jupyter labextension install jupyter-leaflet && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

# Refer to https://zero-to-jupyterhub.readthedocs.io/en/latest/user-environment.html#customize-an-existing-docker-image
# Get the latest image tag at:
#   https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
#   https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook/Dockerfile
FROM jupyter/minimal-notebook:4cdbc9cdb7d1

LABEL maintainer="Luigi Di Fraia"

# Data Cube installation (Python 3.6 is recommended)
RUN conda create --yes --name cubeenv python=3.6 && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Make the cubeenv kernel available in Jupyter
RUN conda install --quiet --yes nb_conda_kernels && \
    conda install --quiet --yes --name cubeenv \
    ipykernel && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Build and enable additional Lab extensions
RUN jupyter labextension install --no-build dask-labextension && \
    jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install --no-build jupyter-leaflet && \
    jupyter lab build && \
    jupyter lab clean && \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install additional packages for Dask
RUN conda install --yes --name cubeenv \
    -c conda-forge \
    python-blosc==1.9.0 \
    cytoolz==0.10.1 \
    dask==2.14.0 \
    lz4==3.0.2 \
    nomkl==1.0 \
    numpy==1.18.1 \
    pandas==1.0.1 && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install the following useful packages to run Earth Observation Notebooks (such as DCAL)
RUN conda install --yes --name cubeenv \
    -c conda-forge \
    boto3==1.12.36 \
    datacube==1.7 \
    descartes==1.1.0 \
    folium==0.10.1 \
    gdal==2.4.4 \
    geopandas==0.7.0 \
    hdmedians==0.13 \
    ipyleaflet==0.12.3 \
    matplotlib==3.2.1 \
    rasterstats==0.14.0 \
    ruamel==1.0 \
    ruamel.yaml==0.16.6 \
    scikit-image==0.16.2 \
    scikit-learn==0.22.2.post1 \
    scipy==1.4.1 \
    seaborn==0.10.0 \
    shapely==1.7.0 && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install additional useful EO packages from GA
RUN /opt/conda/envs/cubeenv/bin/pip install --no-cache-dir \
    hdstats==0.1.3 \
    odc-algo==0.1.dev439+gd29f1df \
    odc-ui==0.1.dev439+gd29f1df \
    --extra-index-url=https://packages.dea.ga.gov.au && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install the following useful miscellaneous packages
RUN conda install --yes --name cubeenv \
	vim=8.2.0616 \
	awscli=1.18.43 && \
    conda clean --all -f -y && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

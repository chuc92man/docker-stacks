# Jupyter Notebook Open Data Cube Stack

Alpha version of an [Open Data Cube](https://www.opendatacube.org/) Jupyter Notebook Stack for [Zero to JupyterHub with Kubernetes](https://zero-to-jupyterhub.readthedocs.io/en/latest/), that is meant to make [JupyterHub](https://jupyter.org/hub) available to a large group of users, such as the staff and students of a university.

## Quick Start

You can try a recent build of the [luigidifraia/datacube-notebook image](https://cloud.docker.com/u/luigidifraia/repository/docker/luigidifraia/datacube-notebook) on mybinder.org by simply clicking [this link](https://mybinder.org/v2/gh/luigidifraia/datacube-notebook-binder/master?filepath=README.ipynb).

## TODO

- Also install dask-labextension in future builds:
    ```
    RUN jupyter labextension install --no-build dask-labextension && \
	    jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager && \
	    jupyter labextension install --no-build jupyter-leaflet && \
	    jupyter lab build && \
	    fix-permissions $CONDA_DIR && \
	    fix-permissions /home/$NB_USER
    ```

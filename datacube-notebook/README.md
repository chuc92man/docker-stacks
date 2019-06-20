# Jupyter Notebook Open Data Cube Stack

Alpha version of an [Open Data Cube](https://www.opendatacube.org/) Jupyter Notebook Stack for [Zero to JupyterHub with Kubernetes](https://zero-to-jupyterhub.readthedocs.io/en/latest/), that is meant to let users make [JupyterHub](https://jupyter.org/hub) available to a large group of users, such as the staff and students of a university.

Please visit the [official documentation](https://zero-to-jupyterhub.readthedocs.io/en/latest/user-environment.html#customize-an-existing-docker-image) for *Zero to JupyterHub with Kubernetes* if you need help using and contributing to this repo.

## Building the Docker image

For most users pre-built Docker images will work just fine. These can be conveniently pulled from [Docker Hub](https://hub.docker.com/r/luigidifraia/datacube-notebook).

A custom Docker image for *Open Data Cube* can be built from this repo as per below:

`docker build -t datacube-notebook .`

Should dependencies break over time, a *Miniconda* [environment.yml](environment.yml) was provided to replicate the Docker image build at the time a release was created.

## TODO

A few things need to be finished and/or added, in particular:
- Persistence of user data, including Jupyter Notebooks, possibly with an example that uses a shared [PV](https://zero-to-jupyterhub.readthedocs.io/en/latest/user-storage.html#additional-storage-volumes)
- ~~Use of a *ConfigMap* for `.datacube.conf`~~
- Disable the *LoadBalancer* service when an *Ingress* is used instead (service/proxy-public)
- Explore *cert-manager* for secure connections with certificate auto-renewal
- Automatic *Open Data Cube* DB initialization and sample product indexing (this is a one-off operation that requires documenting and possibly making configuration files/prepare scripts available in the Docker image)
- Production-ready configuration example for *PostgreSQL*, including persistence/replication
- *Dask* workers should really run code in a virtual environment, set up consistently with the one the datacube core runs in (at the moment *Dask* workers run *Python* 3.7)
- Explore [Dask Kubernetes](http://kubernetes.dask.org/en/latest/)
- Production-ready configuration example for a *Dask* cluster to scale horizontally
- Example EO Notebooks, especially *mean value* calculations that leverage *Dask*

## Known issues

- ~~Using default ingress settings, a "413 Request Entity Too Large" error occurs when trying to save large Notebooks~~

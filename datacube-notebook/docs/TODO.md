# TODO

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


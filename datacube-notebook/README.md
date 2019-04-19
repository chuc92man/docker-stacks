# Jupyter Notebook Open Data Cube Stack

Open Data Cube Jupyter Notebook Stack.

Should dependencies break over time, an [environment.yml.example](environment.yml.example) was provided to replicate the build at the time this repo was created.

## Testing/Development set-up
Once the Docker image is built, tagged and made available through a Docker registry, simply create a *config.yaml* file using the [config.yaml.example](config.yaml.example) provided. At that point, you might want to start the JupyterHub deployment with:

```
RELEASE=jhub
NAMESPACE=jhub

helm upgrade --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE \
  --version=0.8.2 \
  --values config.yaml
```

For testing purposes the underlying database required by the Open Data Cube can be set up by means of the official [Helm chart for PostgreSQL](https://github.com/helm/charts/tree/master/stable/postgresql) as follows (make sure the PV claim can be satisfied for data persistence, otherwise **for testing purposes only** add the option `persistence.enabled=false`):

```
RELEASEDB=datacubedb
NAMESPACEDB=datacubedb

helm upgrade --install $RELEASEDB stable/postgresql \
  --namespace $NAMESPACEDB \
  --set postgresqlPassword=localuser1234,postgresqlDatabase=datacube
```

The corresponding test configuration, `/home/jovyan/.datacube.conf`, would then look as per below:

```
[datacube]
db_database: datacube

# A blank host will use a local socket. Specify a hostname (such as localhost) to use TCP.
db_hostname: datacubedb-postgresql

# Credentials are optional: you might have other Postgres authentication configured.
# The default username is the current user id
db_username: postgres

# A blank password will fall back to default postgres driver authentication, such as reading your ~/.pgpass file.
db_password: localuser1234
```

The resulting environment will look like the following one:

![Example Terminal](JupyterHub_Terminal.png)

![Example Notebook](JupyterHub_Notebook.png)

## TODO
A few things need to be finished and/or added, in particular:
- Persistence of user data, including Jupyter Notebooks
- Use of a ConfigMap for `.datacube.conf`
- Automatic Open Data Cube DB initialization and sample product indexing
- Workaround for `nbgitpuller` to pull external references too, e.g. the utils folder under [data_cube_notebooks](https://github.com/ceos-seo/data_cube_notebooks)
- Production-ready configuration example for PostgreSQL, including persistence/replication
- Deployment configuration for a [Dask cluster](https://github.com/helm/charts/tree/master/stable/dask) to scale horizontally
- Example EO Notebooks, especially *mean value* calculations that leverage Dask

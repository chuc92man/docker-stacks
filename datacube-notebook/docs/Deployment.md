# Setting up JupyterHub

In order to use the deployment material described here you need access to a Kubernetes server or cluster with Helm installed. For development and learning purposes [minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/) and [microk8s](https://microk8s.io/) can be used too.

For help setting up Helm, check the setup documentation on [Read the Docs](https://zero-to-jupyterhub.readthedocs.io/en/latest/setup-helm.html).

Make Helm aware of the [JupyterHub Helm chart repository](https://jupyterhub.github.io/helm-chart/):

```bash
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
```

## Install JupyterHub

It's necessary to create a *config.yaml* file specific to the Kubernetes cluster where JupyterHub is being deployed. For help doing so, please visit the documentation reference [here](https://zero-to-jupyterhub.readthedocs.io/en/latest/setup-jupyterhub.html) and [here](https://zero-to-jupyterhub.readthedocs.io/en/latest/reference.html#helm-chart-configuration-reference). The [04-config-jhub.yaml.example](../examples/configuration/04-config-jhub.yaml.example) file can be used as a quick-reference guide.

Once a *config.yaml* file is put together, the deployment of JupyterHub can be started with:

```bash
RELEASE=jhub
NAMESPACE=jhub

helm upgrade --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE \
  --version=0.8.2 \
  --values config.yaml
```

## Install PostgreSQL

The underlying database required by the Open Data Cube can be set up by means of the official [Helm chart for PostgreSQL](https://github.com/helm/charts/tree/master/stable/postgresql). For this purpose, a *config-postgresql.yaml* file has to be created. The [06-config-postgresql.yaml.example](../examples/configuration/06-config-postgresql.yaml.example) file can be used as a quick-reference guide.

Once a *config-postgresql.yaml* file is put together, the deployment of the PostgreSQL database can be started with:

```bash
RELEASEDB=datacubedb
NAMESPACEDB=datacubedb

helm upgrade --install $RELEASEDB stable/postgresql \
  --namespace $NAMESPACEDB \
  --version 5.1.1 \
  --values config-postgresql.yaml
```

## Set up /etc/datacube.conf

It is also necessary to create a corresponding configuration file *datacube-configmap.yaml* that is mounted as */etc/datacube.conf* through a ConfigMap named `datacube-conf`. The [05-datacube-configmap.yaml.example](../examples/configuration/05-datacube-configmap.yaml.example) file can be used as a quick-reference guide.

Once a *datacube-configmap.yaml* file is put together, the corresponding ConfigMap can be set up with:

```bash
kubectl apply -f datacube-configmap.yaml
```

## Test the platform post-deployment

The resulting computing platform will look like the following one:

![Example Login with GitHub](media/JupyterHub_GitHub_OAuth.png)

![Example Server Starting](media/JupyterHub_Server_Starting.png)

Note that JupyterLab is enabled by default in the [04-config-jhub.yaml.example](../examples/configuration/04-config-jhub.yaml.example) provided.

![Example JupyterLab](media/JupyterHub_Lab_Launcher.png)

## Database initialisation

After launching a Terminal, the Open Data Cube DB can be initialised with:

```bash
source activate cubeenv
datacube -v system init
```

Afterwards, its status can be checked with:

```bash
source activate cubeenv
datacube -v system check
```

![Example Terminal](media/JupyterHub_Terminal.png)

When using Jupyter Notebook make sure the *cubeenv* kernel is selected:

![Example Notebook](media/JupyterHub_Notebook.png)

## Horizontal scaling with Dask

The setup material for deploying a [Dask](https://dask.org/) cluster is also available. To try it out, a *config-dask.yaml* file has to be created. The [07-config-dask.yaml.example](../examples/configuration/07-config-dask.yaml.example) file can be used as a quick-reference guide.

Once a *config-dask.yaml* file is put together, the deployment of the [Dask cluster](https://github.com/helm/charts/tree/master/stable/dask) can be started with:

```bash
RELEASEDASK=dask
NAMESPACEDASK=dask

helm upgrade --install $RELEASEDASK stable/dask \
  --namespace $NAMESPACEDASK \
  --version=2.2.0 \
  --values config-dask.yaml
```

From within a Jupyter Notebook a Dask distributed client can then be instantiated with:

```python
import dask
from dask.distributed import Client
client = Client('dask-scheduler.dask.svc.cluster.local:8786')
client
```

### Ingress for Dask's Dashboard

To access Dask's [Dashboard](http://docs.dask.org/en/latest/diagnostics-distributed.html#dashboard) an Ingress might have to be deployed (e.g. if not using a public cloud's load balancer), using a *dask-webui-ingress.yaml* file. The [08-dask-webui-ingress.yaml.example](../examples/configuration/08-dask-webui-ingress.yaml.example) file can be used as a quick-reference guide.

Once a *dask-webui-ingress.yaml* is put together, the deployment of an Ingress can be started with:

```bash
kubectl apply -f dask-webui-ingress.yaml
```

### Sample Notebook for Dask's distributed computing

A sample Notebook is provided to validate the setup of the Dask cluster, [satellite-imagery-geotiff-distributed.ipynb](../examples/notebooks/dask/satellite-imagery-geotiff-distributed.ipynb). Such Notebook is based on the one provided within Dask's GitHub repo [here](https://github.com/dask/dask-examples/blob/master/applications/satellite-imagery-geotiff.ipynb).

Here's a screenshot from the Notebook itself:

![Example Notebook for Dask](media/JupyterHub_Dask_Distributed_Notebook.png)

And here's a screenshot from Dask's Dashboard during the max/min/mean calculation:

![Example Dask Dashboard during max/min calculations](media/Dask_Dashboard_Progress_Max_Min_Median.png)

### AWS access from Dask workers

AWS credentials for use with GDAL can be distributed to Dask workers in a number of ways.

#### Static distribution

The [07-config-dask.yaml.example](../examples/configuration/07-config-dask.yaml.example) file provides examples on how to set [GDAL environment variables for AWS access]((https://gdal.org/user/virtual_file_systems.html)) at the time a worker Pod is created or upgraded:

```yaml
worker:
  env:
    - name: AWS_NO_SIGN_REQUEST  # This option might be used for buckets with public access rights. Available since GDAL 2.3.
      value: "YES"
    # - name: AWS_ACCESS_KEY_ID
    #   value: "AKIAIOSFODNN7INVALID"
    # - name: AWS_SECRET_ACCESS_KEY
    #   value: "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"
    # - name: AWS_DEFAULT_REGION
    #   value: "us-west-2"
    # - name: AWS_S3_ENDPOINT
    #   value: "s3.acme.com"
    # - name: AWS_PROFILE
    #   value: "acme"
```

#### Dynamic distribution

The [useful-snippets.ipynb](../examples/notebooks/misc/useful-snippets.ipynb) Notebook provides an example on how to set GDAL environment variables for AWS access at Notebook execution time, on each Dask worker:

```python
def worker_setup_auto():
    from datacube.utils.rio import set_default_rio_config, activate_from_config
    
    # these settings will be applied in every worker thread
    set_default_rio_config(aws={'aws_unsigned': True},
                           cloud_defaults=True)
    
    # Force activation in the main thread
    # - Really just to test that configuration works
    # - Every worker thread will automatically run this again
    return activate_from_config()
```
```python
# Runs once on every worker process, not per worker thread!
client.register_worker_callbacks(setup=worker_setup_auto)
```

## Revision control

Readers would have noticed that the above setup instructions insist on the creation of YAML files. The reason for creating such files, rather than e.g. passing values to the Helm client using the `--set` option, is that such files should be put under revision control, so that they can be used to reproduce a working setup programmatically.

Note that it is a very bad idea to include credentials in configurations files, as there's a risk that such credentials will be accidentally shared with people not authorized to access them.

## Cleaning up

If you wish to undo changes to your Kubernetes cluster, simply issue the following commands:

```bash
helm delete $RELEASE --purge
kubectl delete -f datacube-configmap.yaml
kubectl delete namespace $NAMESPACE

helm delete $RELEASEDB --purge
kubectl delete namespace $NAMESPACEDB

helm delete $RELEASEDASK --purge
kubectl delete -f dask-webui-ingress.yaml
kubectl delete namespace $NAMESPACEDASK
```

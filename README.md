# Fn Helm chart

## Prerequisites

- Install [Helm](https://github.com/kubernetes/helm#install)

- Install Tiller, the server portion of Helm, to your Kubernetes cluster.

```bash
$ helm init --upgrade
```

## Deploying Fn via Helm

- Clone the fn-helm repo:

```bash
$ git clone git@github.com:fnproject/fn-helm.git && cd fn-helm
```

- Install chart dependencies from [requirements.yaml](./fn/requirements.yaml):

```bash
$ helm dep update fn
```

- Install the Fn chart:

```bash
$ helm install fn
```

Installing a chart will create a new release with an auto-generated name.
Optionally, you can pass in the `--name` flag to use your own release name
(e.g. `helm install --name dev fn`)

## Uninstalling the Fn Helm chart

- Use `helm list` to see all currently deployed releases:

```bash
$ helm list
NAME            REVISION        UPDATED                         STATUS          CHART           NAMESPACE
exegetical-frog 1               Tue Nov 28 12:31:22 2017        DEPLOYED        fn-0.1.0        default
```

- Following the example release above, all kubernetes resources can be cleaned up with:

```bash
$ helm delete --purge exegetical-frog
release "exegetical-frog" deleted
```


## Configuration 

|  Key                        |    Default      | Notes               | 
| -------------------------    |  -----------   | -------             |
| fnserver.service.port        |   80           |                     |
| fnserver.service.type        |   LoadBalancer |  fn service load balancer type           |
| fnserver.service.annotations |   {}           |  annotations for fn service          |
| mysql.*                      |                | See the [https://github.com/kubernetes/charts/tree/master/stable/mysql](Mysql chart docs) | 
| redis.*                      |                | See the [https://github.com/kubernetes/charts/tree/master/stable/redis](Redis chart docs) | 
 
# Fn Project Helm Chart

The [Fn project](http://fnproject.io) is an open source, container native, and cloud agnostic serverless platform. It’s easy to use, supports every programming language, and is extensible and performant.

## Introduction

This chart deploys a fully functioning instance of the [Fn](https://github.com/fnproject/fn) platform on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- PV provisioner support in the underlying infrastructure (for persistent data, see below )

- Install [Helm](https://github.com/kubernetes/helm#install)

- Initialize Helm by installing Tiller, the server portion of Helm, to your Kubernetes cluster

```bash
helm init
```

## Installing the Chart

Clone the fn-helm repo:

```bash
git clone git@github.com:fnproject/fn-helm.git && cd fn-helm
```

Install chart dependencies from [requirements.yaml](./fn/requirements.yaml):

```bash
helm dep build fn
```

To install the chart with the release name `my-release`:

```bash
helm install --name my-release fn
```

> Note: if you do not pass the --name flag, a release name will be auto-generated. You can view releases by running helm list (or helm ls, for short).


## Uninstalling the Fn Helm Chart

Assuming your release is named `my-release`:

```bash
helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters and their default values.

### Fn Server Configuration
|  Key                                  |  Description                          |  Default              |
| --------------------------------------|---------------------------------------|-----------------------|
| `fn.service.type`                     | ClusterIP, NodePort, LoadBalancer     | `LoadBalancer`        |
| `fn.service.port`                     | Fn service port                       | `80`                  |
| `fn.service.annotations`              | Fn Service annotations                | `{}`                  |
| `fn.ingress.enabled`                  | Fn API enable ingress resource        | `false`               |
| `fn.ingress.hosts.[0].name`           | Host header for access                | `fn-api.local`        |
| `fn.ingress.hosts.[0].path`           | Fn API ingress path                   | `/`                   |
| `fn.ingress.annotations`              | Fn API ingress service annotations    | `{}`                  |
| `fn.ingress.tls.[0].secretName`       | TLS Secret (certificates) name        | `fn-api-tls`          |
| `fn.ingress.tls.[0].hosts`            | Host headers to get ssl certs for     | `fn-api.local`        |
| `fn.resources`                        | Per-node resource requests, see [Kubernetes Pod Resources](http://kubernetes.io/docs/user-guide/compute-resources/)                | `{}`                  |
| `fnserver.resources`                  | Per-node resource requests, see [Kubernetes Pod Resources](http://kubernetes.io/docs/user-guide/compute-resources/)                | `{}`                  |
| `fnserver.nodeSelector`               | Fn node selectors, see [Kubernetes Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/)     | `{}`                  |
| `fnserver.tolerations`                | Node taint tolerations, see [Kubernetes Taints and Tolerations](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/)     | `{}`             |

### Fn UI Configuration
|  Key                                  |  Description                          |  Default              |
| --------------------------------------|---------------------------------------|-----------------------|
| `fnui.enabled`                        | Enable Fn UI components               | `true`                |
| `fnui.replicaCount`                   | Fn UI Replicas                        | `1`                   |
| `fnui.image.repository`               | Fn UI image repository                | `fnproject/ui`        |
| `fnui.image.tag`                      | Fn UI image tag                       | `latest`              |
| `fnui.imagePullPolicy`                | Fn UI image imagePullPolicy           | `Always`              |
| `fnui.service.internalPort`           | Fn internal port for ui service       | `4000`                |
| `fnui.service.externalPort`           | Fn external port for ui service       | `80`                  |
| `fnui.service.type`                   | Fn UI Service type                    | `ClusterIP`           |
| `fnui.ingress.enabled`                | Enable Fn UI ingress resource         | `false`               |
| `fnui.ingress.hosts.[0].name`         | Host header for access                | `fn.local`            |
| `fnui.ingress.hosts.[0].path`         | Fn UI ingress path                    | `/`                   |
| `fnui.ingress.annotations`            | Fn UI ingress service annotations     | `{}`                  |
| `fnui.ingress.tls.[0].secretName`     | TLS Secret (certificates) name        | `fn-tls`              |
| `fnui.ingress.tls.[0].hosts`          | Host headers to get ssl certs for     | `fn.local`            |
| `fnui.resources`                      | Per-node resource requests, see [Kubernetes Pod Resources](http://kubernetes.io/docs/user-guide/compute-resources/)                | `{}`                  |

### Flow Server Configuration
|  Key                                  |  Description                          |  Default              |
| --------------------------------------|---------------------------------------|-----------------------|
| `flow.service.type`                   | ClusterIP, NodePort, LoadBalancer     | `ClusterIP`           |
| `flow.service.port`                   | Flow Service port                     | `80`                  |
| `flow.ingress.enabled`                | Flow enable ingress resource          | `false`               |
| `flow.ingress.hosts.[0].name`         | Host header for access                | `flow.local`          |
| `flow.ingress.hosts.[0].path`         | Flow ingress path                     | `/`                   |
| `flow.ingress.annotations`            | Flow ingress service annotations      | `{}`                  |
| `flow.ingress.tls.[0].secretName`     | TLS Secret (certificates) name        | `flow-tls`            |
| `flow.ingress.tls.[0].hosts`          | Host headers to get ssl certs for     | `flow.local`          |
| `flow.resources`                      | Per-node resource requests, see [Kubernetes Pod Resources](http://kubernetes.io/docs/user-guide/compute-resources/)                | `{}`                  |
| `flow.service.annotations`            | Flow Service annotations              | `{}`                  |

### Flow UI Configuration
|  Key                                  |  Description                          |  Default              |
| --------------------------------------|---------------------------------------|-----------------------|
| `flowui.enabled`                      | Flow UI enable components             | `true`                |
| `flowui.replicaCount`                 | Flow UI Replicas                      | `1`                   |
| `flowui.image.repository`             | Flow UI image repository              | `fnproject/flow`      |
| `flowui.image.tag`                    | Flow UI image tag                     | `ui`                  |
| `flowui.imagePullPolicy`              | Flow UI image imagePullPolicy         | `Always`              |
| `flowui.service.internalPort`         | Flow internal port for ui service     | `3000`                |
| `flowui.service.externalPort`         | Flow external port for ui service     | `80`                  |
| `flowui.service.type`                 | Flow UI Service type                  | `ClusterIP`           |

### MySQL & Redis Configuration
|  Key                                  |  Description                          |  Default              |
| --------------------------------------|---------------------------------------|-----------------------|
| `mysql.*`                      | See the [MySQL chart docs](https://github.com/kubernetes/charts/tree/master/stable/mysql)                   | |
| `redis.*`                      | See the [Redis chart docs](https://github.com/kubernetes/charts/tree/master/stable/redis)                   | |
 
 ## Configuring Database Persistence 
 
Fn persists application data in MySQL. This is configured using the MySQL Helm Chart.

By default this uses container storage. To configure a persistent volume, set `mysql.*` values in the chart values to that which corresponds to your storage requirements.

e.g. to use an existing persistent volume claim for MySQL storage:

```bash 
helm install --name testfn --set mysql.persistence.enabled=true,mysql.persistence.existingClaim=tc-fn-mysql fn
```

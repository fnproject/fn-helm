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
git clone https://github.com/fnproject/fn-helm.git && cd fn-helm
```

Install chart dependencies from [requirements.yaml](./fn/requirements.yaml):

```bash
helm dep build fn
```

The default chart will install fn as a private service inside your cluster with ephemeral storage, to configure a public endpoint and persistent storage you should look at [values.yaml](fn/values.yaml) and modify the default settings. An example for Oracle Cloud Infrastructure is [here](examples/oci).

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

|  Key                           |  Description                      |  Default              |
| -------------------------------|-----------------------------------|-----------------------|
| `fn.service.type`        | ClusterIP, NodePort, LoadBalancer | `LoadBalancer`        |
| `fn.service.port`        | Fn service port                   | `80`                  |
| `fn.service.annotations` | Fn Service annotations            | `{}`                  |
| `fnserver.resources`           | Per-node resource requests, see [Kubernetes Pod Resources](http://kubernetes.io/docs/user-guide/compute-resources/)            | `{}`                  |
| `fnserver.nodeSelector`        | Fn node selectors, see [Kubernetes Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) | `{}`                  |
| `fnserver.tolerations`         | Node taint tolerations, see [Kubernetes Taints and Tolerations](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) | `{}`             |
| `flow.service.type`            | ClusterIP, NodePort, LoadBalancer | `ClusterIP`           |
| `flow.service.port`            | Flow Service port                 | `80`                  |
| `flow.service.annotations`     | Flow Service annotations          | `{}`                  |
| `ui.enabled`                   | Enable UI components              | `true`                |
| `ui.service.flowuiPort`        | Fn Flow UI port for ui service    | `3000`                |
| `ui.service.fnuiPort`          | Fn UI port for ui service         | `4000`                |
| `ui.service.type`              | UI Service type                   | `LoadBalancer`        |
| `rbac.enabled`                 | Whether to enable RBAC with a specific cluster role and binding for Fn | `false`                            |
| `mysql.*`                      | See the [MySQL chart docs](https://github.com/kubernetes/charts/tree/master/stable/mysql) | |
| `redis.*`                      | See the [Redis chart docs](https://github.com/kubernetes/charts/tree/master/stable/redis) | |
 
 ## Configuring Database Persistence 
 
Fn persists application data in MySQL. This is configured using the MySQL Helm Chart.

By default this uses container storage. To configure a persistent volume, set `mysql.*` values in the chart values to that which corresponds to your storage requirements.

e.g. to use an existing persistent volume claim for MySQL storage:

```bash 
helm install --name testfn --set mysql.persistence.enabled=true,mysql.persistence.existingClaim=tc-fn-mysql fn
```

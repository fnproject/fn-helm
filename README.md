# Fn Project Helm Charts

The [Fn project](http://fnproject.io) is an open source, container native, and cloud agnostic serverless platform. It’s easy to use, supports every programming language, and is extensible and performant.

## Introduction

This repository contains a selection of helm charts to handle deployments of the [Fn](https://github.com/fnproject/fn) platform on Kubernetes using the [Helm](https://helm.sh/) package manager.

The `fn` chart deploys a fully functional instance of the Fn platform infrastructure onto a single cluster. This is the most straightforward way of deploying Fn.

The `fn-controlplane` and `fn-workplane` charts are used to deploy the control plane and work plane infrastructure of the Fn platform separately, onto two clusters. These are useful for advanced or custom deployments (for example, in cross-cloud deployments), which are also known as "hybrid deployments".

## Prerequisites

- PV provisioner support in the underlying infrastructure (for persistent data, see below )

- Install [Helm](https://github.com/kubernetes/helm#install)

- Initialize Helm by installing Tiller, the server portion of Helm, to your Kubernetes cluster

```bash
helm init
```

## Installing the single-cluster Chart

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


## Uninstalling the single-cluster Fn Helm Chart

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
| `mysql.*`                      | See the [MySQL chart docs](https://github.com/kubernetes/charts/tree/master/stable/mysql) | |
| `redis.*`                      | See the [Redis chart docs](https://github.com/kubernetes/charts/tree/master/stable/redis) | |

 ## Configuring Database Persistence

Fn persists application data in MySQL. This is configured using the MySQL Helm Chart.

By default this uses container storage. To configure a persistent volume, set `mysql.*` values in the chart values to that which corresponds to your storage requirements.

e.g. to use an existing persistent volume claim for MySQL storage:

```bash
helm install --name testfn --set mysql.persistence.enabled=true,mysql.persistence.existingClaim=tc-fn-mysql fn
```

## Installing the Hybrid Deployment Charts

Clone the fn-helm repo:

```bash
git clone git@github.com:fnproject/fn-helm.git && cd fn-helm
```

### Configure control / work endpoints and other configuration

When deploying a Hybrid Deployment, the two portions of the Fn infrastructure need to be able to communicate, and because they live in different Kubernetes clusters they cannot directly take advantage of the Kubernetes DNS.

Therefore, two configuration variables are _required_ in order to make the deployment work. These need to be set in the `values.yaml` file of both the `fn-controlplane` and `fn-workplane` charts.

Typically, you will have set up domains for your Fn infrastructure, so you will know what the publicly visible URLs for your services should be.

|  Key                       |  Description                                                 |  Default            |
| ---------------------------|--------------------------------------------------------------|---------------------|
| `fn.controlPlaneEndpoint`  | Full external URL of the ingress point for the control plane | (something invalid) |
| `fn.workPlaneEndpoint`     | Full external URL of the ingress point for the work plane    | (something invalid) |

Other configuration variables can still be used as described above. However, the `flow.*`, `ui.*`, `mysql.*` and `redis.*` options only affect the control plane deployment.

### Install control plane

Install chart dependencies from the control plane [requirements.yaml](./fn-controlplane/requirements.yaml):

```bash
helm dep build fn-controlplane
```

To install the chart with the release name `my-controlplane-release`:

```bash
helm install --name my-controlplane-release fn-controlplane
```

### Install work plane

The work plane has no dependencies.

To install the chart with the release name `my-workplane-release`:

```bash
helm install --name my-workplane-release fn-workplane
```


# Fn Project Helm chart

The [Fn project](http://fnproject.io) is an open source, container native, and cloud agnostic serverless platform. It’s easy to use, supports every programming language, and is extensible and performant.

## Introduction

This chart deploys a fully functioning instance of the [Fn](https://github.com/fnproject/fn) platform on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- PV provisioner support in the underlying infrastructure

- Install [Helm](https://github.com/kubernetes/helm#install)

- Install Tiller, the server portion of Helm, to your Kubernetes cluster

```bash
$ helm init --upgrade
```

## Installing the Chart

Clone the fn-helm repo:

```bash
$ git clone git@github.com:fnproject/fn-helm.git && cd fn-helm
```

Install chart dependencies from [requirements.yaml](./fn/requirements.yaml):

```bash
$ helm dep build fn
```

To install the chart with the release name `my-release`:

```bash
$ helm install fn --name my-release
```

> Note: Installing a chart without the `--name` flag will create a new release with an auto-generated name.
Use `helm ls` to list all releases.


## Uninstalling the Fn Helm chart

Assuming your release is named `my-release`:

```bash
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration 

|  Key                           |  Description                      |  Default              |
| -------------------------------|-----------------------------------|-----------------------|
| `fnserver.service.type`        | ClusterIP, NodePort, LoadBalancer | `LoadBalancer`        |
| `fnserver.service.port`        | Service port                      | `80`                  |
| `fnserver.service.annotations` | Service annotations               | `{}`                  |
| `flow.service.type`            | ClusterIP, NodePort, LoadBalancer | `ClusterIP`           |
| `flow.service.port`            | Service port                      | `80`                  |
| `flow.service.annotations`     | Service annotations               | `{}`                  |
| `mysql.*`                      | See the [MySQL chart docs](https://github.com/kubernetes/charts/tree/master/stable/mysql) | |
| `redis.*`                      | See the [Redis chart docs](https://github.com/kubernetes/charts/tree/master/stable/redis) | |
 
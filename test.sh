#!/usr/bin/env bash

set -ex

helm lint fn

helm install --dry-run fn

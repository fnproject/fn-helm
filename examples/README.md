# Minikube Example

## Getting Started

Requirements:
- [minikube](https://github.com/kubernetes/minikube) - refer to the [offical docs](https://kubernetes.io/docs/tasks/tools/install-minikube/) for your OS
- [Helm](https://github.com/kubernetes/helm#install)
- [Fn CLI](https://github.com/fnproject/cli)
    - Homebrew: `brew install fn`
    - shell script: `curl -LSs https://raw.githubusercontent.com/fnproject/cli/master/install | sh`

## Running your first function on Fn

### Getting set up with minikube

Start up a VM with minikube and initialize Helm:

```bash
minikube start --kubernetes-version=v1.7.0
```
```bash
helm init
```

### Installing the Fn Helm Chart

Clone the fn-helm repo if you haven't already:

```bash
git clone git@github.com:fnproject/fn-helm.git && cd fn-helm
```

Install chart dependencies (MySQL, Redis):

```bash
helm dep build fn
```

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release -f examples/minikube/values.yaml fn
NAME:   my-release
LAST DEPLOYED: Tue Dec  5 17:57:27 2017
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Pod(related)
NAME                               READY  STATUS             RESTARTS  AGE
my-release-fn-api-0v509            0/1    ContainerCreating  0         5s
my-release-mysql-3356114717-k0hdt  0/1    Init:0/1           0         5s
my-release-redis-2909260864-4klqd  0/1    ContainerCreating  0         5s

==> v1/Secret
NAME              TYPE    DATA  AGE
my-release-mysql  Opaque  2     5s
my-release-redis  Opaque  1     5s

==> v1/Service
NAME                TYPE       CLUSTER-IP  EXTERNAL-IP  PORT(S)            AGE
my-release-mysql    ClusterIP  10.0.0.79   <none>       3306/TCP           5s
my-release-redis    ClusterIP  10.0.0.15   <none>       6379/TCP           5s
my-release-fn-flow  ClusterIP  10.0.0.11   <none>       80/TCP             5s
my-release-fn-api   ClusterIP  10.0.0.75   <none>       80/TCP             5s
my-release-fn-ui    ClusterIP  10.0.0.57   <none>       3000/TCP,4000/TCP  5s

==> v1beta1/DaemonSet
NAME               DESIRED  CURRENT  READY  UP-TO-DATE  AVAILABLE  NODE SELECTOR  AGE
my-release-fn-api  1        1        0      1           0          <none>         5s

==> v1beta1/Deployment
NAME                     DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
my-release-mysql         1        1        1           0          5s
my-release-redis         1        1        1           0          5s
my-release-fn-flow-depl  1        1        1           0          5s
my-release-fn-ui         1        1        1           0          4s


NOTES:

The Fn service can be accessed within your cluster at:

 - http://my-release-fn-api.default:80/

Set the FN_API_URL environment variable to this address to use the Fn service from outside the cluster:

    export POD_NAME=$(kubectl get pods --namespace default -l "app=my-release-fn,role=fn-service" -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward --namespace default $POD_NAME 8080:80 &
    export FN_API_URL=http://127.0.0.1:8080

############################################################################
###   WARNING: Persistence is disabled!!! You will lose function and     ###
###   flow state when the MySQL pod is terminated.                       ###
###   See the README.md for instructions on configuring persistence.     ###
############################################################################
```


The output of `helm install` will show the steps (depending on the service type) to configure the `FN_API_URL` as needed in the following step.

> Note: if you do not pass the --name flag, a release name will be auto-generated. You can view releases by running helm list (or helm ls, for short).

### Configure Fn CLI

Required environment variables:

1. `FN_API_URL` - See the output of `helm install` for how to set this.
2. `FN_REGISTRY` - Set to your Docker Hub username, or the FQDN of a private registry. e.g. `export FN_REGISTRY=bobloblaw
`

### Writing your function

For this example, we'll be writing a simple Hello World function in Go.

**See our [Getting Started Series](https://github.com/fnproject/fn/tree/master/examples/tutorial) for how to get started writing functions in your favorite language.**

1. First, create a new directory for the function:

```bash
mkdir hello-go && cd $_
```

2. The following is a simple Go program that outputs a string to STDOUT. Copy and paste the code below into a file called `func.go`:

```go
package main

import (
  "fmt"
)

func main() {
  fmt.Println("Hello from Fn!")
}
```

3. Initialize the function. This detects the runtime from the file extension (.go) and creates a `func.yaml`:

```bash
$ fn init
Found go function, assuming go runtime.
func.yaml created.
```

Let's take a look at our func.yaml:

```bash
$ cat func.yaml
version: 0.0.1
runtime: go
entrypoint: ./func
```

4. Test the function locally:

```bash
fn run
```

You should see it output `Hello from Fn!`.

5. Next, let's deploy the function to the Fn server:

```bash
fn deploy --app myapp
```

The deploy command also creates a route on the Fn server, in this case `/hello-go`, which is the name of the directory created in step 1.

We can verify this by running the following command:

```bash
$ fn routes list myapp
path            image                           endpoint
/hello-go       bobloblaw/hello-go:0.0.2        192.168.99.100:32615/r/myapp/hello-go
```

6. Lastly, call the function we just deployed:

```bash
fn call myapp /hello-go

# or via curl
curl 192.168.99.100:32615/r/myapp/hello-go

# or in a browser
http://192.168.99.100:32615/r/myapp/hello-go
```

That's it! You just deployed your first function and called it. To update your function you can update your code and run `fn deploy myapp` again.

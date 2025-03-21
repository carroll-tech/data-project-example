# Helm Charts

This directory contains Helm charts for deploying applications using ArgoCD.

## Available Charts

### hello-world

The `hello-world` chart deploys a simple web application that displays a "Hello World" message. It's designed to be a minimal example for demonstration and testing purposes.

For more information, see the [hello-world README](./hello-world/README.md).

### root-app

The `root-app` chart implements the [App of Apps pattern](https://argo-cd.readthedocs.io/en/latest/operator-manual/cluster-bootstrapping/#app-of-apps-pattern) for ArgoCD. It creates a parent application that manages multiple child applications.

By default, it deploys the local `hello-world` chart included in this repository.

For more information, see the [root-app README](./root-app/README.md).

## Usage

To use these charts with ArgoCD:

1. Add this repository to ArgoCD:

```bash
argocd repo add https://your-repo-url.git
```

2. Create an application using the root-app chart:

```bash
argocd app create root-app \
  --repo https://your-repo-url.git \
  --path charts/root-app \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace argocd
```

3. Sync the application:

```bash
argocd app sync root-app
```

This will deploy the root-app, which will in turn deploy all the child applications defined in its values.yaml file.

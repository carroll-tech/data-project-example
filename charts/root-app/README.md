# ArgoCD App of Apps Pattern

This Helm chart implements the [App of Apps pattern](https://argo-cd.readthedocs.io/en/latest/operator-manual/cluster-bootstrapping/#app-of-apps-pattern) for ArgoCD, allowing you to manage multiple applications through a single parent application.

## Overview

The App of Apps pattern is a way to manage multiple ArgoCD applications through a parent application. This chart creates a parent application that deploys and manages child applications defined in the `values.yaml` file.

## Usage

### Installation

```bash
# Install the chart with the release name "root-app"
helm install root-app ./root-app
```

### Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `applications` | List of applications to be managed | See `values.yaml` |
| `applications[].name` | Name of the application | `hello-world` |
| `applications[].namespace` | Namespace where the application will be deployed | `default` |
| `applications[].project` | ArgoCD project name | `default` |
| `applications[].source.repoURL` | Git repository URL containing the application | `https://github.com/helm/examples.git` |
| `applications[].source.targetRevision` | Git revision to use | `HEAD` |
| `applications[].source.path` | Path within the Git repository | `charts/hello-world` |
| `applications[].destination.server` | Kubernetes API server URL | `https://kubernetes.default.svc` |
| `applications[].destination.namespace` | Target namespace for the application | `default` |
| `applications[].syncPolicy.automated.prune` | Whether to prune resources | `true` |
| `applications[].syncPolicy.automated.selfHeal` | Whether to self-heal | `true` |
| `applications[].syncPolicy.syncOptions` | Sync options | `["CreateNamespace=true"]` |

## Example

The default configuration deploys the [hello-world](https://github.com/helm/examples/tree/main/charts/hello-world) application from the Helm examples repository.

To add more applications, modify the `applications` list in `values.yaml`:

```yaml
applications:
  - name: hello-world
    namespace: default
    project: default
    source:
      repoURL: https://github.com/helm/examples.git
      targetRevision: HEAD
      path: charts/hello-world
      helm:
        valueFiles:
          - values.yaml
    destination:
      server: https://kubernetes.default.svc
      namespace: default
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true
  
  - name: another-app
    namespace: another-namespace
    project: default
    source:
      repoURL: https://github.com/example/repo.git
      targetRevision: main
      path: charts/another-app
    destination:
      server: https://kubernetes.default.svc
      namespace: another-namespace
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true

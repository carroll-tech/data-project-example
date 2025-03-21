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
| `destination.server` | Default Kubernetes API server URL for all applications | `https://kubernetes.default.svc` |
| `defaultSyncPolicy.automated.prune` | Default setting for whether to prune resources for all applications | `true` |
| `defaultSyncPolicy.automated.selfHeal` | Default setting for whether to self-heal for all applications | `true` |
| `defaultSyncPolicy.syncOptions` | Default sync options for all applications | `["CreateNamespace=true"]` |
| `applications` | List of applications to be managed | See `values.yaml` |
| `applications[].name` | Name of the application | `hello-world` |
| `applications[].namespace` | Namespace where the application will be deployed | `default` |
| `applications[].project` | ArgoCD project name | `default` |
| `applications[].source.repoURL` | Git repository URL containing the application | `https://github.com/helm/examples.git` |
| `applications[].source.targetRevision` | Git revision to use | `HEAD` |
| `applications[].source.path` | Path within the Git repository | `charts/hello-world` |
| `applications[].destination.server` | Kubernetes API server URL (defaults to `destination.server` if not specified) | `{{ .Values.destination.server }}` |
| `applications[].destination.namespace` | Target namespace for the application | `default` |
| `applications[].syncPolicy` | (Optional) Override default sync policy for this application | See `defaultSyncPolicy` |

## Example

The default configuration deploys the local `hello-world` chart included in this repository.

To add more applications, modify the `applications` list in `values.yaml`:

```yaml
# Default destination server for all applications
destination:
  server: https://kubernetes.default.svc

# Default sync policy for all applications
defaultSyncPolicy:
  automated:
    prune: true
    selfHeal: true
  syncOptions:
    - CreateNamespace=true

applications:
  - name: hello-world
    namespace: default
    project: default
    source:
      # Using local chart from this repository
      repoURL: {{ .Values.spec.source.repoURL }}
      targetRevision: {{ .Values.spec.source.targetRevision }}
      path: charts/hello-world
      helm:
        valueFiles:
          - values.yaml
    destination:
      # Uses the default server from destination.server
      namespace: default
    # No syncPolicy specified, will use defaultSyncPolicy
  
  - name: another-app
    namespace: another-namespace
    project: default
    source:
      repoURL: https://github.com/example/repo.git
      targetRevision: main
      path: charts/another-app
    destination:
      # You can override the default server for specific applications
      server: https://another-cluster.example.com
      namespace: another-namespace
    # Override default sync policy for this specific application
    syncPolicy:
      automated:
        prune: false  # Override default value
        selfHeal: true
      syncOptions:
        - CreateNamespace=true
        - ApplyOutOfSyncOnly=true  # Additional option not in default

# Hello World Helm Chart

A simple Hello World application chart for Kubernetes.

## Introduction

This chart deploys a basic web application that displays a "Hello World" message. It's designed to be a minimal example for demonstration and testing purposes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `hello-world`:

```bash
helm install hello-world ./hello-world
```

## Configuration

The following table lists the configurable parameters of the hello-world chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `nginx` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag | `""` (defaults to chart appVersion) |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Kubernetes service port | `80` |
| `ingress.enabled` | Enable ingress | `false` |

## Usage with ArgoCD

This chart is designed to be used with ArgoCD through the root-app chart in this repository. The root-app implements the App of Apps pattern for ArgoCD, allowing you to manage multiple applications through a single parent application.

To deploy this chart using ArgoCD and the root-app:

1. Deploy the root-app chart
2. The hello-world application will be automatically deployed as a child application

For more information, see the [root-app README](../root-app/README.md).

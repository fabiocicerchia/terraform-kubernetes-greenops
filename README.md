# Terraform Module for GreenOps

Comprehensive Terraform module for deploying a complete green operations monitoring stack on Kubernetes. Includes Prometheus, KEDA, OpenCost, Kepler Operator, Scaphandre, KubeGreen, Carbon Intensity Exporter, and Cloud Carbon Footprint with individual toggles for selective component deployment.

## Overview

The GreenOps Module provides a unified way to deploy and manage:

- **Prometheus** - Metrics collection and storage with `kube-prometheus-stack`
- **KEDA** - Kubernetes Event Driven Autoscaling with optional example deployments
- **OpenCost** - Cost monitoring and allocation with carbon cost tracking
- **Kepler** - Environmental impact tracking via the Kepler Operator with optional power monitoring
- **Scaphandre** - Container-level power consumption monitoring
- **KubeGreen** - Automated resource cleanup and pod hibernation for cost optimisation
- **Carbon Intensity Exporter** - Grid carbon intensity metrics for location-aware scheduling
- **Cloud Carbon Footprint** - Cloud infrastructure carbon emissions tracking

All components are **enabled by default** and can be selectively disabled based on your requirements.

## Features

- **Selective Deployment**: Enable or disable components individually via feature toggles
- **Prometheus Monitoring**: Complete monitoring and metrics stack with Grafana
- **KEDA Autoscaling**: Event-driven workload scaling with optional examples
- **OpenCost**: Cloud cost monitoring and allocation with carbon tracking
- **Kepler Operator**: Environmental impact and power consumption tracking
- **Scaphandre**: Container-level power consumption monitoring
- **KubeGreen**: Automated resource cleanup and pod hibernation
- **Carbon Intensity Exporter**: Grid carbon intensity metrics for location-aware scheduling
- **Cloud Carbon Footprint**: Cloud infrastructure carbon emissions tracking
- **Flexible Configuration**: Customize each component independently with HCL values

## Dependencies

**Important:** OpenCost, Kepler, KEDA, and Scaphandre require Prometheus to function properly. You must either:
- Deploy Prometheus via this module (enabled by default), or
- Configure them to use an external Prometheus instance

If you disable Prometheus in this module, ensure you configure OpenCost, Kepler, KEDA, and Scaphandre to connect to your existing Prometheus deployment via their `values` configuration. KEDA's `ScaledObject` resources need to reference Prometheus for metrics-based scaling.

**Kepler Requirement:** Kepler requires [cert-manager](https://cert-manager.io/) to be installed in your cluster before deployment. Without cert-manager, Kepler will not function properly. You can install it using:
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
```

## Quick Links

- [Requirements](REQUIREMENTS.md) - Technical requirements and dependencies

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 or OpenTofu >= 1.6 |
| helm | >= 2.0 |
| null | >= 3.0 |

### External Requirements

- [kubectl](https://kubernetes.io/docs/tasks/tools/) - For interacting with your Kubernetes cluster
- [Kubernetes cluster](https://kubernetes.io/docs/setup/) - A running Kubernetes cluster (v1.24+)

## Usage

### Deploy All Components (Default)

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"
}
```

All eight components (Prometheus, KEDA, OpenCost, Kepler, Scaphandre, KubeGreen, Carbon Intensity Exporter, and Cloud Carbon Footprint) are **enabled by default**.

### Disable Specific Components

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  prometheus = {
    enabled = true
  }

  keda = {
    enabled = false  # Disable KEDA
  }

  opencost = {
    enabled = true
  }

  kepler = {
    enabled = true
  }

  scaphandre = {
    enabled = false  # Disable Scaphandre
  }

  kubegreen = {
    enabled = true
  }
}
```

### Custom Configuration

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  prometheus = {
    enabled      = true
    namespace    = "custom-monitoring"
    release_name = "prom"
    values = {
      prometheus = {
        prometheusSpec = {
          retention = "30d"
        }
      }
    }
  }

  keda = {
    enabled        = true
    namespace      = "custom-keda"
    deploy_example = false
    values         = {}
  }

  opencost = {
    enabled = true
    values = {
      opencost = {
        carbonCost = {
          enabled = true
        }
      }
    }
  }

  kepler = {
    enabled             = true
    namespace           = "sustainability"
    deploy_powermonitor = true
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prometheus | Prometheus module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| keda | KEDA module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| opencost | OpenCost module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| kepler | Kepler module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| scaphandre | Scaphandre module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| kubegreen | KubeGreen module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| carbon_intensity_exporter | Carbon Intensity Exporter module configuration | `object({...})` | `{ enabled = true, ... }` | no |
| cloud_carbon_footprint | Cloud Carbon Footprint module configuration | `object({...})` | `{ enabled = true, ... }` | no |

### Detailed Input Schema

#### prometheus
```hcl
prometheus = {
  enabled      = bool                    # Enable Prometheus (default: true)
  release_name = string                  # Helm release name (default: "prometheus-community")
  namespace    = string                  # Kubernetes namespace (default: "monitoring")
  values       = any                     # Helm chart values (default: {...})
}
```

#### keda
```hcl
keda = {
  enabled        = bool                  # Enable KEDA (default: true)
  release_name   = string                # Helm release name (default: "kedacore")
  namespace      = string                # Kubernetes namespace (default: "keda")
  values         = any                   # Helm chart values (default: {})
  deploy_example = bool                  # Deploy example manifests (default: true)
  manifest_path  = string                # Path to example manifest (default: "keda.yaml")
}
```

#### opencost
```hcl
opencost = {
  enabled      = bool                    # Enable OpenCost (default: true)
  release_name = string                  # Helm release name (default: "opencost-charts")
  namespace    = string                  # Kubernetes namespace (default: "opencost")
  values       = any                     # Helm chart values (default: {...})
}
```

#### kepler
```hcl
kepler = {
  enabled             = bool             # Enable Kepler (default: true)
  release_name        = string           # Helm release name (default: "kepler-operator")
  namespace           = string           # Kubernetes namespace (default: "kepler-operator")
  values              = any              # Helm chart values (default: {...})
  deploy_powermonitor = bool             # Deploy PowerMonitor (default: true)
}
```

#### scaphandre
```hcl = bool                    # Enable Scaphandre (default: true)
  release_name  = string                  # Helm release name (default: "scaphandre")
  namespace     = string                  # Kubernetes namespace (default: "scaphandre")
  values        = any                     # Helm chart values (default: {})
  chart_version = string                  # Helm chart version (default: "" for latest)
}
```

#### kubegreen
```hcl
kubegreen = {
  enabled       = bool                    # Enable KubeGreen (default: true)
  release_name  = string                  # Helm release name (default: "kube-green")
  namespace     = string                  # Kubernetes namespace (default: "kube-green")
  values        = any                     # Helm chart values (default: {})
  chart_version = string                  # Helm chart version (default: "" for latest)
}
```

#### Chart Version Management

All modules support `chart_version` parameter:
- **Empty string (`""`)** - Deploy with the latest available Helm chart version (default)
- **Specific version** - Pin to an exact version (e.g., `"50.0.0"`)

Example:
```hcl
prometheus = {
  enabled       = true
  chart_version = "55.0.0"  # Pin to specific version
}

keda = {
  enabled       = true
  chart_version = ""        # Use latest (defaultube-green")
  namespace    = string                  # Kubernetes namespace (default: "kube-green")
  values       = any                     # Helm chart values (default: {})
}
```

## Outputs

The module provides outputs organised in nested objects for better structure:

### prometheus
Prometheus module outputs (if enabled):
```hcl
prometheus = {
  namespace    = string  # Kubernetes namespace where Prometheus is deployed
  release_name = string  # Helm release name of Prometheus
  version      = string  # Chart version deployed
}
```

### keda
KEDA module outputs (if enabled):
```hcl
keda = {
  namespace    = string  # Kubernetes namespace where KEDA is deployed
  release_name = string  # Helm release name of KEDA
  version      = string  # Chart version deployed
}
```

### opencost
OpenCost module outputs (if enabled):
```hcl
opencost = {
  namespace    = string  # Kubernetes namespace where OpenCost is deployed
  release_name = string  # Helm release name of OpenCost
  version      = string  # Chart version deployed
}
```

### kepler
Kepler module outputs (if enabled):
```hcl
kepler = {
  namespace    = string  # Kubernetes namespace where Kepler is deployed
  release_name = string  # Helm release name of Kepler
  version      = string  # Chart version deployed
}
```

### scaphandre
Scaphandre module outputs (if enabled):
```hcl
scaphandre = {
  namespace    = string  # Kubernetes namespace where Scaphandre is deployed
  release_name = string  # Helm release name of Scaphandre
  version      = string  # Chart version deployed
}
```

### kubegreen
KubeGreen module outputs (if enabled):
```hcl
kubegreen = {
  namespace    = string  # Kubernetes namespace where KubeGreen is deployed
  release_name = string  # Helm release name of KubeGreen
  version      = string  # Chart version deployed
}
```

### carbon_intensity_exporter
Carbon Intensity Exporter module outputs (if enabled):
```hcl
carbon_intensity_exporter = {
  namespace    = string  # Kubernetes namespace where Carbon Intensity Exporter is deployed
  release_name = string  # Helm release name of Carbon Intensity Exporter
  version      = string  # Chart version deployed
}
```

### cloud_carbon_footprint
Cloud Carbon Footprint module outputs (if enabled):
```hcl
cloud_carbon_footprint = {
  namespace    = string  # Kubernetes namespace where Cloud Carbon Footprint is deployed
  release_name = string  # Helm release name of Cloud Carbon Footprint
  version      = string  # Chart version deployed
}
```

### deployed_components
Map showing which components are enabled:
```hcl
deployed_components = {
  prometheus                = bool  # true if Prometheus is enabled
  keda                      = bool  # true if KEDA is enabled
  opencost                  = bool  # true if OpenCost is enabled
  kepler                    = bool  # true if Kepler is enabled
  scaphandre                = bool  # true if Scaphandre is enabled
  kubegreen                 = bool  # true if KubeGreen is enabled
  carbon_intensity_exporter = bool  # true if Carbon Intensity Exporter is enabled
  cloud_carbon_footprint    = bool  # true if Cloud Carbon Footprint is enabled
}
```

## Configuration Examples

### Minimal Deployment

Only enable Prometheus for basic monitoring:

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  prometheus = { enabled = true }
  keda       = { enabled = false }
  opencost   = { enabled = false }
  kepler     = { enabled = false }
}
```

### Cost Tracking Focus

Enable Prometheus and OpenCost for cost visibility:

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  prometheus = { enabled = true }
  opencost   = { enabled = true }
}
```

### Sustainability Monitoring

Complete stack for environmental tracking:

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  # All enabled by default, just provide custom values if needed
  prometheus = {
    enabled = true
  }

  opencost = {
    enabled = true
  }

  kepler = {
    enabled = true
  }

  scaphandre = {
    enabled = true  # Enable for container-level power monitoring
  }

  kubegreen = {
    enabled = true  # Enable for resource cleanup and pod hibernation
  }

  carbon_intensity_exporter = {
    enabled = true  # Enable for grid carbon intensity metrics
  }

  cloud_carbon_footprint = {
    enabled = true  # Enable for cloud infrastructure carbon tracking
  }
}
```

## Using Different Git References

Deploy from specific tags, branches, or commits:

```hcl
module "greenops" {
  source = "https://github.com/fabiocicerchia/terraform-kubernetes-greenops.git?ref=v1.0.0"
  # or use: ref=develop, ref=main, ref=abc1234 (commit SHA)
}
```

## Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0 or [OpenTofu](https://opentofu.org/docs/intro/install/)
- [Kubernetes](https://kubernetes.io/) cluster (v1.24+)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/) configured to access your cluster
- [Helm](https://helm.sh/) (provider handles installation)

## Local Development with Minikube

### Start Minikube

```bash
minikube start --kubernetes-version=v1.34.0
minikube addons enable metrics-server
kubectl config use-context minikube && kubectl config current-context
```

### Deploy the Stack

```bash
terraform init
terraform apply
```

## Troubleshooting

### Check Deployment Status

```bash
# Check all pods across all namespaces
kubectl get pods -A
```

### Access Services Locally

Get Grafana admin password:

```bash
kubectl --namespace monitoring get secrets prometheus-community-grafana \
  -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```

Port forward services:

```bash
# Prometheus
kubectl port-forward -n monitoring svc/prometheus-community-kube-prometheus 9090:9090

# Grafana (part of Prometheus)
kubectl port-forward -n monitoring svc/prometheus-community-grafana 3000:80

# OpenCost UI
kubectl port-forward -n opencost svc/opencost-charts 9091:9090

# Cloud Carbon Footprint
kubectl port-forward -n cloud-carbon-footprint svc/cloud-carbon-footprint-client 8080:80
```

## License

MIT

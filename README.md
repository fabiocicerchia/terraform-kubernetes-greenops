# 🌱 Terraform Module for GreenOps

Comprehensive Terraform module for deploying a complete green operations monitoring stack on Kubernetes. Includes Prometheus, KEDA, OpenCost, Kepler Operator, Scaphandre, KubeGreen, Carbon Intensity Exporter, Cloud Carbon Footprint, and CodeCarbon with individual toggles for selective component deployment.

## Overview

The GreenOps Module provides a unified way to deploy and manage:

- **Observability & Scaling Infrastructure**:
  - **Prometheus** - Metrics collection and storage with `kube-prometheus-stack`
  - **KEDA** - Kubernetes Event Driven Autoscaling with optional example deployments
- **Cost & Resource Efficiency**:
  - **OpenCost** - Cost monitoring and allocation with carbon cost tracking
- **Energy & Power Monitoring**:
  - **Kepler** - Environmental impact tracking via the Kepler Operator with optional power monitoring
  - **Scaphandre** - Container-level power consumption monitoring
- **Carbon & Emissions Estimation**:
  - **Carbon Intensity Exporter** - Grid carbon intensity metrics for location-aware scheduling
  - **Cloud Carbon Footprint** - Cloud infrastructure carbon emissions tracking
  - **CodeCarbon** - Python code carbon emissions tracking
- **Sustainability Optimisation & Automation**:
  - **KubeGreen** - Automated resource cleanup and pod hibernation for cost optimisation

All components are **enabled by default** and can be selectively disabled based on your requirements.

## Why This Matters

Sustainable computing is no longer just about hardware—it's about how software consumes resources. **GreenOps** sits at the intersection of FinOps and DevOps, enabling you to:

- 👁️ **Observe**: Gain visibility into the real-time energy and carbon footprint of your clusters (Kepler, Scaphandre).
- 📉 **Optimise**: Automatically reduce waste by scaling down idle resources (KEDA) and hibernating non-production environments (KubeGreen).
- 💰 **Attribute**: Connect carbon emissions directly to financial costs for better accountability (OpenCost).
- 🧪 **Measure**: Quantify the environmental impact of your software code (CodeCarbon).

Efficient infrastructure is **cheaper, faster, and greener**.

## Easy to Adopt

- 🚀 **Unified Deployment**: Manage 10+ sustainability tools with a single Terraform module, no "dependency hell."
- 🎛️ **Simple Configuration**: Toggles for every component mean you can start small (e.g., just Prometheus + OpenCost) and expand later.
- 🔄 **Standard Interfaces**: Built on top of Cloud Native standards (Prometheus, Grafana, Helm), integrating seamlessly with your existing stack.
- 🛡️ **Non-Intrusive**: Most components run as sidecars, daemonsets, or operators without requiring changes to your application code.

## Environmental Impact in Practice

### What This Stack Optimises

- **Idle Resource Waste**: Automatically shut down development and testing environments off-hours with KubeGreen.
- **Over-Provisioning**: Use real-time metrics to right-size workloads and infrastructure.
- **Energy Transparency**: Shift from "estimated" to "measured" energy usage for accurate ESG reporting.
- **Carbon-cost Trade-offs**: Make informed decisions balancing performance, cost, and carbon footprint.

### What It Does Not Do (By Default)

- ❌ **Rewrite your application**: It provides the data (CodeCarbon) to identify inefficient code, but the fix is up to you.
- ❌ **Compromise availability**: Optimisation tools like KubeGreen are strictly opt-in and configurable per-namespace.

This module provides the **foundation and tooling** to practice GreenOps effectively.

## Dependencies

**Important:** OpenCost, Kepler, KEDA, and Scaphandre require Prometheus to function properly. You must either:
- Deploy Prometheus via this module (enabled by default), or
- Configure them to use an external Prometheus instance

If you disable Prometheus in this module, ensure you configure OpenCost, Kepler, KEDA, and Scaphandre to connect to your existing Prometheus deployment via their `values` configuration. KEDA's `ScaledObject` resources need to reference Prometheus for metrics-based scaling.

**Kepler Requirement:** Kepler requires [cert-manager](https://cert-manager.io/) to be installed in your cluster before deployment. Without cert-manager, Kepler will not function properly. You can install it using:
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 or OpenTofu >= 1.6 |
| helm | >= 2.0 |
| null | >= 3.0 |

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0 or [OpenTofu](https://opentofu.org/docs/intro/install/)
- [Kubernetes](https://kubernetes.io/) cluster (v1.24+)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/) configured to access your cluster
- [Helm](https://helm.sh/) (provider handles installation)

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

All ten components are **enabled by default** and can be selectively disabled based on your requirements.

### Disable Specific Components

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  observability = {
    prometheus = {
      enabled = true
    }
    keda = {
      enabled = false
    }
  }

  cost_efficiency = {
    opencost = {
      enabled = true
    }
  }

  energy_power = {
    kepler = {
      enabled = true
    }
    scaphandre = {
      enabled = false
    }
  }

  sustainability_optimisation = {
    kubegreen = {
      enabled = true
    }
  }
}
```

### Custom Configuration

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  observability = {
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
  }

  cost_efficiency = {
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
  }

  energy_power = {
    kepler = {
      enabled             = true
      namespace           = "sustainability"
      deploy_powermonitor = true
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| observability | Observability and scaling tools (Prometheus, KEDA) | `object({...})` | `{}` | no |
| cost_efficiency | Cost and resource efficiency tools (OpenCost) | `object({...})` | `{}` | no |
| energy_power | Energy and power monitoring tools (Kepler, Scaphandre) | `object({...})` | `{}` | no |
| carbon_emissions | Carbon and emissions estimation tools (IE, CCF, CodeCarbon) | `object({...})` | `{}` | no |
| sustainability_optimisation | Sustainability optimisation tools (KubeGreen) | `object({...})` | `{}` | no |

### Detailed Input Schema

#### observability
```hcl
observability = {
  prometheus = optional(object({
    enabled       = bool                    # Enable Prometheus (default: true)
    release_name  = optional(string)        # Helm release name
    namespace     = optional(string)        # Kubernetes namespace
    values        = optional(any)           # Helm chart values
    chart_version = optional(string)        # Helm chart version
  }))
  keda = optional(object({
    enabled        = bool                   # Enable KEDA (default: true)
    release_name   = optional(string)       # Helm release name
    namespace      = optional(string)       # Kubernetes namespace
    values         = optional(any)          # Helm chart values
    deploy_example = optional(bool)         # Deploy example manifests
    manifest_path  = optional(string)       # Path to example manifest
    chart_version  = optional(string)       # Helm chart version
  }))
}
```

#### cost_efficiency
```hcl
cost_efficiency = {
  opencost = optional(object({
    enabled       = bool                    # Enable OpenCost (default: true)
    release_name  = optional(string)        # Helm release name
    namespace     = optional(string)        # Kubernetes namespace
    values        = optional(any)           # Helm chart values
    chart_version = optional(string)        # Helm chart version
  }))
}
```

#### energy_power
```hcl
energy_power = {
  kepler = optional(object({
    enabled             = bool              # Enable Kepler (default: true)
    release_name        = optional(string)  # Helm release name
    namespace           = optional(string)  # Kubernetes namespace
    values              = optional(any)     # Helm chart values
    deploy_powermonitor = optional(bool)    # Deploy PowerMonitor
    chart_version       = optional(string)  # Helm chart version
  }))
  scaphandre = optional(object({
    enabled       = bool                    # Enable Scaphandre (default: true)
    release_name  = optional(string)        # Helm release name
    namespace     = optional(string)        # Kubernetes namespace
    values        = optional(any)           # Helm chart values
    chart_version = optional(string)        # Helm chart version
  }))
}
```

#### carbon_emissions
```hcl
carbon_emissions = {
  carbon_intensity_exporter = optional(object({
    enabled       = bool                    # Enable Carbon Intensity Exporter (default: true)
    release_name  = optional(string)        # Helm release name
    namespace     = optional(string)        # Kubernetes namespace
    values        = optional(any)           # Helm chart values
    chart_version = optional(string)        # Helm chart version
  }))
  cloud_carbon_footprint = optional(object({
    enabled       = bool                    # Enable Cloud Carbon Footprint (default: true)
    release_name  = optional(string)        # Helm release name
    namespace     = optional(string)        # Kubernetes namespace
    values        = optional(any)           # Helm chart values
    chart_version = optional(string)        # Helm chart version
  }))
  codecarbon = optional(object({
    enabled         = bool                  # Enable CodeCarbon (default: true)
    name            = optional(string)      # Release name
    namespace       = optional(string)      # Kubernetes namespace
    image           = optional(string)      # Docker image
    api_endpoint    = optional(string)      # CodeCarbon API endpoint
    organization_id = optional(string)      # Organization ID
    project_id      = optional(string)      # Project ID
    experiment_id   = optional(string)      # Experiment ID
    api_key         = optional(string)      # API Key
  }))
}
```

#### sustainability_optimisation
```hcl
sustainability_optimisation = {
  kubegreen = optional(object({
    enabled       = bool                    # Enable KubeGreen (default: true)
    release_name  = optional(string)        # Helm release name
    namespace     = optional(string)        # Kubernetes namespace
    values        = optional(any)           # Helm chart values
    chart_version = optional(string)        # Helm chart version
  }))
}
```

#### Chart Version Management

All modules support `chart_version` parameter within their respective configuration blocks.
If set to `""` (empty string) or omitted, it will deploy the latest available Helm chart version.


## Outputs

The module provides outputs organised in nested objects for better structure:

### observability
Observability and scaling outputs:
```hcl
observability = {
  prometheus = {
    namespace    = string
    release_name = string
    version      = string
  }
  keda = {
    namespace    = string
    release_name = string
    version      = string
  }
}
```

### cost_efficiency
Cost and resource efficiency outputs:
```hcl
cost_efficiency = {
  opencost = {
    namespace    = string
    release_name = string
    version      = string
  }
}
```

### energy_power
Energy and power monitoring outputs:
```hcl
energy_power = {
  kepler = {
    namespace    = string
    release_name = string
    version      = string
  }
  scaphandre = {
    namespace    = string
    release_name = string
    version      = string
  }
}
```

### sustainability_optimisation
Sustainability optimisation outputs:
```hcl
sustainability_optimisation = {
  kubegreen = {
    namespace    = string
    release_name = string
    version      = string
  }
}
```

### carbon_emissions
Carbon and emissions estimation outputs:
```hcl
carbon_emissions = {
  carbon_intensity_exporter = {
    namespace    = string
    release_name = string
    version      = string
  }
  cloud_carbon_footprint = {
    namespace          = string
    release_name       = string
    version            = string
    client_service_url = string
    api_service_url    = string
  }
  codecarbon = {
    namespace    = string
    release_name = string
    version      = string
  }
}
```

### deployed_components
Map showing which components are enabled:
```hcl
deployed_components = {
  observability = {
    prometheus = bool
    keda       = bool
  }
  cost_efficiency = {
    opencost = bool
  }
  energy_power = {
    kepler     = bool
    scaphandre = bool
  }
  sustainability_optimisation = {
    kubegreen          = bool
  }
  carbon_emissions = {
    carbon_intensity_exporter = bool
    cloud_carbon_footprint    = bool
    codecarbon                = bool
  }
}
```

## Configuration Examples

### Minimal Deployment

Only enable Prometheus for basic monitoring:

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  observability = {
    prometheus = { enabled = true }
    keda       = { enabled = false }
  }
  cost_efficiency = {
    opencost = { enabled = false }
  }
  energy_power = {
    kepler     = { enabled = false }
  }
}
```

### Cost Tracking Focus

Enable Prometheus and OpenCost for cost visibility:

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  observability = {
    prometheus = { enabled = true }
  }
  cost_efficiency = {
    opencost   = { enabled = true }
  }
}
```

### Sustainability Monitoring

Complete stack for environmental tracking:

```hcl
module "greenops" {
  source = "fabiocicerchia/greenops/kubernetes"

  # All enabled by default, just provide custom values if needed
  observability = {
    prometheus = {
      enabled = true
    }
  }

  cost_efficiency = {
    opencost = {
      enabled = true
    }
  }

  energy_power = {
    kepler = {
      enabled = true
    }
    scaphandre = {
      enabled = true  # Enable for container-level power monitoring
    }
  }

  sustainability_optimisation = {
    kubegreen = {
      enabled = true  # Enable for resource cleanup and pod hibernation
    }
  }

  carbon_emissions = {
    carbon_intensity_exporter = {
      enabled = true  # Enable for grid carbon intensity metrics
    }
    cloud_carbon_footprint = {
      enabled = true  # Enable for cloud infrastructure carbon tracking
    }
    codecarbon = {
      enabled = true  # Enable for Python code carbon emissions tracking
    }
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

Test the carbon-intensity-exporter:

```bash
kubectl get configmap -n carbon-intensity-exporter carbon-intensity -o jsonpath="{.binaryData.data}" | base64 -d ; echo
```

## License

MIT

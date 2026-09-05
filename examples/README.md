# GreenOps Module Examples

Examples showing how to use the GreenOps Terraform module, from simple observability to advanced optimization.

## Which Example Should I Use?

### I'm new to GreenOps

→ Start with [`tier1-observe-only.tf`](tier1-observe-only.tf)

### I want to track carbon emissions for reporting

→ Use [`tier2-measure-carbon.tf`](tier2-measure-carbon.tf)

### I have baseline metrics and want to optimize

→ Use [`tier3-optimize-automate.tf`](tier3-optimize-automate.tf)

## Feature Comparison

| Feature                          | Tier 1            | Tier 2       | Tier 3     |
| -------------------------------- | ----------------- | ------------ | ---------- |
| Energy metrics (Kepler)          | ✅                | ✅           | ✅         |
| Cost tracking (OpenCost)         | ✅                | ✅           | ✅         |
| Prometheus monitoring            | ✅                | ✅           | ✅         |
| App carbon tracking (CodeCarbon) | ✅                | ✅           | ✅         |
| Carbon intensity tracking        | ❌                | ✅           | ✅         |
| Cloud carbon footprint           | ❌                | ✅           | ✅         |
| Autoscaling (KEDA)               | ❌                | ❌           | ✅         |
| Automated shutdown (KubeGreen)   | ❌                | ❌           | ✅         |
| **Automation risk**              | None              | None         | High       |
| **Config complexity**            | Low               | Medium       | High       |
| **External dependencies**        | cert-manager only | + Cloud APIs | + Policies |

## 🚀 Quick Start

```bash
# Copy the example you want
cp examples/tier1-observe-only.tf main.tf

# Set your kubectl context (optional)
# Edit main.tf and set: kubectl_context = "your-cluster"

# Initialize and apply
terraform init
terraform apply
```

## Files in this Directory

### Tier Examples

- [`tier1-observe-only.tf`](tier1-observe-only.tf) - Observability only (recommended start)
- [`tier2-measure-carbon.tf`](tier2-measure-carbon.tf) - Add carbon tracking
- [`tier3-optimize-automate.tf`](tier3-optimize-automate.tf) - Enable automation (advanced)

### Configuration Examples

- [`kubegreen-sleepinfo.yaml`](kubegreen-sleepinfo.yaml) - Automated shutdown schedules
- [`keda-scaledobject.yaml`](keda-scaledobject.yaml) - Autoscaling policies

## Important: Tier 3 Requires Planning

Before enabling automation:

- ✅ Have 2-4 weeks of baseline metrics
- ✅ Test in non-production first
- ✅ Define clear policies
- ✅ Configure exclusions for critical services

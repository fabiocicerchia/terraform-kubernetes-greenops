# ------------------------------------------------------------------------------
# Category: Observability & Scaling Infrastructure
# ------------------------------------------------------------------------------
variable "observability" {
  description = "Observability and scaling tools"
  type = object({
    prometheus = optional(object({
      enabled       = bool
      release_name  = optional(string, "prometheus-community")
      namespace     = optional(string, "monitoring")
      values        = optional(any, {})
      chart_version = optional(string, "")
    }), { enabled = true })
    keda = optional(object({
      enabled        = bool
      release_name   = optional(string, "kedacore")
      namespace      = optional(string, "keda")
      values         = optional(any, {})
      deploy_example = optional(bool, true)
      manifest_path  = optional(string, "keda.yaml")
      chart_version  = optional(string, "")
    }), { enabled = true })
  })
  default = {}
}

# ------------------------------------------------------------------------------
# Category: Cost & Resource Efficiency
# ------------------------------------------------------------------------------
variable "cost_efficiency" {
  description = "Cost and resource efficiency tools"
  type = object({
    opencost = optional(object({
      enabled       = bool
      release_name  = optional(string, "opencost-charts")
      namespace     = optional(string, "opencost")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = true })
  })
  default = {}
}

# ------------------------------------------------------------------------------
# Category: Energy & Power Monitoring
# ------------------------------------------------------------------------------
variable "energy_power" {
  description = "Energy and power monitoring tools"
  type = object({
    kepler = optional(object({
      enabled             = bool
      release_name        = optional(string, "kepler-operator")
      namespace           = optional(string, "kepler-operator")
      values              = optional(any, {})
      chart_version       = optional(string, "")
      deploy_powermonitor = optional(bool, true)
    }), { enabled = true })
    scaphandre = optional(object({
      enabled       = bool
      release_name  = optional(string, "scaphandre")
      namespace     = optional(string, "scaphandre")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = true })
  })
  default = {}
}

# ------------------------------------------------------------------------------
# Category: Carbon & Emissions Estimation
# ------------------------------------------------------------------------------
variable "carbon_emissions" {
  description = "Carbon and emissions estimation tools"
  type = object({
    carbon_intensity_exporter = optional(object({
      enabled       = bool
      release_name  = optional(string, "carbon-intensity-exporter")
      namespace     = optional(string, "carbon-intensity-exporter")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = true })
    cloud_carbon_footprint = optional(object({
      enabled       = bool
      release_name  = optional(string, "cloud-carbon-footprint")
      namespace     = optional(string, "cloud-carbon-footprint")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = true })
    codecarbon = optional(object({
      enabled         = bool
      name            = optional(string, "codecarbon")
      namespace       = optional(string, "codecarbon")
      image           = optional(string, "fabiocicerchia/codecarbon:latest")
      api_endpoint    = optional(string, "https://api.codecarbon.io")
      organization_id = optional(string, "")
      project_id      = optional(string, "")
      experiment_id   = optional(string, "")
      api_key         = optional(string, "")
    }), { enabled = true })
  })
  default   = {}
  sensitive = true
}

# ------------------------------------------------------------------------------
# Category: Sustainability Optimisation & Automation
# ------------------------------------------------------------------------------
variable "sustainability_optimisation" {
  description = "Sustainability optimisation and automation tools"
  type = object({
    kubegreen = optional(object({
      enabled       = bool
      release_name  = optional(string, "kube-green")
      namespace     = optional(string, "kube-green")
      chart_version = optional(string, "")
      values        = optional(any, {})
    }), { enabled = true })
  })
  default = {}
}

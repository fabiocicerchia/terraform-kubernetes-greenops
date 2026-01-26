module "prometheus" {
  count  = var.observability.prometheus.enabled ? 1 : 0
  source = "fabiocicerchia/prometheus-stack/helm"

  providers = {
    helm = helm
  }

  release_name  = var.observability.prometheus.release_name
  namespace     = var.observability.prometheus.namespace
  values        = var.observability.prometheus.values
  chart_version = var.observability.prometheus.chart_version
}

module "keda" {
  count  = var.observability.keda.enabled ? 1 : 0
  source = "fabiocicerchia/keda/helm"

  providers = {
    helm = helm
  }

  release_name   = var.observability.keda.release_name
  namespace      = var.observability.keda.namespace
  values         = var.observability.keda.values
  deploy_example = var.observability.keda.deploy_example
  manifest_path  = var.observability.keda.manifest_path
  chart_version  = var.observability.keda.chart_version
}

module "opencost" {
  count  = var.cost_efficiency.opencost.enabled ? 1 : 0
  source = "fabiocicerchia/opencost/helm"

  providers = {
    helm = helm
  }

  release_name  = var.cost_efficiency.opencost.release_name
  namespace     = var.cost_efficiency.opencost.namespace
  chart_version = var.cost_efficiency.opencost.chart_version
  values        = var.cost_efficiency.opencost.values
}

module "kepler" {
  count  = var.energy_power.kepler.enabled ? 1 : 0
  source = "fabiocicerchia/kepler/helm"

  providers = {
    helm = helm
  }

  release_name        = var.energy_power.kepler.release_name
  namespace           = var.energy_power.kepler.namespace
  values              = var.energy_power.kepler.values
  chart_version       = var.energy_power.kepler.chart_version
  deploy_powermonitor = var.energy_power.kepler.deploy_powermonitor
}

module "scaphandre" {
  count  = var.energy_power.scaphandre.enabled ? 1 : 0
  source = "fabiocicerchia/scaphandre/helm"

  providers = {
    helm = helm
  }

  release_name  = var.energy_power.scaphandre.release_name
  namespace     = var.energy_power.scaphandre.namespace
  chart_version = var.energy_power.scaphandre.chart_version
  values        = var.energy_power.scaphandre.values
}

module "kubegreen" {
  count  = var.sustainability_optimisation.kubegreen.enabled ? 1 : 0
  source = "fabiocicerchia/kubegreen/helm"

  providers = {
    helm = helm
  }

  release_name  = var.sustainability_optimisation.kubegreen.release_name
  chart_version = var.sustainability_optimisation.kubegreen.chart_version
  namespace     = var.sustainability_optimisation.kubegreen.namespace
  values        = var.sustainability_optimisation.kubegreen.values
}

module "carbon_intensity_exporter" {
  count  = var.carbon_emissions.carbon_intensity_exporter.enabled ? 1 : 0
  source = "fabiocicerchia/carbon-intensity-exporter/helm"

  providers = {
    helm = helm
  }

  release_name  = var.carbon_emissions.carbon_intensity_exporter.release_name
  namespace     = var.carbon_emissions.carbon_intensity_exporter.namespace
  chart_version = var.carbon_emissions.carbon_intensity_exporter.chart_version
  values        = var.carbon_emissions.carbon_intensity_exporter.values
}

module "cloud_carbon_footprint" {
  count  = var.carbon_emissions.cloud_carbon_footprint.enabled ? 1 : 0
  source = "fabiocicerchia/cloud-carbon-footprint/helm"

  providers = {
    helm = helm
  }

  release_name  = var.carbon_emissions.cloud_carbon_footprint.release_name
  namespace     = var.carbon_emissions.cloud_carbon_footprint.namespace
  chart_version = var.carbon_emissions.cloud_carbon_footprint.chart_version
  values        = var.carbon_emissions.cloud_carbon_footprint.values
}

module "codecarbon" {
  count  = var.carbon_emissions.codecarbon.enabled ? 1 : 0
  source = "fabiocicerchia/codecarbon/kubernetes"

  providers = {
    kubectl = kubectl
  }

  name            = var.carbon_emissions.codecarbon.name
  namespace       = var.carbon_emissions.codecarbon.namespace
  image           = var.carbon_emissions.codecarbon.image
  api_endpoint    = var.carbon_emissions.codecarbon.api_endpoint
  organization_id = var.carbon_emissions.codecarbon.organization_id
  project_id      = var.carbon_emissions.codecarbon.project_id
  experiment_id   = var.carbon_emissions.codecarbon.experiment_id
  api_key         = var.carbon_emissions.codecarbon.api_key
}

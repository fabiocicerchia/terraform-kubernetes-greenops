output "prometheus" {
  description = "Prometheus module outputs"
  value = var.prometheus.enabled ? {
    namespace    = module.prometheus[0].namespace
    release_name = module.prometheus[0].release_name
    version      = module.prometheus[0].chart_version
  } : null
}

output "keda" {
  description = "KEDA module outputs"
  value = var.keda.enabled ? {
    namespace    = module.keda[0].namespace
    release_name = module.keda[0].release_name
    version      = module.keda[0].chart_version
  } : null
}

output "opencost" {
  description = "OpenCost module outputs"
  value = var.opencost.enabled ? {
    namespace    = module.opencost[0].namespace
    release_name = module.opencost[0].release_name
    version      = module.opencost[0].chart_version
  } : null
}

output "kepler" {
  description = "Kepler module outputs"
  value = var.kepler.enabled ? {
    namespace    = module.kepler[0].namespace
    release_name = module.kepler[0].release_name
    version      = module.kepler[0].chart_version
  } : null
}

output "scaphandre" {
  description = "Scaphandre module outputs"
  value = var.scaphandre.enabled ? {
    namespace    = module.scaphandre[0].namespace
    release_name = module.scaphandre[0].release_name
    version      = module.scaphandre[0].chart_version
  } : null
}

output "kubegreen" {
  description = "KubeGreen module outputs"
  value = var.kubegreen.enabled ? {
    namespace    = module.kubegreen[0].namespace
    release_name = module.kubegreen[0].release_name
    version      = module.kubegreen[0].chart_version
  } : null
}

output "carbon_intensity_exporter" {
  description = "Carbon Intensity Exporter module outputs"
  value = var.carbon_intensity_exporter.enabled ? {
    namespace    = module.carbon_intensity_exporter[0].namespace
    release_name = module.carbon_intensity_exporter[0].release_name
    version      = module.carbon_intensity_exporter[0].chart_version
  } : null
}

output "cloud_carbon_footprint" {
  description = "Cloud Carbon Footprint module outputs"
  value = var.cloud_carbon_footprint.enabled ? {
    namespace          = module.cloud_carbon_footprint[0].namespace
    release_name       = module.cloud_carbon_footprint[0].release_name
    version            = module.cloud_carbon_footprint[0].chart_version
    client_service_url = module.cloud_carbon_footprint[0].client_service_url
    api_service_url    = module.cloud_carbon_footprint[0].api_service_url
  } : null
}

output "deployed_components" {
  description = "List of deployed components"
  value = {
    prometheus                = var.prometheus.enabled
    keda                      = var.keda.enabled
    opencost                  = var.opencost.enabled
    kepler                    = var.kepler.enabled
    scaphandre                = var.scaphandre.enabled
    kubegreen                 = var.kubegreen.enabled
    carbon_intensity_exporter = var.carbon_intensity_exporter.enabled
    cloud_carbon_footprint      = var.cloud_carbon_footprint.enabled
  }
}

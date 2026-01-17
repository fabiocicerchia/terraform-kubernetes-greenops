provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "prometheus_community" {
  name       = "prometheus-community"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-community/kube-prometheus-stack"

  create_namespace = true
  namespace = "monitoring"
  replace = true

  values = yamldecode(file("values-prometheus.yaml"))
}

resource "helm_release" "keda" {
  name       = "kedacore"
  repository = "https://kedacore.github.io/charts"
  chart      = "kedacore/keda"

  create_namespace = true
  namespace = "keda"
  replace = true
}


resource "helm_release" "kepler_operator" {
  depends_on = [ null_resource.deploy_cert_manager ]

  name       = "kepler-operator"
  repository = "oci://quay.io/sustainable_computing_io/charts/kepler-operator"
  chart      = "prometheus-community/kube-prometheus-stack"

  create_namespace = true
  namespace = "kepler-operator"
  replace = true

  values = yamldecode(file("values-kepler.yaml"))
}


resource "helm_release" "opencost" {
  name       = "opencost-charts"
  repository = "https://opencost.github.io/opencost-helm-chart"
  chart      = "opencost-charts/opencost"

  create_namespace = true
  namespace = "opencost"
  replace = true

  values = yamldecode(file("values-opencost.yaml"))
}

resource "null_resource" "deploy_demo_app" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/refs/heads/main/release/kubernetes-manifests.yaml"
  }
}

resource "null_resource" "deploy_cert_manager" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml"
  }
}

resource "null_resource" "deploy_powermonitor" {
  depends_on = [ helm_release.kepler_operator ]

  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/sustainable-computing-io/kepler-operator/v1alpha1/config/samples/kepler.system_v1alpha1_powermonitor.yaml"
  }
}

resource "null_resource" "deploy_keda_example" {
  depends_on = [ helm_release.keda ]

  provisioner "local-exec" {
    command = "kubectl apply -f keda.yaml"
  }
}
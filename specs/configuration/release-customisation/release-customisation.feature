@domain:configuration @area:release-customisation @from:terraform-kubernetes-greenops/variables
Feature: Customising where each tool is released
  Lets an operator fit each tool into their cluster's naming and versioning conventions, or accept predictable defaults.

  Background:
    Given the operator uses the GreenOps module against a reachable Kubernetes cluster

  @id:configuration.release-customisation.001 @rule:configuration.release-customisation.default-release-locations @inferred @source:variables.tf#observability
  Scenario Outline: An enabled tool with no overrides uses its default release name and namespace
    Given the operator enables <tool> without naming a release or namespace
    When the operator applies the module
    Then <tool> is released as "<release>" in namespace "<namespace>"

    Examples:
      | tool                      | release                   | namespace                 |
      | Prometheus                | prometheus-community      | monitoring                |
      | KEDA                      | kedacore                  | keda                      |
      | OpenCost                  | opencost-charts           | opencost                  |
      | Kepler                    | kepler-operator           | kepler-operator           |
      | Scaphandre                | scaphandre                | scaphandre                |
      | Carbon Intensity Exporter | carbon-intensity-exporter | carbon-intensity-exporter |
      | Cloud Carbon Footprint    | cloud-carbon-footprint    | cloud-carbon-footprint    |
      | CodeCarbon                | codecarbon                | codecarbon                |
      | kube-green                | kube-green                | kube-green                |

  @id:configuration.release-customisation.002 @rule:configuration.release-customisation.overrides-applied @inferred @source:variables.tf#cost_efficiency
  Scenario: Release name, namespace, chart version and Helm values set by the operator are used for that tool
    Given the operator enables OpenCost with release "cost", namespace "finops", chart version "1.40.0" and custom Helm values
    When the operator applies the module
    Then OpenCost is released as "cost" in namespace "finops" at chart version "1.40.0" with those values

@domain:adoption @area:complete-example @from:examples/complete
Feature: Deploying the complete GreenOps reference setup
  Gives operators a single reference configuration that brings up the full GreenOps stack, its prerequisites and a demo workload on a local cluster, so they can see every tool working together before adopting it.

  Background:
    Given the operator uses the complete example
    And the operator's kubeconfig has a "minikube" context

  @id:adoption.complete-example.001 @rule:adoption.complete-example.component-set @inferred @source:examples/complete/main.tf#module.greenops @questionable
  Scenario Outline: The complete setup turns on every GreenOps component except CodeCarbon
    Given the operator has supplied WattTime credentials
    When the operator applies the complete example
    Then <component> is <state> in the cluster

    Examples:
      | component                                                       | state         |
      | Prometheus (release prometheus-community, namespace monitoring) | installed     |
      | KEDA                                                            | installed     |
      | OpenCost                                                        | installed     |
      | Kepler                                                          | installed     |
      | Scaphandre                                                      | installed     |
      | kube-green                                                      | installed     |
      | Carbon Intensity Exporter                                       | installed     |
      | Cloud Carbon Footprint                                          | installed     |
      | CodeCarbon                                                      | not installed |

  @id:adoption.complete-example.002 @rule:adoption.complete-example.cert-manager-first @inferred @source:examples/complete/main.tf#null_resource.deploy_cert_manager
  Scenario: cert-manager is installed before the GreenOps stack
    Given cert-manager is not yet installed in the cluster
    When the operator applies the complete example
    Then cert-manager v1.18.2 is applied to the "minikube" context
    And the GreenOps components are installed only after cert-manager has been applied

  @id:adoption.complete-example.003 @rule:adoption.complete-example.opencost-carbon-cost @inferred @source:examples/complete/main.tf#module.greenops
  Scenario: OpenCost reports carbon cost using the bundled Prometheus
    When the operator applies the complete example
    Then OpenCost has carbon cost reporting turned on
    And OpenCost reads metrics from the Prometheus service "prometheus-community-kube-prometheus" on port 9090 in namespace "monitoring"

  @id:adoption.complete-example.004 @rule:adoption.complete-example.energy-metrics-scraped @inferred @source:examples/complete/main.tf#module.greenops
  Scenario: Kepler and Scaphandre energy metrics are collected by the bundled Prometheus
    When the operator applies the complete example
    Then Kepler and Scaphandre each publish a ServiceMonitor
    And Prometheus collects metrics from every ServiceMonitor in the cluster, not only its own

@domain:configuration @area:component-toggles @from:terraform-kubernetes-greenops/terraform-kubernetes-greenops
Feature: Choosing which GreenOps tools are installed
  Lets a platform operator install only the GreenOps tools they need, with safe defaults for anything left out, so nothing that scales or shuts down workloads gets switched on by accident.

  Background:
    Given the operator has configured Helm and kubectl access to a Kubernetes cluster

  @id:configuration.component-toggles.001 @rule:greenops.components.safe-defaults @inferred @source:variables.tf#observability
  Scenario Outline: When a tool is left out, only the observe-only tools are installed
    Given the operator does not mention <tool> in the module settings
    When the operator applies the module
    Then <tool> is <outcome> on the cluster

    Examples:
      | tool                      | outcome       |
      | Prometheus                | installed     |
      | OpenCost                  | installed     |
      | Kepler                    | installed     |
      | CodeCarbon                | installed     |
      | KEDA                      | not installed |
      | Scaphandre                | not installed |
      | kube-green                | not installed |
      | Carbon Intensity Exporter | not installed |
      | Cloud Carbon Footprint    | not installed |

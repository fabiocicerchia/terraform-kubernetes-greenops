@domain:configuration @area:component-toggles @from:terraform-kubernetes-greenops/variables
Feature: Choosing which GreenOps tools are installed
  Lets an operator adopt GreenOps gradually: a safe starter set is installed with no configuration, and anything that acts on workloads stays off until switched on.

  Background:
    Given the operator uses the GreenOps module against a reachable Kubernetes cluster

  @id:configuration.component-toggles.002 @rule:configuration.component-toggles.safe-starter-defaults @inferred @source:variables.tf#observability
  Scenario Outline: Without configuration only the observing tools are installed
    Given the operator leaves the <category> settings out
    When the operator applies the module
    Then <tool> is <state>

    Examples:
      | category                    | tool                      | state         |
      | observability               | Prometheus                | installed     |
      | observability               | KEDA                      | not installed |
      | cost_efficiency             | OpenCost                  | installed     |
      | energy_power                | Kepler                    | installed     |
      | energy_power                | Scaphandre                | not installed |
      | carbon_emissions            | Carbon Intensity Exporter | not installed |
      | carbon_emissions            | Cloud Carbon Footprint    | not installed |
      | carbon_emissions            | CodeCarbon                | installed     |
      | sustainability_optimisation | kube-green                | not installed |

  @id:configuration.component-toggles.003 @rule:configuration.component-toggles.siblings-keep-defaults @inferred @source:variables.tf#observability
  Scenario: Switching one tool on leaves the other tools in its category at their defaults
    Given the operator sets only KEDA to enabled in the observability settings
    When the operator applies the module
    Then KEDA is installed
    And Prometheus is still installed

  @id:configuration.component-toggles.004 @rule:configuration.component-toggles.enabled-required @inferred @source:variables.tf#observability
  Scenario: A tool block without an on/off choice is refused
    Given the operator sets the Prometheus namespace to "metrics" without saying whether Prometheus is enabled
    When the operator plans the module
    Then the plan is refused with an error that the enabled attribute is required
    And nothing is installed

  @id:configuration.component-toggles.005 @rule:optimisation.event-autoscaling.example-off-by-default @inferred @source:variables.tf#observability
  Scenario: Enabling KEDA does not deploy the example scaling workload unless asked
    Given the operator enables KEDA without choosing whether to deploy the example
    When the operator applies the module
    Then KEDA is installed
    And the example scaling manifest "keda.yaml" is not deployed

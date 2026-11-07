@domain:adoption @area:tier2-measure @from:examples/tier2-measure-carbon
Feature: Measuring carbon on top of observation (Tier 2)
  Gives operators who already have energy and cost baselines a ready-made setup that adds grid carbon intensity and cloud carbon estimates, with no automated actions, so they can report on carbon.

  Background:
    Given the operator deploys the Tier 2 "measure carbon" example to a Kubernetes cluster

  @id:adoption.tier2-measure.001 @rule:adoption.tier2.installs-observation-and-carbon-tools @inferred @source:examples/tier2-measure-carbon/main.tf#greenops_measure
  Scenario Outline: Tier 2 installs the observation tools plus grid-intensity and cloud carbon estimation
    Given the example is used without changes
    When the operator applies the Tier 2 example
    Then <component> is installed in the "<namespace>" namespace

    Examples:
      | component                 | namespace                 |
      | Prometheus                | monitoring                |
      | OpenCost                  | opencost                  |
      | Kepler                    | kepler-operator           |
      | Carbon Intensity Exporter | carbon-intensity-exporter |
      | Cloud Carbon Footprint    | cloud-carbon-footprint    |

  @id:adoption.tier2-measure.002 @rule:adoption.tier2.no-automated-actions @inferred @source:examples/tier2-measure-carbon/main.tf#greenops_measure
  Scenario Outline: Tier 2 does not scale or shut down workloads and does not add a second power agent
    Given the example is used without changes
    When the operator applies the Tier 2 example
    Then <component> is not installed

    Examples:
      | component  |
      | KEDA       |
      | kube-green |
      | Scaphandre |

  @id:adoption.tier2-measure.003 @rule:adoption.tier2.codecarbon-off @inferred @source:examples/tier2-measure-carbon/main.tf#greenops_measure @questionable
  Scenario: Tier 2 leaves application-level carbon tracking off
    Given the example is used without changes
    When the operator applies the Tier 2 example
    Then CodeCarbon is not deployed to the cluster

  @id:adoption.tier2-measure.004 @rule:adoption.tier2.opencost-carbon-cost-on @inferred @source:examples/tier2-measure-carbon/main.tf#greenops_measure
  Scenario: Tier 2 shows carbon next to cost in OpenCost
    Given the example is used without changes
    When the operator applies the Tier 2 example
    Then OpenCost is installed with its carbon cost view turned on

  @id:adoption.tier2-measure.005 @rule:adoption.tier2.deploys-to-chosen-context @inferred @source:examples/tier2-measure-carbon/main.tf#kubectl_context
  Scenario Outline: Tier 2 deploys to the chosen kubeconfig context, or to the current one when none is chosen
    Given the operator's kubeconfig is the default file in their home directory
    And the operator sets the example's kubectl_context to <context>
    When the operator applies the Tier 2 example
    Then the tools are installed into the cluster of <target>

    Examples:
      | context    | target                           |
      | nothing    | the kubeconfig's current context |
      | "minikube" | the "minikube" context           |

  @id:adoption.tier2-measure.006 @rule:adoption.tier2.kepler-power-monitor-request-ignored @inferred @source:examples/tier2-measure-carbon/main.tf#greenops_measure @questionable
  Scenario: Asking Tier 2 for a Kepler power monitor has no effect
    Given the example asks for Kepler with deploy_powermonitor set to true
    When the operator applies the Tier 2 example
    Then Kepler is installed
    And no power monitor is deployed because of that setting

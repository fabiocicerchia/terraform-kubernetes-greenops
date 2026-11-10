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
  Scenario Outline: Tier 2 does not scale or shut down workloads, add a second power agent or track application carbon
    Given the example is used without changes
    When the operator applies the Tier 2 example
    Then <component> is not installed

    Examples:
      | component  |
      | KEDA       |
      | kube-green |
      | Scaphandre |
      | CodeCarbon |

  @id:adoption.tier2-measure.004 @rule:adoption.tier2.opencost-carbon-cost-on @inferred @source:examples/tier2-measure-carbon/main.tf#greenops_measure
  Scenario: Tier 2 shows carbon next to cost in OpenCost
    Given the example is used without changes
    When the operator applies the Tier 2 example
    Then OpenCost is installed with its carbon cost view turned on

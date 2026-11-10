@domain:adoption @area:tier1-observe @from:examples/tier1-observe-only
Feature: Starting GreenOps with observation only
  Gives an operator new to GreenOps a starter setup that shows energy, cost and application carbon. It does not automate anything, so they can build baselines before changing workloads.

  Background:
    Given the operator uses the Tier 1 observe-only example against a Kubernetes cluster

  @id:adoption.tier1-observe.001 @rule:adoption.tier1.installs-observation-tools @inferred @source:examples/tier1-observe-only/main.tf#greenops_observe
  Scenario Outline: Tier 1 installs metrics, energy, cost and application-carbon tools
    Given the operator has not changed the example's component settings
    When the operator applies the Tier 1 example
    Then <tool> is installed in the "<namespace>" namespace

    Examples:
      | tool                    | namespace       |
      | Prometheus with Grafana | monitoring      |
      | Kepler                  | kepler-operator |
      | OpenCost                | opencost        |
      | CodeCarbon              | codecarbon      |

  @id:adoption.tier1-observe.002 @rule:adoption.tier1.leaves-automation-and-advanced-carbon-off @inferred @source:examples/tier1-observe-only/main.tf#greenops_observe
  Scenario Outline: Tier 1 installs no autoscaling, scheduled shutdown or advanced carbon tools
    Given the operator has not changed the example's component settings
    When the operator applies the Tier 1 example
    Then <tool> is not installed
    And no existing workload is scaled or put to sleep

    Examples:
      | tool                      |
      | KEDA                      |
      | kube-green                |
      | Scaphandre                |
      | Carbon Intensity Exporter |
      | Cloud Carbon Footprint    |

  @id:adoption.tier1-observe.004 @rule:adoption.tier1.targets-chosen-kubectl-context @inferred @source:examples/tier1-observe-only/main.tf#kubectl_context
  Scenario Outline: Tier 1 deploys to the current kubectl context unless the operator names one
    Given the operator's default kubeconfig file has contexts "minikube" and "staging", with "staging" current
    When the operator applies the Tier 1 example with kubectl_context set to <kubectl_context>
    Then the tools are installed into the cluster of context "<target>"

    Examples:
      | kubectl_context | target   |
      | (unset)         | staging  |
      | minikube        | minikube |

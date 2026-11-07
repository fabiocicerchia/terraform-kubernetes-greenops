@domain:adoption @area:tier3-optimise @from:examples/tier3-optimize-automate
Feature: Optimising and automating a GreenOps cluster (Tier 3)
  Operators who already know their baselines get one example that adds event-driven autoscaling and scheduled shutdown to full observation and carbon measurement, so they can cut energy, cost and carbon without wiring each tool themselves.

  Background:
    Given the operator uses the Tier 3 optimise-and-automate example
    And the operator has a kubeconfig file in the default location

  @id:adoption.tier3-optimise.001 @rule:adoption.tier3.installs-automation-on-top-of-measurement @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize
  Scenario Outline: Tier 3 adds autoscaling and scheduled shutdown on top of observation and carbon measurement
    Given the operator has not changed any component toggle in the example
    When the operator applies the example
    Then <component> is <state> in the cluster

    Examples:
      | component                 | state         |
      | Prometheus                | installed     |
      | KEDA                      | installed     |
      | OpenCost                  | installed     |
      | Kepler                    | installed     |
      | Scaphandre                | not installed |
      | Carbon Intensity Exporter | installed     |
      | Cloud Carbon Footprint    | installed     |
      | CodeCarbon                | not installed |
      | kube-green                | installed     |

  @id:adoption.tier3-optimise.002 @rule:adoption.tier3.no-example-scaling-by-default @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize
  Scenario: Tier 3 does not scale any workload until the operator defines a scaling policy
    Given the operator has left the KEDA example workload switch at its Tier 3 value
    When the operator applies the example
    Then KEDA is installed in the "keda" namespace under the release "kedacore"
    And no example scaled workload is deployed to the cluster

  @id:adoption.tier3-optimise.003 @rule:adoption.tier3.metrics-retained-90-days @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize
  Scenario: Tier 3 keeps 90 days of cluster metrics for trend analysis
    When the operator applies the example
    Then Prometheus is installed in the "monitoring" namespace
    And Prometheus keeps metrics for 90 days

  @id:adoption.tier3-optimise.004 @rule:adoption.tier3.cost-includes-carbon @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize
  Scenario: Tier 3 cost reports include carbon cost
    When the operator applies the example
    Then OpenCost is installed in the "opencost" namespace
    And OpenCost has carbon cost reporting turned on

  @id:adoption.tier3-optimise.005 @rule:adoption.tier3.power-monitor-request-ignored @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize @questionable
  Scenario: Asking Tier 3 for a Kepler power monitor installs no power monitor
    Given the example asks Kepler to deploy its power monitor
    When the operator applies the example
    Then Kepler is installed in the "kepler-operator" namespace
    And no Kepler power monitor is deployed
    And no error or warning tells the operator that the request was ignored

  @id:adoption.tier3-optimise.006 @rule:adoption.tier3.app-carbon-off @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize @questionable
  Scenario: Tier 3 does not track application carbon unless the operator turns it on
    When the operator applies the example
    Then no CodeCarbon agent runs on the cluster nodes

  @id:adoption.tier3-optimise.007 @rule:adoption.tier3.deploys-to-chosen-context @inferred @source:examples/tier3-optimize-automate/main.tf#kubectl_context
  Scenario Outline: Tier 3 deploys to the kubectl context the operator names, or the current one when none is named
    Given the operator sets the example's kubectl_context to <context>
    When the operator applies the example
    Then every component is installed into the cluster of <target>

    Examples:
      | context    | target                                                |
      | "minikube" | the "minikube" context of the default kubeconfig file |
      | nothing    | the current context of the default kubeconfig file    |

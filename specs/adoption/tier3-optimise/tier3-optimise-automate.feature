@domain:adoption @area:tier3-optimise @from:examples/tier3-optimize-automate
Feature: Optimising and automating a GreenOps cluster (Tier 3)
  Operators who already know their baselines get one example that adds event-driven autoscaling and scheduled shutdown to full observation and carbon measurement, so they can cut energy, cost and carbon without wiring each tool themselves.

  Background:
    Given Given the operator uses the Tier 3 optimise-and-automate example
    And And the operator has a kubeconfig file in the default location

  @id:adoption.tier3-optimise.001 @rule:adoption.tier3.installs-automation-on-top-of-measurement @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize
  Scenario Outline: Tier 3 adds autoscaling and scheduled shutdown on top of observation and carbon measurement
    Given Given the operator has not changed any component toggle in the example
    When When the operator applies the example
    Then Then component <component> is <state> in the deployment summary

    Examples:
      | component                 | state    |
      | prometheus                | enabled  |
      | keda                      | enabled  |
      | opencost                  | enabled  |
      | kepler                    | enabled  |
      | scaphandre                | disabled |
      | carbon_intensity_exporter | enabled  |
      | cloud_carbon_footprint    | enabled  |
      | codecarbon                | disabled |
      | kubegreen                 | enabled  |

  @id:adoption.tier3-optimise.002 @rule:adoption.tier3.no-example-scaling-by-default @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize
  Scenario: Tier 3 does not scale any workload until the operator defines a scaling policy
    Given Given the operator has left the KEDA example workload switch at its Tier 3 value
    When When the operator applies the example
    Then Then KEDA is installed in the "keda" namespace under the release "kedacore"
    And And no example scaled workload is deployed to the cluster

  @id:adoption.tier3-optimise.003 @rule:adoption.tier3.metrics-retained-90-days @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize
  Scenario: Tier 3 keeps 90 days of cluster metrics for trend analysis
    When When the operator applies the example
    Then Then Prometheus is installed in the "monitoring" namespace
    And And Prometheus keeps metrics for 90 days

  @id:adoption.tier3-optimise.004 @rule:adoption.tier3.cost-includes-carbon @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize
  Scenario: Tier 3 cost reports include carbon cost
    When When the operator applies the example
    Then Then OpenCost is installed in the "opencost" namespace
    And And OpenCost has carbon cost reporting turned on

  @id:adoption.tier3-optimise.005 @rule:adoption.tier3.power-monitor-request-ignored @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize @questionable
  Scenario: Asking Tier 3 for a Kepler power monitor installs no power monitor
    Given Given the example asks Kepler to deploy its power monitor
    When When the operator applies the example
    Then Then Kepler is installed in the "kepler-operator" namespace
    And And no Kepler power monitor is deployed
    And And no error or warning tells the operator that the request was ignored

  @id:adoption.tier3-optimise.006 @rule:adoption.tier3.app-carbon-off @inferred @source:examples/tier3-optimize-automate/main.tf#greenops_optimize @questionable
  Scenario: Tier 3 does not track application carbon unless the operator turns it on
    When When the operator applies the example
    Then Then no CodeCarbon agent runs on the cluster nodes
    And And the deployment summary reports codecarbon as false

  @id:adoption.tier3-optimise.007 @rule:adoption.tier3.deploys-to-chosen-context @inferred @source:examples/tier3-optimize-automate/main.tf#kubectl_context
  Scenario Outline: Tier 3 deploys to the kubectl context the operator names, or the current one when none is named
    Given Given the operator sets the kubectl context to "<context>"
    When When the operator applies the example
    Then Then every component is installed into the cluster of <target>
    And And the module reports the kubectl context it used

    Examples:
      | context   | target                                                |
      | minikube  | the "minikube" context of the default kubeconfig file |
      | (not set) | the current context of the default kubeconfig file    |

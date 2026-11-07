@domain:carbon @area:application-emissions @from:terraform-kubernetes-greenops/terraform-kubernetes-greenops
Feature: Reporting application emissions to CodeCarbon
  Lets an operator send workload carbon measurements to their CodeCarbon account while keeping the API key out of view.

  Background:
    Given the operator has configured kubectl access to a Kubernetes cluster

  @id:carbon.application-emissions.001 @rule:carbon.codecarbon.installed-by-default-without-account @inferred @source:variables.tf#carbon_emissions @questionable
  Scenario: CodeCarbon is installed by default with no account details
    Given the operator gives no CodeCarbon settings
    When the operator applies the module
    Then CodeCarbon is installed in namespace "codecarbon"
    And it reports to "https://api.codecarbon.io" with an empty organisation, project, experiment and API key

  @id:carbon.application-emissions.002 @rule:carbon.settings.hidden-in-plan @inferred @source:variables.tf#carbon_emissions @questionable
  Scenario: Carbon tool settings, including the CodeCarbon API key, are hidden in plan output
    Given the operator sets a CodeCarbon API key "cc_test_key_0000"
    When the operator runs a plan
    Then the plan shows the carbon settings as sensitive instead of their values
    And the API key "cc_test_key_0000" does not appear in the plan output
    And which carbon tools are turned on is hidden as well

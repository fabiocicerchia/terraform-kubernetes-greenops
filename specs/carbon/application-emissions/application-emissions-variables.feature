@domain:carbon @area:application-emissions @from:terraform-kubernetes-greenops/variables
Feature: Reporting application carbon emissions with CodeCarbon
  Gives operators application-level carbon figures out of the box while keeping the CodeCarbon credentials out of sight.

  Background:
    Given the operator uses the GreenOps module against a reachable Kubernetes cluster

  @id:carbon.application-emissions.003 @rule:carbon.application-emissions.default-reporting-target @inferred @source:variables.tf#carbon_emissions @questionable
  Scenario: CodeCarbon reports to the public CodeCarbon API with no credentials unless configured
    Given the operator leaves the CodeCarbon settings out
    When the operator applies the module
    Then CodeCarbon runs the image "fabiocicerchia/codecarbon:latest"
    And it reports to "https://api.codecarbon.io"
    And its organisation, project, experiment and API key are empty

  @id:carbon.application-emissions.004 @rule:carbon.application-emissions.credentials-hidden @inferred @source:variables.tf#carbon_emissions
  Scenario: Carbon settings, including the CodeCarbon API key, are never shown in plan output
    Given the operator sets the CodeCarbon API key to "cc_example_key_123"
    When the operator plans the module
    Then the carbon settings are displayed as "(sensitive value)"
    And the API key does not appear in the plan output

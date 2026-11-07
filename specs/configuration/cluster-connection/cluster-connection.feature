@domain:configuration @area:cluster-connection @from:terraform-kubernetes-greenops/variables
Feature: Choosing the target cluster
  Tells operators which kubeconfig and context the GreenOps tools are deployed to.

  @id:configuration.cluster-connection.001 @rule:configuration.cluster-connection.kubeconfig-inputs-not-used-for-deployment @inferred @source:variables.tf#kubectl_context @questionable
  Scenario: The module's kubeconfig path and context settings do not choose where tools are deployed
    Given the caller's Helm and kubectl providers point at context "staging"
    And the operator sets the module's kubectl context to "production"
    When the operator applies the module
    Then the tools are installed into the "staging" cluster
    And the module reports context "production"

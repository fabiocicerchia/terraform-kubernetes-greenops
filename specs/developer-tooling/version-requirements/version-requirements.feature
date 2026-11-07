@domain:developer-tooling @area:version-requirements @from:terraform-kubernetes-greenops/versions
Feature: Declaring supported Terraform and provider versions
  Tells operators which Terraform and which Helm and kubectl providers the module works with, so an unsupported toolchain is refused at init time instead of failing halfway through a deployment.

  Background:
    Given the operator's root configuration calls the greenops module

  @id:developer-tooling.version-requirements.001 @rule:tooling.versions.terraform-1-3-minimum @inferred @source:versions.tf#terraform
  Scenario Outline: Terraform older than 1.3 is refused
    Given the operator's Terraform CLI is version <cli_version>
    When the operator initialises the configuration
    Then the outcome is <outcome>

    Examples:
      | cli_version | outcome                                         |
      | 1.2.9       | refused: the module requires Terraform ">= 1.3" |
      | 1.3.0       | accepted                                        |
      | 1.9.5       | accepted                                        |

  @id:developer-tooling.version-requirements.002 @rule:tooling.versions.provider-minimums @inferred @source:versions.tf#terraform @questionable
  Scenario Outline: The module installs with Helm provider 2.0 or later and kubectl provider 1.14 or later
    Given the operator's configuration pins the <provider> provider to version <provider_version>
    When the operator initialises the configuration
    Then the outcome is <outcome>

    Examples:
      | provider            | provider_version | outcome                                |
      | hashicorp/helm      | 1.3.2            | refused: the module requires ">= 2.0"  |
      | hashicorp/helm      | 2.17.0           | accepted                               |
      | hashicorp/helm      | 3.0.2            | accepted                               |
      | gavinbunney/kubectl | 1.13.1           | refused: the module requires ">= 1.14" |
      | gavinbunney/kubectl | 1.19.0           | accepted                               |

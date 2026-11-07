# Specifications of terraform-kubernetes-greenops

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Adoption paths
Example setups that walk a team through GreenOps one stage at a time.

- **Complete setup**: [Deploying the complete GreenOps reference setup](adoption/complete-example/complete-greenops-setup.feature) (4)
- **Tier 1: observe**: [Starting GreenOps with observation only](adoption/tier1-observe/tier1-observe.feature) (5)
- **Tier 2: measure carbon**: [Measuring carbon on top of observation (Tier 2)](adoption/tier2-measure/tier2-measure-carbon.feature) (6)
- **Tier 3: optimise and automate**: [Optimising and automating a GreenOps cluster (Tier 3)](adoption/tier3-optimise/tier3-optimise-automate.feature) (7)

## Carbon accounting
Estimating the carbon footprint of the cluster, its cloud account and its applications.

- **Application emissions**: [Reporting application carbon emissions with CodeCarbon](carbon/application-emissions/application-emissions-variables.feature) (2), [Reporting application emissions to CodeCarbon](carbon/application-emissions/application-emissions.feature) (2)

## Module configuration
How a user picks a cluster, chooses components and tunes them.

- **Cluster connection**: [Choosing the target cluster](configuration/cluster-connection/cluster-connection.feature) (1)
- **Component toggles and defaults**: [Choosing which GreenOps tools are installed](configuration/component-toggles/component-selection.feature) (1), [Choosing which GreenOps tools are installed](configuration/component-toggles/component-toggles.feature) (4)
- **Release customisation**: [Customising where each tool is released](configuration/release-customisation/release-customisation.feature) (2)

## Developer tooling
Build, quality-gate and compatibility tooling for people maintaining the module.

- **Version requirements**: [Declaring supported Terraform and provider versions](developer-tooling/version-requirements/version-requirements.feature) (2)

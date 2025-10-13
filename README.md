# Terraform Drift Detection – POC

This repository contains a proof-of-concept (POC) for detecting drift in Azure infrastructure managed by Terraform, using Azure DevOps pipelines.

## Project Structure

```
.
├── env/
│   └── main.tf
├── pipelines/
│   ├── infra-pipeline.yml
│   └── templates/
│       └── terraform.yaml
└── README.md
```


## Components

- **env/**: Contains Terraform configuration files for Azure resources.
  - `main.tf`: Defines the Azure provider and a sample virtual network resource.
- **pipelines/**: Azure DevOps pipeline definitions.
  - `infra-pipeline.yml`: Main pipeline for scheduled drift detection and infrastructure deployment.
  - `templates/terraform.yaml`: Pipeline template for Terraform steps.

## How It Works


- The `infra-pipeline.yml` is scheduled to run at 3am (Monday–Friday) to check for drift in the Terraform-managed infrastructure.
- The pipeline uses the AzureRM backend for state management, with configuration provided via pipeline parameters.
- If drift is detected, the pipeline can be configured to create a task in Azure DevOps for review.
- For a visual summary of the Terraform Drift Detection process, see the included PowerPoint presentation: `Terraform Drift Detection.pptx`. This presentation helps explain the workflow and key concepts to others.

## Prerequisites

- **Azure:**
  - Subscription
  - Resource Group
  - Storage account and container (used for Terraform state)
  - User Assigned Managed Identity with Federated Credential
    - Required RBAC Role: `Contributor` against Subscription
    - Required RBAC Role: `Storage Blob Data Contributor` against the Terraform state storage account
    - Federated credential configured for GitHub Actions:
      - Issuer: `https://token.actions.githubusercontent.com`
      - Subject identifier: `repo:{owner}/{repo}:ref:refs/heads/main` (adjust for your repository)
      - Audiences: `api://AzureADTokenExchange`

- **GitHub Repository Setup:**
  - **Variables** (Repository Settings → Secrets and variables → Actions → Variables):
    - `ARM_SUBSCRIPTION_ID`: Azure subscription ID
    - `ARM_CLIENT_ID`: Managed Identity client ID (Application ID)
    - `ARM_TENANT_ID`: Azure tenant ID
    - `TF_STATE_RESOURCE_GROUP`: Resource group name containing Terraform state storage account
    - `TF_STATE_STORAGE_ACCOUNT`: Storage account name for Terraform state
    - `TF_STATE_CONTAINER`: Blob container name for Terraform state
    - `TF_STATE_KEY`: State file name/path (e.g., `terraform.tfstate`)

- **Azure DevOps Organization:**
  - Azure DevOps Extensions
    - Create Work Item by Microsoft
    - Terraform by Microsoft DevLabs
  - Project
    - Service Connections using Managed Identity
    - Pipeline Environment
    - Pipeline (configured to run `infra-pipeline.yml`)


## Usage

1. Clone this repository.
2. Update the values in `main.tf` and pipeline YAML files as needed for your environment.
3. Set up the required Azure resources (resource group, storage account, etc.).
4. Configure the Azure DevOps pipelines using the provided YAML files.

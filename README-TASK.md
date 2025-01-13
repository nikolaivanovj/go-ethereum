# README-TASK.md

## DevOps Take Home Task

This repository demonstrates the deployment of a `go-ethereum` project with CI/CD pipelines, Hardhat integration, and AKS deployment using Terraform.

### CI/CD Workflows

#### Build and Push Docker Image
- Triggered by a PR labeled `CI:Build`.
- Builds the Docker image and pushes it to Docker Hub.

Workflow file: `.github/workflows/build-push.yml`

#### Deploy Hardhat Project
- Triggered by a PR labeled `CI:Deploy`.
- Runs a local devnet, deploys the Sample Hardhat Project, and runs tests.

Workflow file: `.github/workflows/deploy-test.yml`

#### Deploy to AKS
- Triggered by a PR labeled `CD:DeployToAKS`.
- Deploys the Docker image to Azure Kubernetes Service (AKS).

Workflow file: `.github/workflows/deploy-to-aks.yml`

#### Terraform Apply
- Triggered by a PR labeled `CI:Terraform-Apply`.
- Provisions Azure resources, including a Kubernetes cluster, using Terraform.

Workflow file: `.github/workflows/terraform-apply.yml`

### Azure Resources Created
- **Azure Kubernetes Service (AKS)**: Manages the Kubernetes cluster.
- **Azure Storage Account**: Persistent storage and Terraform backend.

### Docker Compose
A `docker-compose.yml` file is included to run a local devnet using the built Docker image.

### BlockScout Integration (WIP)
BlockScout explorer to be included in the future to provide a user-friendly interface for exploring the local devnet.

### Notes
- Persistent storage considerations included, potentially using the light node database which requires minimal storage, for future use.
- Terraform backend configuration is changed to use an Azure resource.
- Currently, the labels are the only triggers for the CI/CD workflows.
- Refer to the `k8s` directory for Kubernetes deployment manifests used for deploying the application to AKS.

For more details, please refer to the individual workflow files and the `hardhat` directory for the Sample Hardhat Project.

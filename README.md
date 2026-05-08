\# GCP DevOps End-to-End Implementation



\## Overview



This project demonstrates an end-to-end DevOps setup on Google Cloud Platform (GCP) for deploying a simple containerized application. It covers infrastructure provisioning using Terraform, application deployment using Kubernetes and Helm, and automation using a CI/CD pipeline.



The goal of this project is to showcase practical DevOps skills, including Infrastructure as Code (IaC), containerization, Kubernetes deployment strategies, and pipeline automation.



\---



\## Architecture



The overall setup includes the following components:



\* \*\*Application\*\*: A simple containerized app (nginx/hello-world based)

\* \*\*Artifact Registry\*\*: Stores Docker images

\* \*\*GKE (Google Kubernetes Engine)\*\*: Runs the application

\* \*\*Terraform\*\*: Provisions infrastructure

\* \*\*Helm\*\*: Manages Kubernetes deployment

\* \*\*GitHub Actions\*\*: Automates build and deployment



\### Flow:



1\. Developer pushes code to GitHub

2\. CI/CD pipeline builds Docker image

3\. Image is pushed to Artifact Registry

4\. Helm deploys/updates the application in GKE

5\. Application is exposed via LoadBalancer service



\---



\## Project Structure



```

.

├── app/                    # Application source code

├── docker/                 # Dockerfile

├── terraform/              # Terraform IaC code

├── helm/hello-chart/       # Helm chart

├── .github/workflows/      # CI/CD pipeline

└── README.md

```



\---



\## Prerequisites



Make sure the following tools are installed and configured:



\* gcloud CLI

\* Terraform

\* Docker

\* kubectl

\* Helm

\* GitHub account



Also ensure:



\* GCP project is created

\* Billing is enabled

\* Required APIs are enabled (GKE, Artifact Registry)



\---



\## Infrastructure Setup (Terraform)



Terraform is used to provision:



\* VPC and subnet

\* GKE cluster

\* Artifact Registry

\* IAM roles and service accounts



\### Steps:



```bash

cd terraform



terraform init

terraform plan

terraform apply

```



\---



\## Docker Build \& Push



\### Build image:



```bash

docker build -t hello-app:v1 .

```



\### Tag image:



```bash

docker tag hello-app:v1 asia-south1-docker.pkg.dev/<project-id>/repo/hello-app:v1

```



\### Authenticate Docker:



```bash

gcloud auth configure-docker asia-south1-docker.pkg.dev

```



\### Push image:



```bash

docker push asia-south1-docker.pkg.dev/<project-id>/repo/hello-app:v1

```



\---



\## Connect to GKE Cluster



```bash

gcloud container clusters get-credentials <cluster-name> --region asia-south1

```



Verify:



```bash

kubectl get nodes

```



\---



\## Kubernetes Deployment (Helm)



A Helm chart is used to deploy the application with configurable values.



\### Install chart:



```bash

helm install hello-release ./helm/hello-chart

```



\### Upgrade deployment:



```bash

helm upgrade hello-release ./helm/hello-chart

```



\### Verify:



```bash

kubectl get pods

kubectl get svc

```



\---



\## CI/CD Pipeline



GitHub Actions is used for automation.



\### Pipeline Steps:



1\. Trigger on code push

2\. Build Docker image

3\. Authenticate with GCP

4\. Push image to Artifact Registry

5\. Deploy to GKE using Helm



Secrets are stored securely using GitHub Secrets.



\---



\## Observability \& Troubleshooting



Basic monitoring and debugging were done using:



```bash

kubectl get pods

kubectl describe pod <pod-name>

kubectl logs <pod-name>

```



Logs are also available in GCP Cloud Logging.



\### Common Issues Faced:



\* ImagePullBackOff → Fixed by correcting image path and permissions

\* CrashLoopBackOff → Fixed by checking logs and environment variables

\* External IP pending → Waited for LoadBalancer provisioning



\---



\## Helm Chart Design



The Helm chart includes:



\* Deployment

\* Service (LoadBalancer)

\* values.yaml for configuration

\* Resource limits and requests

\* Liveness and readiness probes



This allows easy configuration across environments.



\---



\## GCP Services Used



\* Google Kubernetes Engine (GKE)

\* Artifact Registry

\* IAM \& Service Accounts

\* VPC Networking

\* Cloud Logging



\---



\## Trade-offs



\* Used LoadBalancer service instead of Ingress for simplicity

\* Minimal security configuration for faster setup

\* Basic monitoring instead of full observability stack



\---



\## Assumptions



\* Single environment setup (no dev/prod separation)

\* Small-scale application

\* Default node pool used in GKE



\---



\## Improvements (Production Ready)



\* Add Ingress with domain and SSL

\* Enable Horizontal Pod Autoscaler (HPA)

\* Use private GKE cluster

\* Implement Workload Identity

\* Add Prometheus \& Grafana for monitoring

\* Use Terraform remote backend (GCS)

\* Separate environments (dev/staging/prod)

\* Implement blue/green or canary deployments



\---



\## Conclusion



This project demonstrates a complete DevOps workflow on GCP, covering infrastructure provisioning, containerization, Kubernetes deployment, and CI/CD automation. It can be extended further to meet production-grade requirements.




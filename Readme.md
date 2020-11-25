# Terraform Deployment of K8S cluster

#### Purpose:
Purpose of this guide is to understand and implement the build and deploy mechanism to AWS EKS using AWS codepipeline. 

#### Assumptions

1. You have already running application in AWS EKS.

#### Highlevel Steps:

1. Create IAM roles(One for codepipeline and one for AWS codebuild)
1. Add the codebuild IAM role to AWS_AUTH config map of Kubernetes, so that we can utilize this role to deploy to kubernetes
1. Write buildspec files to build, push and then deploy to EKS.
1. Create AWS codepipeline.

#### AWS Codepipeline Stages

###### CI Stages:

1. Source Stage
1. AWS codebuild stage to build and push docker images
1. AWS codebuild stage to dynamically generate helm values file and commit to helm repo

###### CD Stages:

1. Source Stage
1. AWS codebuild stage to deploy to eks using helm
1. Manual approval satge if you want to deploy to multiple namespaces/clusters
1. Deploy to next namespace/cluster in kubernetes

*Architecture flow for reference:*

![alt text](https://github.com/dipander91/k8s-terraform/blob/master/Architecture/Architecture-Codepipeline_updated.png?raw=true)

For this guide, Terraform is used to create the pipeline, its stages and other required components like IAM roles/policies. The code for the pipeline terraform module is present at this location: https://github.com/dipander91/k8s-terraform/tree/master/terraform-provision/pipeline

The main components for this pipeline to do the building of docker images and then pushing to AWS ECR and then deploying to helm is taken care with the help of AWS codebuild. For codebuild to work, we need to have buildspec file present at the root of our code repository. So you can find two buildspec files present at the root location of this repository, one for docker build and push (buildspec-docker.yml) and second for deployment to EKS(buildspec-deploy.yml) 

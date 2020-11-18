# Terraform Deployment of K8S cluster

#### Purpose:
Purpose of this guide is to understand and implement the build and deploy mechanism to AWS EKS using AWS codepipeline. 

#### Assumptions

1. You have already running application in AWS EKS.

#### Highlevel Steps:

1. Source checkout
1. AWS codebuild stage to build and push docker images
1. Manual approval satge before deploying to EKS
1. Deploy to a namespace in kubernetes

Architecture flow for reference:

![alt text](https://github.com/dipander91/k8s-terraform/blob/master/Architecture/Architecture-Codepipeline.png?raw=true)


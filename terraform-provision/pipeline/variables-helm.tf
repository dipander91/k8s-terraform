variable "helm_pipeline_name" {
  type    = string
  default = "eks-helm-deploy-pipeline"
}


variable "helm_chart_name" {
  type    = string
  default = "demo-k8s-cicd"
}

variable "helm_artifact_s3_bucket" {
  type    = string
  default = "eks-codepipeline-helm-artifact-bucket"
}


variable "helm_deploy_cwlogs_group" {
  type    = string
  default = "eks-helm-deploy-logs"
}

variable "helm_github_repo" {
  type    = string
  default = "helm-repo"
}



locals {
  helm_deploy_env_vars = [
    {
        name  = "RELEASE_NAME"
        type  = "PLAINTEXT"
        value = "devrelease"
                
    },
    {
        name  = "NAMESPACE"
        type  = "PLAINTEXT"
        value = "development"
                
    },
    {
        name  = "CLUSTER_NAME"
        type  = "PLAINTEXT"
        value = "demo-k8s-cicid-cluster"
                
    },
    {
        name  = "HELM_CHART_NAME"
        type  = "PLAINTEXT"
        value = var.helm_chart_name
                
    }
  ]

}

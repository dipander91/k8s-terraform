variable "pipeline_name" {
  type    = string
  default = "eks-helm-build-pipeline"
}

variable "artifact_s3_bucket" {
  type    = string
  default = "eks-codepipeline-artifact-bucket"
}

variable "docker_build_cwlogs_group" {
  type    = string
  default = "eks-docker-build-logs"
}

variable "helm_values_cwlogs_group" {
  type    = string
  default = "eks-helm-values-logs"
}

variable "github_owner" {
  type    = string
  default = "dipander91"
}
variable "github_owner_email" {
  type    = string
  default = "dipander.goyal@gmail.com"
}
variable "github_repo" {
  type    = string
  default = "k8s-terraform"
}
variable "github_branch" {
  type    = string
  default = "master"
}



locals {
  webhook_secret = random_string.webhook_secret_random.result
}

variable "github_token" {
  type    = string 
}

variable "docker_build_envmap" {
  type = map
  default = {
    "AWS_ACCOUNT_ID"  = "835483671006"
    "API_ECR_REPO"    = "eks/api"
    "DDB_ECR_REPO"   = "eks/dynamo"
    "NODEJS_ECR_REPO" = "eks/nodejs"
    "PYTHON_ECR_REPO" = "eks/python"
    "WEBAPP_ECR_REPO" = "eks/webapp"
  }
}

locals {
  docker_build_env_vars = [
    {
        name  = "AWS_ACCOUNT_ID"
        type  = "PLAINTEXT"
        value = data.aws_caller_identity.current.account_id
                
    },
    {
        name  = "API_ECR_REPO"
        type  = "PLAINTEXT"
        value = "eks/api"
                
    },
    {
        name  = "DDB_ECR_REPO"
        type  = "PLAINTEXT"
        value = "eks/dynamo"
                
    },
    {
        name  = "NODEJS_ECR_REPO"
        type  = "PLAINTEXT"
        value = "eks/nodejs"
                
    },
    {
        name  = "PYTHON_ECR_REPO"
        type  = "PLAINTEXT"
        value = "eks/python"
                
    },
    {
        name  = "WEBAPP_ECR_REPO"
        type  = "PLAINTEXT"
        value = "eks/webapp"
                
    }
  ]

}

locals {
  helm_values_env_vars = [
    {
        name  = "GITHUB_HELM_REPO_URL"
        type  = "PLAINTEXT"
        value = "https://github.com/${var.github_owner}/${var.helm_github_repo}.git"
                
    },
    {
        name  = "GITHUB_HELM_REPO_NAME"
        type  = "PLAINTEXT"
        value = var.helm_github_repo                
    },
    {
        name  = "HELM_CHART_NAME"
        type  = "PLAINTEXT"
        value = var.helm_chart_name
                
    },
    {
        name  = "VALUES_FILE_NAME"
        type  = "PLAINTEXT"
        value = "values-tags.yaml"
                
    },
    {
        name  = "GITHUB_PUSH_TOKEN"
        type  = "PARAMETER_STORE"
        value = aws_ssm_parameter.github_token_param.name
                
    },
    {
        name  = "GITHUB_OWNER"
        type  = "PLAINTEXT"
        value = var.github_owner
                
    },
    {
        name  = "GITHUB_OWNER_EMAIL"
        type  = "PLAINTEXT"
        value = var.github_owner_email
                
    }

    
  ]
}


locals {
  pipeline_tags = {
        "Name"  = var.pipeline_name
      
                
    }  
}

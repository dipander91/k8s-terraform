variable "pipeline_name" {
  type    = string
  default = "eks-helm-deploy-pipeline"
}

variable "artifact_s3_bucket" {
  type    = string
  default = "eks-codepipeline-artifact-bucket"
}

variable "docker_build_cwlogs_group" {
  type    = string
  default = "eks-docker-build-logs"
}

variable "helm_deploy_cwlogs_group" {
  type    = string
  default = "eks-helm-deploy-logs"
}

variable "github_owner" {
  type    = string
  default = "dipander91"
}
variable "github_repo" {
  type    = string
  default = "k8s-terraform"
}
variable "github_branch" {
  type    = string
  default = "master"
}


variable "github_token" {
  type    = string 
  default = "d4655350ad7b619a31b6a3957ae9d9324892c4cf"
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
                
    }
  ]

}

locals {
  pipeline_tags = {
        "Name"  = var.pipeline_name
                
    }  
}

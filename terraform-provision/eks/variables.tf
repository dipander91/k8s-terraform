variable "region" {
  default = "eu-west-1"
}

variable "enable_ssh" {
  type = bool
  default = true
}

variable "sshkey" {
  default = "eksdip"
}

variable "ecr_repo_list" {
  description = "ECR repo name list"
  type = list(string)

  default = ["eks/dynamo","eks/api","eks/nodejs","eks/python","eks/webapp"]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::835483671006:user/ashukla"
      username = "Anuj"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::835483671006:user/dgoyal"
      username = "Dipander"
      groups   = ["system:masters"]
    }

  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::835483671006:role/eks_codebuild_role"
      username = "deploy role of code build"
      groups   = ["system:masters"]
    }
  ]
}

locals {
  
  asg_tags = [ 
  {
     "key": "k8s.io/cluster-autoscaler/enabled",
     "propagate_at_launch": true,
     "value": true
  },
  {
     "key": "k8s.io/cluster-autoscaler/demo-k8s-cicid-cluster",
     "propagate_at_launch": true,
     "value": "owned"
  }]
  
}

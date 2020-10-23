variable "region" {
  default = "eu-west-1"
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
      userarn  = "arn:aws:iam::002857694718:user/EksAccountUser"
      username = "Anuj"
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
     "key": "k8s.io/cluster-autoscaler/test-eks-cluster",
     "propagate_at_launch": true,
     "value": "owned"
  }]
  
}
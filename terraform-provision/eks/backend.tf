terraform {
  backend "s3" {
    bucket         = "demo-k8s-cicd"
    key            = "eks/eks.tfstate"
    region         = "eu-west-1"
  }
}

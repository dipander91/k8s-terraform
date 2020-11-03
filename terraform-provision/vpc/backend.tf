terraform {
  backend "s3" {
    bucket         = "demo-k8s-cicd"
    key            = "vpc/vpc.tfstate"
    region         = "eu-west-1"
  }
}

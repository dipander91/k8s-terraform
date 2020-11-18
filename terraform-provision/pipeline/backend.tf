terraform {
  backend "s3" {
    bucket = "demo-k8s-cicd"
    key    = "pipeline/pipeline.tfstate"
    region = "eu-west-1"
  }
}

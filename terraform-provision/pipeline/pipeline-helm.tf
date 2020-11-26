
resource "aws_s3_bucket" "codepipeline_bucket_helm" {
  bucket = var.helm_artifact_s3_bucket
  acl    = "private"
}


resource "aws_codepipeline_webhook" "helm_webhook" {
  name            = "eks-helm-webhook-github"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.ekshelmpipeline.name

  authentication_configuration {
    secret_token = local.webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

/*
resource "github_repository_webhook" "aws_codepipeline" {
  repository = var.github_repo

  configuration {
    url          = aws_codepipeline_webhook.webhook.url
    content_type = "json"
    insecure_ssl = "true"
    secret       = local.webhook_secret
  }

  events = ["push"]
}
*/

resource "aws_codepipeline" "ekshelmpipeline" {
  name     = var.helm_pipeline_name
  role_arn = module.eks_codepipeline_role.iam_role_arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_helm.bucket
    type     = "S3"
  }
  tags = local.pipeline_tags
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["helm_source_output"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.helm_github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "ManualApprovalStage"

    action {
      name     = "ManualApprovalStage"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        "CustomData" : "Approval to deploy to development namespace",
      }
    }
  }

  stage {
    name = "HelmDeployDevelopment"

    action {
      name             = "HelmDeployDevelopment"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["helm_source_output"]
      output_artifacts = ["helm_build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.eks_helm_deploy_project.name

        EnvironmentVariables = jsonencode(local.helm_deploy_env_vars)


      }

    }
  }

  


}



resource "aws_codebuild_project" "eks_helm_deploy_project" {
  name         = "eks-helm-deploy-project"
  description  = "To release using helm"
  service_role = module.eks_codebuild_role.iam_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.helm_deploy_cwlogs_group
      stream_name = "eks"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-deploy.yml"
    auth {
      type = "OAUTH"
    }
  }

  source_version = "master"


}


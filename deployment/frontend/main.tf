resource "aws_s3_bucket" "deployment-bucket" {
  bucket = "deployment-cryptern-${var.part}-${var.env}"
  versioning {
    enabled = true
  }
  tags = {
    "name" = "deployment-cryptern-${var.part}-${var.env}"
  }
}
resource "aws_s3_bucket_public_access_block" "deployment-bucket" {
  bucket = aws_s3_bucket.deployment-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket" "codepipeline-bucket" {
  bucket = "codepipeline-cryptern-${var.part}-${var.env}"
  versioning {
    enabled = true
  }
  tags = {
    "name" = "codepipeline-cryptern-${var.part}-${var.env}"
  }
}
resource "aws_s3_bucket_public_access_block" "codepipeline-bucket" {
  bucket = aws_s3_bucket.codepipeline-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_codebuild_project" "codebuild-project" {
  name          = "cryptern-codebuild-${var.env}"
  build_timeout = "60"
  service_role  = var.codeBuildRoleArn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = element(var.envVariables, 0)
      value = "${element(var.envVariables, 0)}_${var.env}"
      type  = "PARAMETER_STORE"
    }
    environment_variable {
      name  = element(var.envVariables, 1)
      value = "${element(var.envVariables, 1)}_${var.env}"
      type  = "PARAMETER_STORE"
    }
    environment_variable {
      name  = element(var.envVariables, 2)
      value = "${element(var.envVariables, 2)}_${var.env}"
      type  = "PARAMETER_STORE"
    }
  }
  source {
    type = "CODEPIPELINE"
  }
  vpc_config {
    vpc_id = var.vpc

    subnets = var.privateSubnet

    security_group_ids = var.publicSecurityGroupId

  }
  tags = {
    "name"      = "cryptern-codebuild-${var.env}"
    "terraform" = "true"
  }
}

resource "aws_codedeploy_app" "codedeployapp" {
  compute_platform = "Server"
  name             = "codedeploy-cryptern-${var.part}-${var.env}"
}
resource "aws_codedeploy_deployment_group" "codedeploygroup" {
  app_name               = aws_codedeploy_app.codedeployapp.name
  deployment_group_name  = "codedeploygroup-cryptern-${var.part}-${var.env}"
  deployment_config_name = var.deploymentConfigName
  service_role_arn       = var.codeDeployRoleArn
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }
  autoscaling_groups = [var.asg]
  load_balancer_info {
    target_group_info {
      name = var.targetGroup
    }
  }
}
resource "aws_codepipeline" "codepipeline" {
  name     = "codepipeline-cryptern-${var.part}-${var.env}"
  role_arn = var.codepipelineRoleArn
  depends_on = [
    aws_s3_bucket.codepipeline-bucket,
    aws_codedeploy_deployment_group.codedeploygroup,
    aws_codedeploy_app.codedeployapp,
    aws_s3_bucket.deployment-bucket,
    aws_codebuild_project.codebuild-project
  ]
  artifact_store {
    location = aws_s3_bucket.codepipeline-bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        "S3Bucket" : aws_s3_bucket.deployment-bucket.bucket,
        "S3ObjectKey" : var.appZip,
        "PollForSourceChanges" : "true"
      }
    }
  }
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild-project.name
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        "ApplicationName" : aws_codedeploy_app.codedeployapp.name,
        "DeploymentGroupName" : aws_codedeploy_deployment_group.codedeploygroup.deployment_group_name
      }
    }
  }
}

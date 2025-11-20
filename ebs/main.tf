provider "aws" {
  region = "us-east-1"
}



resource "aws_elastic_beanstalk_application" "github_app" {
  name        = "github-beanstalk-app"
  description = "Elastic Beanstalk Application for GitHub Runner"
  
}

resource "aws_elastic_beanstalk_environment" "github_env" {
  name                = "github-beanstalk-env"
  application         = aws_elastic_beanstalk_application.github_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.7.1 running Corretto 21"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "GITHUB_RUNNER_NAME"
    value     = "my-github-runner"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_NAME"
    value     = var.db_name
  
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USER"
    value     = var.db_user
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PASSWORD"
    value     = var.db_password
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOST"
    value     = var.db_host
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PORT"
    value     = var.db_port
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
}


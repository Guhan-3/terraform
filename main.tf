provider "aws" {
  region = "us-east-1"
}




resource "aws_instance" "github" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name

    tags = {
        Name = "github-runner"
    }

}
resource "aws_iam_role" "beanstalk_ec2_role" {  
  name               = "aws-elasticbeanstalk-ec2-role"  
  assume_role_policy = data.aws_iam_policy_document.beanstalk_ec2_assume_role_policy.json  
}  
  
data "aws_iam_policy_document" "beanstalk_ec2_assume_role_policy" {  
  statement {  
    effect = "Allow"  
  
    actions = [  
      "sts:AssumeRole",  
    ]  
  
    principals {  
      type        = "Service"  
      identifiers = ["ec2.amazonaws.com"]  
    }  
  }  
}  
  
# Attach the managed policies for Elastic Beanstalk  
resource "aws_iam_role_policy_attachment" "beanstalk_ec2_managed_policy" {  
  role       = aws_iam_role.beanstalk_ec2_role.name  
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"  
}  
  
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {  
  role       = aws_iam_role.beanstalk_ec2_role.name  
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"  
}  
  
# Create an IAM Instance Profile for Elastic Beanstalk  
resource "aws_iam_instance_profile" "beanstalk_instance_profile" {  
  name = "aws-elasticbeanstalk-ec2-role"  
  role = aws_iam_role.beanstalk_ec2_role.name  
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
    value     = aws_iam_instance_profile.beanstalk_instance_profile.name
  }
}


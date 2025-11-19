terraform {
  backend "s3" {
    bucket         = "statefile-bucketdemo-guna-1119"
    key            = "terraform/state"
    region        = "us-east-1"
  }
}
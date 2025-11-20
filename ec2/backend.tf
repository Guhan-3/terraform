terraform {
  backend "s3" {
    bucket         = "statefile-bucketdemo-guna-1119"
    key            = "statefile"
    region        = "us-east-1"
  }
}
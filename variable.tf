variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default = "ami-0fa3fe0fa7920f68e" # Example AMI ID for Amazon Linux 2 in us-east-1
}
variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t2.micro"
}
variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
  default     = "github" # Replace with your actual key pair name
}
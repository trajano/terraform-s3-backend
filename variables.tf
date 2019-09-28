variable "region" {
  default = "us-east-1"
}
variable "prefix" {
  default     = "terraform/"
  description = "Path prefix for IAM resources.  Must end with `/` or is and empty string for no prefix."
}
variable "bucket" {
  description = "S3 bucket name."
}
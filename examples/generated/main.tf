terraform {
  backend "s3" {
    bucket = "terraform-s3-backend-sample-bucket"
    key    = "path/to/my/key"
    region = "us-east-1"
    dynamodb_table = "terraform-s3-backend-sample-bucket-locks"
  }
}

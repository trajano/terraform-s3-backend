module "terraform-s3-backend" {
  source = "../.."
  region = "us-east-1"
  bucket = "terraform-s3-backend-sample-bucket"
}
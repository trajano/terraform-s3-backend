module "terraform-s3-backend" {
  source = "../.."
  region = "us-east-1"
  bucket = "terraform-s3-backend-sample-bucket"
}

output "policy_id" {
  value = module.terraform-s3-backend.policy_id
}

output "usage" {
  value = module.terraform-s3-backend.usage
}

provider "aws" {
  version = "~>2.30"
  region  = var.region
}

data "aws_iam_policy_document" "terraform" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.terraform.arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.terraform.arn}/*",
    ]
  }

  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
    resources = [
      aws_dynamodb_table.terraform.arn
    ]
  }

}

resource "aws_iam_policy" "terraform" {
  name   = "TerraformStateFullAccess"
  path   = "/${var.prefix}"
  policy = "${data.aws_iam_policy_document.terraform.json}"
}

resource "aws_s3_bucket" "terraform" {
  bucket = var.bucket
  acl    = "private"
  region = var.region

  tags = {
    Name = "Terraform S3 backend bucket"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "terraform" {
  bucket = aws_s3_bucket.terraform.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_dynamodb_table" "terraform" {
  name      = "${var.bucket}-locks"
  hash_key  = "LockID"

  # Not sure if this is okay or not, it may be better to use PAY_PER_REQUEST since Terraforms do not happen often.
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.bucket} Terraform S3 Backend Locks"
  }
}

locals {
  usage = <<EOF
terraform {
  backend "s3" {
    bucket = "${var.bucket}"
    key    = "path/to/my/key"
    region = "${var.region}"
    dynamodb_table = "${aws_dynamodb_table.terraform.name}"
  }
}
EOF
}

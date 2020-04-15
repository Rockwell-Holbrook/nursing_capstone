// This defines the remote state file location. S3 bucket must exist before deployment
terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "beats-backend-terraform-state-storage-dev"
    key            = "beats-backend/terraform.tfstate"
    region         = "us-west-2"
    profile        = "nursing"
  }
}
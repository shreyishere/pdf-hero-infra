terraform {
  backend "s3" {
    bucket         = "terraform-state-shrey"
    key            = "terraform/pdf-hero-infra/eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

terraform {
  backend "s3" {
    bucket         = "terrastack-tfstate-1765377369" # Replace this!
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terrastack-locks"
    encrypt        = true
  }
}

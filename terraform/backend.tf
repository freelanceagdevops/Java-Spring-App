terraform {
  backend "s3" {
    bucket = "java-terraform-s3-bucket"
    key    = "key/terraform.tfstate"
    region = "ap-south-1"
  }
}

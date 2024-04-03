terraform {
  backend "s3" {
    bucket = "devops-course-tf-state"
    region = "us-east-1"
  }
}

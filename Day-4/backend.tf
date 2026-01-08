 terraform {
   backend "s3" {
    bucket = "shantanudev"
    key ="terraform.tfstate"
    region = "us-east-1"
     
   }
 }
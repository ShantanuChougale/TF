 terraform {
   backend "s3" {
    bucket = "shantanudev"
    key ="day-4/terraform.tfstate"
    region = "us-east-1"
     #Enable s3 native locking
    # use_lockfile = true
     # The dynamodb_table argument is no longer needed
     dynamodb_table = "terraform-lock"
   }
 }
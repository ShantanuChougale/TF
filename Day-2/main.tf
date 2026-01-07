resource "aws_instance" "name" {
    ami= var.ami_id
    instance_type = "t2.micro"
    tags = {
        Name = "dev"
    }
  
}
resource "aws_s3_bucket" "s3" {
    bucket = "shantanu"
    
  
}

resource "aws_instance" "name" {
    ami = var.shantanu
    instance_type = var.type
  
}
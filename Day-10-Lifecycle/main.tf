resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    tags = {
      Name = "dev"
    }

    # lifecycle {
    #   prevent_destroy = true
    # }
#    lifecycle {
#      ignore_changes = [ instance_type, ]
#    }
lifecycle {
  create_before_destroy = true
}
}
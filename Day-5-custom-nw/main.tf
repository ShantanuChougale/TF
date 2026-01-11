resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "test" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.0.0/24"
    
    tags = {
      Name = "test"
    }
  
}
resource "aws_subnet" "test2" {
  vpc_id =aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "test2"
  }
}
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.dev.id
   
}

#resource "aws_internet_gateway_attachment" "name" {
 #internet_gateway_id = aws_internet_gateway.name.id
#  vpc_id = aws_vpc.name.id
#}

resource "aws_route_table" "p-rt" {
    vpc_id = aws_vpc.dev.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id
    }
  
}
resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.test.id
  route_table_id = aws_route_table.p-rt.id
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
  
}


resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.test.id
    tags = {
      Name = "nat"
    }
    depends_on = [ aws_internet_gateway.name ]
  
}

resource "aws_route_table" "pr-rt" {
    vpc_id = aws_vpc.dev.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
  tags = {
    Name = "pr-rt"
  }
}
resource "aws_route_table_association" "private_assoc" {
    subnet_id = aws_subnet.test2.id
    route_table_id = aws_route_table.pr-rt.id
  
}

resource "aws_security_group" "SG" {
    name = "allow"
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "SG"
    }
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    } 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" # indicates all protocol
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}
resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.test.id
    vpc_security_group_ids = [ aws_security_group.SG.id]
    
  
}
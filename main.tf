terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}

provider "aws" {
  
}
#Network
resource "aws_vpc" "tf_vpc3" {        
    cidr_block = "10.20.0.0/16"
    tags = {
      "Name" = "tf-vpc"              
      "Description" = "this vpc has subnet 1"
    }
  
}
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.tf_vpc3.id              
  cidr_block = "10.20.1.0/24"

  availability_zone = "us-east-1a"
  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf_vpc3.id
  tags = {
    "Name" = "tf_internet gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.tf_vpc3.id
  tags = {
    Name = "public_route_table"
  }
}
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}


resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.tf_vpc3.id              
  cidr_block = "10.20.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "Name" = "private-subnet"
  }
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"
} 
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.private_subnet.id
  tags = {
    Name = "NAT-gateway"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.tf_vpc3.id
  tags = {
    Name = "private_route_table"
  }
}
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}
# EC2

resource "aws_instance" "public_EC2" {
  ami           = "ami-0c02fb55956c7d316" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "Public EC2 Instance"
  }
}

resource "aws_instance" "private_EC2" {
  ami           = "ami-0c02fb55956c7d316" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  tags = {
    Name = "Private EC2 Instance"
  }
}
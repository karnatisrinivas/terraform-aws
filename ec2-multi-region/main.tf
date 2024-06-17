provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "useast2"
  region = "us-east-2"
}

# VPC and Subnets for us-east-1
resource "aws_vpc" "vpc1" {
  provider = aws.useast1
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc1"
  }
}

resource "aws_subnet" "subnet_us_east_1a" {
  provider = aws.useast1
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-us-east-1a"
  }
}

resource "aws_subnet" "subnet_us_east_1b" {
  provider = aws.useast1
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "subnet-us-east-1b"
  }
}

resource "aws_internet_gateway" "igw1" {
  provider = aws.useast1
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "igw1"
  }
}

resource "aws_route_table" "rt1" {
  provider = aws.useast1
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }
  tags = {
    Name = "rt-us-east-1"
  }
}

resource "aws_route_table_association" "rta_us_east_1a" {
  provider = aws.useast1
  subnet_id = aws_subnet.subnet_us_east_1a.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "rta_us_east_1b" {
  provider = aws.useast1
  subnet_id = aws_subnet.subnet_us_east_1b.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_security_group" "sg1" {
  provider = aws.useast1
  vpc_id = aws_vpc.vpc1.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg1"
  }
}

resource "aws_instance" "instance1" {
  provider = aws.useast1
  ami = "ami-08a0d1e16fc3f61ea" 
  instance_type = "t2.small"
  subnet_id = aws_subnet.subnet_us_east_1a.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  associate_public_ip_address = true
  tags = {
    Name = "instance1"
  }
}

# VPC and Subnets for us-east-2
resource "aws_vpc" "vpc2" {
  provider = aws.useast2
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc-us-east-2"
  }
}

resource "aws_subnet" "subnet_us_east_2a" {
  provider = aws.useast2
  vpc_id = aws_vpc.vpc2.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "subnet-us-east-2a"
  }
}

resource "aws_subnet" "subnet_us_east_2b" {
  provider = aws.useast2
  vpc_id = aws_vpc.vpc2.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "subnet-us-east-2b"
  }
}

resource "aws_internet_gateway" "igw2" {
  provider = aws.useast2
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "igw2"
  }
}

resource "aws_route_table" "rt2" {
  provider = aws.useast2
  vpc_id = aws_vpc.vpc2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw2.id
  }
  tags = {
    Name = "rt2"
  }
}

resource "aws_route_table_association" "rta_us_east_2a" {
  provider = aws.useast2
  subnet_id = aws_subnet.subnet_us_east_2a.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_route_table_association" "rta_us_east_2b" {
  provider = aws.useast2
  subnet_id = aws_subnet.subnet_us_east_2b.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_security_group" "sg2" {
  provider = aws.useast2
  vpc_id = aws_vpc.vpc2.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg2"
  }
}

resource "aws_instance" "instance2" {
  provider = aws.useast2
  ami = "ami-033fabdd332044f06" 
  instance_type = "t2.small"
  subnet_id = aws_subnet.subnet_us_east_2a.id
  vpc_security_group_ids = [aws_security_group.sg2.id]
  associate_public_ip_address = true
  tags = {
    Name = "instance2"
  }
}

provider "aws" {
  region = var.region

}

resource "aws_vpc" "module_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    "Name" = "Qa-VPC"
  }
}


resource "aws_subnet" "module_public_subnet_1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "Public-Subnet-1"
  }
}


resource "aws_subnet" "module_public_subnet_2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name = "Public-Subnet-2"
  }
}

resource "aws_subnet" "module_private_subnet_1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    "Name" = "Private-Subnet-1"
  }
}

resource "aws_subnet" "module_private_subnet_2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    "Name" = "Private-Subnet-2"
  }
}

resource "aws_subnet" "module_private_subnet_3" {
  cidr_block        = var.private_subnet_3_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    "Name" = "Private-Subnet-3"
  }
}

resource "aws_subnet" "module_private_subnet_4" {
  cidr_block        = var.private_subnet_4_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    "Name" = "Private-Subnet-4"
  }
}

resource "aws_subnet" "module_private_subnet_5" {
  cidr_block        = var.private_subnet_5_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    "Name" = "Private-Subnet-5"
  }
}

resource "aws_subnet" "module_private_subnet_6" {
  cidr_block        = var.private_subnet_6_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    "Name" = "Private-Subnet-6"
  }
}

resource "aws_subnet" "module_private_subnet_7" {
  cidr_block        = var.private_subnet_7_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    "Name" = "Private-Subnet-7"
  }
}

resource "aws_subnet" "module_private_subnet_8" {
  cidr_block        = var.private_subnet_8_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    "Name" = "Private-Subnet-8"
  }
}

resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.module_vpc.id

  tags = {
    "Name" = "Public-Route-Table"
  }

}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.module_vpc.id


  tags = {
    "Name" = "Private_Route-Table"
  }
}


resource "aws_route_table_association" "public_subnet_1_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.module_public_subnet_1.id

}

resource "aws_route_table_association" "public_subnet_2_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.module_public_subnet_2.id

}

resource "aws_route_table_association" "private_subnet_1_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.module_private_subnet_1.id

}

resource "aws_route_table_association" "private_subnet_2_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.module_private_subnet_2.id

}

resource "aws_route_table_association" "private_subnet_3_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.module_private_subnet_3.id

}

resource "aws_route_table_association" "private_subnet_4_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.module_private_subnet_4.id

}

resource "aws_route_table_association" "private_subnet_5_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.module_private_subnet_5.id

}

resource "aws_route_table_association" "private_subnet_6_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.module_private_subnet_6.id

}

resource "aws_route_table_association" "private_subnet_7_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.module_private_subnet_7.id

}

resource "aws_route_table_association" "private_subnet_8_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.module_private_subnet_8.id

}

resource "aws_eip" "elastic_ip_for_nat_gw" {
  vpc                       = true
  associate_with_private_ip = var.eip_association_address

  tags = {
    Name = "Qa-EIP"
  }


}

resource "aws_nat_gateway" "nat_gatway" {
  allocation_id = aws_eip.elastic_ip_for_nat_gw.id
  subnet_id     = aws_subnet.module_public_subnet_1.id

  tags = {
    Name = "Qa-Nat-Gw"
  }
}

resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  nat_gateway_id         = aws_nat_gateway.nat_gatway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.module_vpc.id


  tags = {
    "Name" = "Qa-IGW"
  }

}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}




resource "aws_instance" "bastion" {
  ami             = "ami-00be885d550dcee43"
  instance_type   = var.ec2_instance_type
  key_name        = var.ec2_keypair
  security_groups = [aws_security_group.ec2-security-group.id]
  subnet_id       = aws_subnet.module_public_subnet_1.id
}

resource "aws_security_group" "ec2-security-group" {
  name   = "EC2-instance-SG"
  vpc_id = aws_vpc.module_vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_vpc" "this" {
  count             = var.vpc_id == null ? 1 : 0
  cidr_block        = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-terraform"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id != null ? var.vpc_id : aws_vpc.this[0].id
}

resource "aws_subnet" "this" {
  count             = var.subnet_id == null ? 1 : 0
  vpc_id            = var.vpc_id != null ? var.vpc_id : aws_vpc.this[0].id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id != null ? var.vpc_id : aws_vpc.this[0].id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  subnet_id = var.subnet_id != null ? var.subnet_id : aws_subnet.this[0].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Segurança da instância EC2"
  vpc_id = var.vpc_id != null ? var.vpc_id : aws_vpc.this[0].id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Porta 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Porta 8443"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.medium"
  subnet_id = var.subnet_id != null ? var.subnet_id : aws_subnet.this[0].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.ssh_key_name

  root_block_device {
    volume_size = 15
    volume_type = "gp2"
  }

  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}

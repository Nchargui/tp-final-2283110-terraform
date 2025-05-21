
#VPC  ##################################

resource "aws_vpc" "vpc_final_2283110" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vpc-tp-final-2283110"
  }
}

variable "vpc_cidr" {
  type        = string
  description = "Plages d'adresses du VPC"
  default     = "10.0.0.0/16"
}

#SOUS-RÉSEAU #############################

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Plages d'adresses des sous-réseaux publics"
  default     = ["10.0.0.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Plages d'adresses des sous-réseaux privés"
  default     = ["10.0.1.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Zone de disponibilité"
  default     = ["us-east-1a"]
}

#ASSOCIATION SOUS-RÉSEAU AU VPC #############################
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc_final_2283110.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "vpc_final_2283110-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc_final_2283110.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "vpc_final_2283110-private-${count.index + 1}"
  }
}


#PASSERELLE INTERNET #############################

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_final_2283110.id

  tags = {
    Name = "vpc_final_2283110-igw"
  }
}

#TABLEs DE ROUTAGE ################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_final_2283110.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "final_2283110-rtb-public"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_final_2283110.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "final_2283110-rtb-private"
  }
}

#ASSOCIATION SOUS-RÉSEAU/TABLES DE ROUTAGE #############

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}


#### GROUPE DE SÉCURITÉ ##################################


resource "aws_security_group" "security_group_2283110" {
  name        = "security_group_2283110"
  description = "ssh access, http and https access, tcp personalise pour le backend 9696"
  vpc_id      = aws_vpc.vpc_final_2283110.id

  ingress {

    description = "SSH access"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS access"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "backend access"
    from_port   = "9696"
    to_port     = "9696"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}





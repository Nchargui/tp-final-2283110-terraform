#resource "aws_key_pair" "tp_final_2283110_key" {
# key_name   = "tp_final_2283110_key"
#public_key = tls_private_key.rsa.public_key_openssh
#}

#resource "tls_private_key" "rsa" {
# algorithm = "RSA"
#rsa_bits  = 4096

#}

#resource "local_file" "cluster_keypair" {
# content  = tls_private_key.rsa.private_key_pem
#filename = "${path.module}/tp_final_2283110_key.pem"
#}


###### INSTANCE


resource "aws_instance" "tp_final_instance_2283110" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.public_subnets[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.security_group_2283110.id]

  key_name = "tp_final_2283110_key"

  tags = {
    Name = "tp-final-instance-2283110"
  }

  user_data = file("${path.module}/user-data.sh")

}

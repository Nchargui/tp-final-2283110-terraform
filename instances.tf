resource "aws_key_pair" "final_2283110_key" {
  key_name   = "final-2283110-keypair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "local_file" "cluster_keypair" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "${path.module}/tp-final-2283110-keypair.pem"
}
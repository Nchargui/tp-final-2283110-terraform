variable "ami_id" {
  type        = string
  description = "Id de l'AMI de l'instance"
  default     = "ami-084568db4383264d4"
}

variable "instance_type" {
  type        = string
  description = "Type de l'instance EC2"
  default     = "t2.large"
}
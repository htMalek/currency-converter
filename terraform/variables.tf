variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type instance EC2"
  default     = "t2.large"
}

variable "key_name" {
  description = "Nom de la clé SSH"
  default     = "vockey"
}

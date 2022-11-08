variable "key_pair_name" {
    type = string
}

variable "vpc_security_group_ids" {
    type = list
}

variable "target_subnet" {
  type = string
}

variable "private_key_pem" {
  type = string
}



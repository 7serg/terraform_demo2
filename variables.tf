variable "aws_region" {

  default = "eu-central-1"
}

variable "bucket_name" {
  type    = string
  default = "malkosergeyseconddemoecs"

}

variable "versioning" {
  type    = bool
  default = true
}


variable "tags" {
  type = map(any)
  default = {
    Name        = "demoecs",
    environment = "staging"
  }
}

variable "vpc_cidr" {
  default     = "10.10.0.0/16"
  description = "VPC cidr block"
}

variable "env" {
  default = "staging"
}



variable "public_subnets_cidr" {
  description = "Public subnets"
  default = [
    "10.10.11.0/24",
    "10.10.12.0/24"
  ]

}


variable "private_subnets_cidr" {
  description = "Private subnets cidr"
  default = [
    "10.10.20.0/24",
    "10.10.21.0/24"
  ]
}

variable "bastion_ssh_key_name" {
  default = "test"
}

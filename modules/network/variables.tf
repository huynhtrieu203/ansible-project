variable "region" {
  type    = string
  default = "us-west-2"
}

variable "azs" {
  type    = list(any)
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnet" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "cidr_block_any" {
  type    = string
  default = "0.0.0.0/0"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

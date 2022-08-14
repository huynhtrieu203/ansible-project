variable "region" {
  type    = string
  default = "us-west-2"
}

variable "azs" {
  type    = list(any)
  default = ["us-west-2a", "us-west-2b"]
}

variable "ami" {
  description = "ami id"
  type        = string
  default     = "ami-0cea098ed2ac54925"
}

variable "instance_type" {
  description = "Instance type to create an instance"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  type = list
}

variable "vpc_id" {
  type = string
}

variable "cidr_group" {
  type    = string
  default = "0.0.0.0/0" 
}

variable "instance_number" {
  type = number
  default = 2
}

variable "ami_id" {
  description = "ami id"
  type        = string
  default     = "ami-0c802847a7dd848c0"
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
variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "availability_zone" {
  type    = list(any)
  default = ["ap-southeast-1a", "ap-southeast-1b"]

}

variable "storage" {
  type    = number
  default = 5
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "5.7"
}

variable "db_password" {
  description = "RDS root user password"
  default     = "Admin123"
  sensitive   = true
}

variable "instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "db_username" {
  description = "RDS root user password"
  default     = "admin"
}

variable "db_name" {
  type    = string
  default = "db"
}

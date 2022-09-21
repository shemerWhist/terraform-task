variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "public_subnet1_id" {
  type        = string
  description = "public subnet1 id"
}

variable "public_subnet2_id" {
  type        = string
  description = "public subnet2 id"
}

variable "alb-sg-id" {
  type        = string
  description = "application load balancer sg id"
}

variable "private-instance-1a-id" {
  type        = string
  description = "private-instance-1a-id"
}

variable "private-instance-1b-id" {
  type        = string
  description = "private-instance-1b-id"
}
variable "public-instance-1a-id" {
  type        = string
  description = "public-instance-1a-id"
}

variable "public-instance-1b-id" {
  type        = string
  description = "public-instance-1b-id"
}
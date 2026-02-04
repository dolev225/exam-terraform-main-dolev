variable "vpc_range" {
  default = "10.0.0.0/16"
}
variable "Subnet_count" {
  default = 1
}
variable "instance_type" {
  default = "t2.micro"
}
variable "if_Public_ip" {
  default = true
  type = bool
}
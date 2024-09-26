terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.128.0"
    }
  }
  required_version = "~>1.8.4"
}


#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

#создаем подсеть
# resource "yandex_vpc_subnet" "develop" {
#   name           = "${var.vpc_name}-${var.default_zone}"
#   zone           = var.default_zone
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.default_cidr
# }

# resource "yandex_vpc_subnet" "develop"  {
#     for_each = var.subnets 
#     # v4_cidr_blocks = each.value
#     # vpc_id     = aws_vpc.vpc.id
# }
# resource "yandex_vpc_subnet" "develop_b" {
#   name           = "${var.vpc_name}-${var.zone}"
#   zone           = var.zone
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.cidr
# }
# resource "aws_security_group" "env0_security_group" {
#   name        = "env0-security-group"
#   vpc_id      = aws_vpc.env0_vpc.id

#   dynamic "ingress" {
#     for_each = [for rule in var.security_group_rules : rule if rule.type == "ingress"]
#     content {
#       from_port   = ingress.value.from_port
#       to_port     = ingress.value.to_port
#       protocol    = ingress.value.protocol
#       cidr_blocks = ingress.value.cidr_blocks
#     }
#   }  
# }
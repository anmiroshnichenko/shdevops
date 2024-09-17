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
resource "yandex_vpc_subnet" "develop" {
  name           = "${var.vpc_name}-${var.default_zone}"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

# resource "yandex_vpc_subnet" "develop_b" {
#   name           = "${var.vpc_name}-${var.zone}"
#   zone           = var.zone
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.cidr
# }
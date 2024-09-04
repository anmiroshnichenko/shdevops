# data "yandex_vpc_network" "net" {
#   folder_id = "<идентификатор_каталога>"
#   name      = "<имя_сети>"
# }

# resource "yandex_vpc_subnet" "subnet" {
#   folder_id      = "<идентификатор_каталога>"
#   name           = "<имя_подсети>"
#   v4_cidr_blocks = ["10.20.30.0/24"]
#   zone           = "ru-central1-a"
#   network_id     = data.yandex_vpc_network.net.id
#   route_table_id = yandex_vpc_route_table.rt.id
# }

resource "yandex_vpc_gateway" "nat_gateway" {
#   folder_id      = "<идентификатор_каталога>"
  name = "test-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
#   folder_id      = "<идентификатор_каталога>"
  name       = "test-route-table"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

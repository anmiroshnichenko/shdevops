output "external_platform-web" {
value = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}

output "internal_platform-web" {
value = yandex_compute_instance.platform.network_interface[0].ip_address
}

output "external_platform-db" {
value = yandex_compute_instance.platform-db.network_interface[0].nat_ip_address
}

output "internal_platform-db" {
value = yandex_compute_instance.platform-db.network_interface[0].ip_address
}
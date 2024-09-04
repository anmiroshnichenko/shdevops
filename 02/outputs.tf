
output "virtual_machines" {

  value = [
    { web = [
        yandex_compute_instance.platform.name, 
        yandex_compute_instance.platform.network_interface[0].nat_ip_address, 
        yandex_compute_instance.platform.fqdn
    ] },
    { db = [
        yandex_compute_instance.platform-db.name,
        yandex_compute_instance.platform-db.network_interface[0].nat_ip_address,
        yandex_compute_instance.platform.fqdn
    ] }   
  ]
}

# output "platform-web" {
# value = [
#     yandex_compute_instance.platform.name, 
#     yandex_compute_instance.platform.network_interface[0].nat_ip_address,
#     yandex_compute_instance.platform.fqdn
#  ]     
# }

# output "platform-db" {
# value = [
#     yandex_compute_instance.platform-db.name, 
#     yandex_compute_instance.platform-db.network_interface[0].nat_ip_address,
#     yandex_compute_instance.platform-db.fqdn
# ]
# }



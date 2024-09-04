resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_subnet" "develop_1" {
  name           = var.vpc_1_name
  zone           = var.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr
  route_table_id = yandex_vpc_route_table.rt.id
}


data "yandex_compute_image" "ubuntu" {  
  family = var.vm_web_image_family
}

# VM_1_netology-develop-platform-web 
resource "yandex_compute_instance" "platform" {  
  name = local.name_web  
  platform_id = var.vm_web_platform_id
  resources {    
    cores         = var.vms_resources["web"]["cores"]
    memory        = var.vms_resources["web"]["memory"]
    core_fraction = var.vms_resources["web"]["core_fraction"]
  }
  # resources {    
  #   cores         = var.vm_web_cores
  #   memory        = var.vm_web_memory
  #   core_fraction = var.vm_web_core_fraction
  # }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {    
    preemptible = var.vm_web_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id    
    nat       = var.vm_web_network_interface_nat
  }

  metadata = {
    serial-port-enable = var.metadata["serial-port-enable"]
    ssh-keys           = var.metadata["ssh-keys"]
  }  
  # metadata = {
  #   serial-port-enable = 1
  #   ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  # }
}

# VM_2_netology-develop-platform-db
resource "yandex_compute_instance" "platform-db" {  
  name = local.name_db 
  platform_id = var.vm_db_platform_id
  zone        = var.zone
  resources {    
    cores         = var.vms_resources["db"]["cores"]
    memory        = var.vms_resources["db"]["memory"]
    core_fraction = var.vms_resources["db"]["core_fraction"]
  }
  # resources {    
  #   cores         = var.vm_db_cores
  #   memory        = var.vm_db_memory
  #   core_fraction = var.vm_db_core_fraction
  # }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {    
    preemptible = var.vm_db_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_1.id
    nat       = var.vm_db_network_interface_nat
  }

  metadata = {
    serial-port-enable = var.metadata["serial-port-enable"]
    ssh-keys           = var.metadata["ssh-keys"]
  }
  # metadata = {
  #   serial-port-enable = 1
  #   ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  # }
}

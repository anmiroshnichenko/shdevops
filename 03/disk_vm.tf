resource "yandex_compute_disk" "storage_disk" {
  count    = length(var.disk_count) 
  name     = "storage-disk-${count.index+1}" 
  size     = var.disk_size
  type     = var.disk_type
  zone     = var.default_zone 

  labels = {
    environment = var.environment
  }
}


resource "yandex_compute_instance" "storage" {  
  name = "storage"  
  platform_id = var.vm_platform_id  
  
  resources {    
    cores         = var.vms_resources["web"]["cores"]
    memory        = var.vms_resources["web"]["memory"]
    core_fraction = var.vms_resources["web"]["core_fraction"]
  }  
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  dynamic "secondary_disk" {    
    for_each = var.disk_count
    content {
      disk_id = yandex_compute_disk.storage_disk[secondary_disk.value].id
    }
  }
  
  scheduling_policy {    
    preemptible = var.vm_scheduling_policy_preemptible
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id    
    nat       = var.vm_network_interface_nat
    # security_group_ids = [yandex_vpc_security_group.example.id]   
  }

  metadata = {
    serial-port-enable = local.serial-port-enable
    ssh-keys = local.ssh-keys
    # serial-port-enable = var.metadata["serial-port-enable"]
    # ssh-keys           = var.metadata["ssh-keys"]
  }  
}

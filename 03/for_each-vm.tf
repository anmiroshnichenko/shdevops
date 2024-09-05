resource "yandex_compute_instance" "db" {  
  for_each = { for k, v in var.each_vm : k => v }
  name  = each.value.vm_name  
  platform_id = var.vm_platform_id   

  resources {    
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = var.vms_resources["web"]["core_fraction"]
  }  
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = each.value.disk_volume
    }
  }
  
  scheduling_policy {    
    preemptible = each.value.preemptible
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id    
    nat       = var.vm_network_interface_nat
    security_group_ids = [yandex_vpc_security_group.example.id]   
  }

  metadata = {
    serial-port-enable = local.serial-port-enable
    ssh-keys = local.ssh-keys
    # serial-port-enable = var.metadata["serial-port-enable"]
    # ssh-keys           = var.metadata["ssh-keys"]
  }  
}
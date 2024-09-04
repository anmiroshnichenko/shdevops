resource "yandex_compute_instance" "web" {  
  count = var.vm_count
  name = "web-${count.index+1}"  
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
  
  scheduling_policy {    
    preemptible = var.vm_scheduling_policy_preemptible
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id    
    nat       = var.vm_network_interface_nat
    security_group_ids = [yandex_vpc_security_group.example.id]   
  }

  metadata = {
    serial-port-enable = var.metadata["serial-port-enable"]
    ssh-keys           = var.metadata["ssh-keys"]
  }  
}
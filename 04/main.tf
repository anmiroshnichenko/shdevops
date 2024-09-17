# #создаем облачную сеть
# resource "yandex_vpc_network" "develop" {
#   name = "develop"
# }

# #создаем подсеть
# resource "yandex_vpc_subnet" "develop_a" {
#   name           = "develop-ru-central1-a"
#   zone           = "ru-central1-a"
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = ["10.0.1.0/24"]
# }

resource "yandex_vpc_subnet" "develop_b" {
  name           = "develop-ru-central1-b"
  zone           = "ru-central1-b"
  # network_id     = yandex_vpc_network.develop.id
  network_id     = module.vpc_dev.yandex_vpc_network
  v4_cidr_blocks = ["10.0.2.0/24"]  
}

module "vpc_dev" {
  source       = "./vpc"
  vpc_name     = "develop"
  default_zone = "ru-central1-a"  
  # zone         = "ru-central1-b"
  default_cidr = ["10.0.1.0/24"]  
  # cidr         = ["10.0.2.0/24"]
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop" 
  network_id     = module.vpc_dev.yandex_vpc_network
  subnet_zones   = ["ru-central1-b","ru-central1-a"]
  subnet_ids     = [yandex_vpc_subnet.develop_b.id,module.vpc_dev.yandex_vpc_subnet]
  instance_name  = "web"
  instance_count = 1
  image_family   = var.image_family  
  public_ip      = true
  # depends_on = [ yandex_vpc_subnet.develop_b ]

  labels = { 
    owner= "a.miroshnichenko",
    project = "marketing"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

module "example-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "stage"
  network_id     = module.vpc_dev.yandex_vpc_network
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [module.vpc_dev.yandex_vpc_subnet]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    owner= "a.miroshnichenko",
    project = "analytics"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username       = var.username
    ssh_public_key = file(var.ssh_public_key)   
  }
}


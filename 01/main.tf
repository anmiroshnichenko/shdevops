terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
  required_version = "~>1.8.4" /*Многострочный комментарий.
 Требуемая версия terraform */
}
provider "docker" {
  host     = "ssh://miroshnichenko@89.169.141.231:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

#однострочный комментарий

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}


resource "docker_image" "nginx-stable" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx-stable.image_id
  name  = "example_${random_password.random_string.result}"
  # name  = "hello_world" 
  # docker psname = "${var.container_name}"

  ports {
    internal = 80
    external = 9090
  }
}

resource "docker_image" "mysql" {
  name = "mysql:8"
  keep_locally = true
}

resource "random_password" "mysql_root_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}


resource "docker_container" "mysql" {
  name  = "mysql"
  image = docker_image.mysql.image_id
  restart = "always"
  env = [
     "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
     "MYSQL_PASSWORD=${random_password.mysql_password.result}",
     "MYSQL_USER=${var.mysql_user}",
     "MYSQL_DATABASE=${var.mysql_database}",
     "MYSQL_ROOT_HOST=%"
  ]
  volumes {
    container_path = "/var/lib/mysql"
    host_path = "/tmp/db_data"
  }  
  ports {
    external = 3306
    internal = 3306
    ip = "127.0.0.1"    
  }
}


#   # mounts {
#   #   source = "/some/host/mysql/data/path"
#   #   target = "/var/lib/mysql/data"
#   #   type = "bind"
#   # }
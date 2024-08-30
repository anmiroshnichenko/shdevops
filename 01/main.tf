terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
  required_version = "~>1.9.5" /*Многострочный комментарий.
 Требуемая версия terraform */
}
provider "docker" {
  # host     = "ssh://miroshnichenko@84.201.128.234:22"
  # ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
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
  # name  = "example_${random_password.random_string.result}"
  # name  = "hello_world" 
  name = "${var.container_name}"

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
  length = 16
}

resource "docker_container" "mysql" {
  name  = "mysql"
  image = docker_image.mysql.image_id
  restart = "always"
  env = [
     "MYSQL_ROOT_PASSWORD=${random_password.random_string.result}",
     "MYSQL_PASSWORD=wordpress",
     "MYSQL_USER=wordpress",
     "MYSQL_DATABASE=wordpress"
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
#   #   MYSQL_DATABASE = "virtd"
#   #   # MYSQL_DATABASE = "${MYSQL_DATABASE}"
#   #   # MYSQL_USER = "${MYSQL_USER}"
#   #   # MYSQL_PASSWORD = "${MYSQL_PASSWORD}"
#   #   MYSQL_ROOT_HOST = "%" 
#   # } 
  

#   # mounts {
#   #   source = "/some/host/mysql/data/path"
#   #   target = "/var/lib/mysql/data"
#   #   type = "bind"
#   # }
  
  
# }

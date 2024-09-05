locals {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
}
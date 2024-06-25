terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}
locals {
  value1 = var.vpc_subnet_id
}


resource "yandex_compute_instance" "vm" {

  //name                      = "terraform-${var.instance_family_image}-${var.vnum}"
  name                      = "srv"
  zone                      = var.vzone
  allow_stopping_for_update = false
  resources {
    cores  = 4
    memory = 4
  }


  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 30
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

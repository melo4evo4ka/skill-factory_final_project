terraform {

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"

    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_alb_target_group" "my-target-group" {
  name = "my-target-group-1"

  target {
    ip_address = module.ya_instance_1.internal_ip_address_vm
    subnet_id  = module.my_network.subnnn1
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name = "myrouter-1"
  labels = {
    tf-label    = "tf-label-value-1"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "my-virtual-host-1"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name = "my-route-1"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.test-backend-group.id
        timeout          = "60s"
      }
    }
  }
}


resource "yandex_alb_backend_group" "test-backend-group" {
  name = "my-group-beckend-1"

  http_backend {
    name             = yandex_alb_target_group.my-target-group.name
    weight           = 1
    port             = 80
    target_group_ids = ["${yandex_alb_target_group.my-target-group.id}"]

    load_balancing_config {
      panic_threshold = 90
    }
    healthcheck {
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}

module "ya_instance_1" {
  source                = "./modules/instance"
  instance_family_image = "ubuntu-2204-lts"
  vpc_subnet_id         = module.my_network.subnnn1
  #vzone = "ru-central1-a"
  vzone = module.my_network.zone1
}

module "my_network" {
  source = "./modules/network"
  //vzone       = "ru-central1-a"
  //vnum        = "2"
  namesubnet1 = "subnet1"
  namesubnet2 = "subnet2"
}

module "Kubernetes" {
  source        = "./modules/kube"
  vpc_subnet_id = module.my_network.subnnn2
  mynet         = module.my_network.kube-network
  ccccc         = module.my_network.kube-v4_cidr_blocks
  nnzona        = module.my_network.zone2
}




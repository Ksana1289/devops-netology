provider "yandex" {
    cloud_id = "b1g463372d4q3svkpndk"
    folder_id = var.folder_id
    zone = var.zone
}

terraform {
  backend "local" {
      path = "terraform.tfstate"
  }
}

resource "yandex_compute_instance" "node01" {

  name       = "node01" 
  hostname   = "node01"
  description = "node01"
  folder_id    = var.folder_id
  zone           = var.zone
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores              = 2
    core_fraction = 100
    memory         = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ha60qgmfn0is8q7om"
      size          = 30
      type          = "network-hdd"
    }
  }

  network_interface {
    subnet_id        = var.subnet
    nat                  = true
  }
}
  
variable "folder_id" {
  type     = string
  default = "b1grh33fqs1lqcd6sjq2"
}

variable "zone" {
  type     = string
  default = "ru-central1-a"
}

variable "subnet" {
  type     = string
  default = "e9bitcblsbsooroqphnr"
}

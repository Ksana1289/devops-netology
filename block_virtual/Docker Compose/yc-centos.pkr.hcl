variable "YC_FOLDER_ID" {
  type = string
  default = env("YC_FOLDER_ID")
}

variable "YC_ZONE" {
  type = string
  default = env("YC_ZONE")
}

variable "YC_SUBNET_ID" {
  type = string
  default = env("YC_SUBNET_ID")
}

source "yandex" "yc-centos" {
  folder_id           = "${var.YC_FOLDER_ID}"
  source_image_family = "centos-7"
  ssh_username        = "centos"
  use_ipv4_nat        = "true"
  image_description   = "Yandex Cloud centos Toolbox image"
  image_family        = "centos-base"
  image_name          = "yc-centos"
  subnet_id           = "${var.YC_SUBNET_ID}"
  disk_type           = "network-hdd"
  zone                = "${var.YC_ZONE}"
}

build {
  sources = ["source.yandex.yc-centos"]
}

resource "yandex_vpc_network" "vpc" {
  name      = "terraform-vpc"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "public" {
  name           = "terraform-public-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
  folder_id      = var.folder_id
}
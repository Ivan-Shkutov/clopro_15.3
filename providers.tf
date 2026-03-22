terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.193.0"
    }
  }
}

provider "yandex" {
  folder_id                = var.folder_id
  cloud_id                 = var.cloud_id
  zone                     = var.zone
  service_account_key_file = "/home/vm/netology/clopro-homeworks/15.2/terraform-sa.json"
}
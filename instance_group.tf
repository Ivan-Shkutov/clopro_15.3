resource "yandex_compute_instance_group" "lamp_group" {
  name               = "terraform-lamp-group"
  folder_id          = var.folder_id
  service_account_id = "aje3opmc4apav6fmu8bs"

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_creating     = 1
    max_deleting     = 1
    max_expansion    = 1
    max_unavailable  = 0
    startup_duration = 0
  }

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 20
        type     = "network-hdd"
      }
      mode = "READ_WRITE"
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]
      ipv4       = true
      nat        = true
    }

    metadata = {
      "ssh-keys" = var.public_ssh_key
      "user-data" = <<-EOT
        #!/bin/bash
        apt update -y
        apt install apache2 -y
        systemctl enable apache2
        systemctl start apache2
        echo '<html><body><h1>Hello from LAMP VM</h1><img src="https://storage.yandexcloud.net/${yandex_storage_bucket.images.bucket}/image.jpg"></body></html>' > /var/www/html/index.html
      EOT
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  load_balancer {
    target_group_name        = "lamp-target-group"
    target_group_description = "LAMP target group"
  }
}
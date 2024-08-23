resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
resource "yandex_vpc_subnet" "develop2" {
  name           = var.vm_db_vpc_name
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_cidr
}



data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image 
}
resource "yandex_compute_instance" "platform" {
  #name        = var.vm_web_name
  name            = local.platform
  platform_id     = var.vm_web_platform_id
  resources {
    cores         = var.vms_resources["vm_web_resources"]["cores"]
    memory        = var.vms_resources["vm_web_resources"]["memory"]
    core_fraction = var.vms_resources["vm_web_resources"]["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_prmt
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat
  }

  metadata = {
    serial-port-enable = var.vms_metadata["serial-port-enable"]
    ssh-keys           = var.vms_metadata["ssh-keys"]
  }

}
###netology-develop-platform-db
resource "yandex_compute_instance" "platform2" {
  #name        = var.vm_db_name
  name           = local.platform2
  platform_id    = var.vm_db_platform_id
  zone           = var.vm_db_zone

  resources {
    cores         = var.vms_resources["vm_db_resources"]["cores"]
    memory        = var.vms_resources["vm_db_resources"]["memory"]
    core_fraction = var.vms_resources["vm_db_resources"]["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_prmt
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop2.id
    nat       = var.vm_db_nat
  }

  metadata = {
    serial-port-enable = var.vms_metadata["serial-port-enable"]
    ssh-keys           = var.vms_metadata["ssh-keys"]
  }

}

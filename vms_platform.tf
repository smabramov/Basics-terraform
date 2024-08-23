###cloud vars

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "develop2"
  description = "VPC network & subnet name"
}

variable "vm_db_cidr" {
  type        = list(string)
  default     = ["10.0.0.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_name" {
  type = string
  default = "netology-develop-platform-db"
  }

variable "vm_db_image" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "vm_db_platform_id" {
  type = string
  default = "standard-v1"
  }
/*
variable "vm_db_cores" {
  type = number
  default = 2
  }

variable "vm_db_memory" {
    type = number
    default = 2 
  }

variable "vm_db_fract" {
    type = number
    default = 20
  }
*/

variable "vm_db_prmt" {
  type = bool
  default = true
  }

variable "vm_db_nat" {
  type = bool
  default = true
  }


variable "vm_db_sp" {
  type = bool
  default = true
  }

  variable "vms_resources" {
  type = map(object({
    cores = number
    memory = number
    core_fraction = number
  }))
  default = {
    vm_web_resources = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    vm_db_resources = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "vms_metadata" {
  type = map
  default = {
    serial-port-enable = 1
    ssh-keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxDA6ZQM1u1nDL0NqZz/rgrzGd5zbrbWKV3xuFp29zL serg@ubuntu"
  }
}
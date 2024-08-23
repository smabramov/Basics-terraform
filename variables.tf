###cloud vars

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default     = "b1gttf81lmg2v759uobi"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1g8381i07tsfq06pnmc"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars
/*
variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxDA6ZQM1u1nDL0NqZz/rgrzGd5zbrbWKV3xuFp29zL serg@ubuntu"
  description = "ssh-keygen -t ed25519"
}

*/

variable "vm_web_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_web_vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vm_web_name" {
  type = string
  default = "netology-develop-platform"
  }
variable "vm_web_image" {
  type = string
  default = "ubuntu-2004-lts"
}
variable "vm_web_platform_id" {
  type = string
  default = "standard-v1"
  }

/*
variable "vm_web_cores" {
  type = number
  default = 2
  }

variable "vm_web_memory" {
    type = number
    default = 1  
  }

variable "vm_web_fract" {
    type = number
    default = 5
  }
*/

variable "vm_web_prmt" {
  type = bool
  default = true
  }

variable "vm_web_nat" {
  type = bool
  default = true
  }

variable "vm_web_sp" {
  type = bool
  default = true
  }

###local

variable "name" {
  default     = "netology"
}

variable "env" {
  default     = "develop"
}

variable "project" {
  default     = "platform"
}

variable "role" {
   default = ["platform", "platform2"]
}
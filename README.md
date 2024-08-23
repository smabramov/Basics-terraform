# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»-Абрамов С.М.

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.8.4

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.

### Решение

1. Изучил проект.

2. Создал сервисный аккаунт и ключ. 

Ключ можно создать командой:

```
yc iam key create --service-account-name serg --output key.json

```
3. Сгенерировал новый ssh-ключ командой ssh-keygen -t ed25519, записал его *.pub часть в переменную vms_ssh_root_key.

4. Инициализировал проект и запустив его обнаружил следующие опечатки:

- строка  platform_id = "standart-v4" -правильно standard
- есть только v1,v2,v3 [https://yandex.cloud/ru/docs/compute/concepts/vm-platforms]
- cores = 1 - платформа не дает установить такое количество ядер, минимум 2 и далее кратное двум.

5. Ход выполнения.

![1](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/jpeg/1.png)

![2](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/jpeg/2.png)

![3](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/jpeg/3.png)

6. Параметры preemptible = true - это прерываемая ВМ, т.е. работает не более 24 часов, после будет остановлена. Параметр core_fraction = 5 - указывает базовую производительность ядра в процентах. Указывается для экономии ресурсов.


### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

### Решение

1. Изменения в main.tf

```
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image                        #"ubuntu-2004-lts"
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name                    #"netology-develop-platform-web"
  platform_id = var.vm_web_platform_id             #"standard-v1"
  resources {
    cores         = var.vm_web_cores               #2
    memory        = var.vm_web_memory              #1
    core_fraction = var.vm_web_fract               #5

``` 
2. Добавление в variables.tf

```
variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
  }

variable "vm_web_image" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v1"
  }

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

```
3. terraform plan

![4](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/jpeg/4.png)


### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

### Решение

![5](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/jpeg/5.png)

![6](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/jpeg/6.png)

main.tf

```

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
  name        = var.vm_web_name 
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_fract
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
    serial-port-enable = var.vm_web_sp
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
###netology-develop-platform-db
resource "yandex_compute_instance" "platform2" {
  name        = var.vm_db_name 
  platform_id = var.vm_db_platform_id
  zone           = var.vm_db_zone

  resources {
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_fract
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
    serial-port-enable = var.vm_db_sp
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

```
vms_platform.tf

```

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

  ```

### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

### Решение

![7](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/jpeg/7.png)


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

### Решение

Фаил [locals.tf](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/locals.tf) и [variables.tf](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/variables.tf)

```
locals {
  platform  = "${ var.name }-${ var.env }-${ var.project }-${ var.role[0] }"
  platform2 = "${ var.name }-${ var.env }-${ var.project }-${ var.role[1] }"
}

```
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

```

```

### Задание 6



1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.

### Решение

Файл [vms_platform.tf](https://github.com/smabramov/Basics-terraform/blob/ea0dc0c13e74507be2af650213194da5032360f4/vms_platform.tf)

```
ariable "vms_resources" {
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

```

Файл [main.tf](https://github.com/smabramov/Basics-terraform/blob/main/main.tf)

```
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

```


------

terraform plan

```

data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpt9e7o3rjp2r9eobs7]
data.yandex_compute_image.ubuntu: Read complete after 2s [id=fd8dfofgv8k45mqv25nq]
yandex_vpc_subnet.develop: Refreshing state... [id=e9b87o9f1j4gq6vhl36d]
yandex_compute_instance.db: Refreshing state... [id=fhm0acsfkhn0jhrvtf87]
yandex_compute_instance.web: Refreshing state... [id=fhmoe74jg3ahhp53g8rn]

No changes. Your infrastructure matches the configuration.



```
## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

------

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.
------

------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

### Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

**Важно. Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 


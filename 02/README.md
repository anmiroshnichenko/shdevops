# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

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
```
yc iam key create --service-account-name miroshnichenko  --output ~/.authorized_key.json
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/1_2.jpg)

3. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть. 

#### Ошибки: 
- **platform_id = "standart-v4"**  - v4 платформы нет, ошибка в слове  standard 
- **cores = 1** - допустимое количество ядер: 2, 4
 
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/1_4.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/1_4_1.jpg)

5. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
```
ssh ubuntu@89.169.134.28
curl ifconfig.me
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/1_5.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/1_5_1.jpg)

6. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.
#### Ответ:
- **preemptible = true** -прерываемые виртуальные машины доступны по более низкой цене в сравнении с обычными и будут принудильно остановлены после 24ч, если забыли удалит.   
- **core_fraction=5**  - уменьшая долю вычислительного времени физических ядер, которую гарантирует vCPU экономим "Грант" выданный на обучение

В качестве решения приложите:
- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.


### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
```
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family  
}

resource "yandex_compute_instance" "platform" {
  name = var.vm_web_name  
  platform_id = var.vm_web_platform_id
  resources {    
    cores         = var.vm_web_core
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {    
    preemptible = var.vm_web_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id    
    nat       = var.vm_web_network_interface_nat
  }
```
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
```
### vm vars
variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS image for virtual machine"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Name of virtual machine"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Yandex Compute Cloud provides platform "
}

variable "vm_web_cores" {
  type        = number 
  default     = 2
  description = "CPU cores for the instance"
}

variable "vm_web_memory" {
  type        = number 
  default     = 1
  description = "Memory size in GB"
}

variable "vm_web_core_fraction" {
  type        = number 
  default     = 5
  description = "Specifies baseline performance for a core as a percent"
}

variable "vm_web_scheduling_policy_preemptible" {
  type        = bool 
  default     = true
  description = "Indicates whether the instance is preemptible. The values are true and false."
}

variable "vm_web_network_interface_nat" {
  type        = bool 
  default     = true
  description = "Provide a public address, for instance"
}
```

3. Проверьте terraform plan. Изменений быть не должно. 
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/2_3.jpg)

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.
```
# VM_2_netology-develop-platform-db
resource "yandex_compute_instance" "platform-db" {  
  name = var.vm_db_name 
  platform_id = var.vm_db_platform_id
  zone        = var.zone
  resources {    
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {    
    preemptible = var.vm_db_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_1.id
    nat       = var.vm_db_network_interface_nat
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/3_3.jpg)

### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/4_1.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/4.jpg)

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.
#### Объявил переменные в файле vms_platform.tf
```
# variables for virtual machine names  
 variable "environment" {
  type        = string
  default     = "develop"  
  description = "Environment for virtual machine names"
}

variable "project" {
  type        = string
  default     = "devops"  
  description = "Project for virtual machine"
}

variable "role_1" {
  type        = string
  default     = "web"  
  description = "Role for virtual machine"
}

variable "role_2" {
  type        = string
  default     = "db"  
  description = "Role for virtual machine"
}
```
#### В файле locals.tf создал local-блок
```
locals {
    name_web = "netology-${ var.environment }-${ var.project }-${ var.role_1 }"
    name_db = "netology-${ var.environment }-${ var.project }-${ var.role_2 }"
}

```
#### Заменил переменные внутри ресурса ВМ
```
# VM_1_netology-develop-platform-web
resource "yandex_compute_instance" "platform" {  
  name = local.name_web  

# VM_2_netology-develop-platform-db
resource "yandex_compute_instance" "platform-db" {  
  name = local.name_db 
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/5.jpg)

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
#### Объявил переменные в файле vms_platform.tf
   ```
   #single map variable for virtual machine resources
variable "vms_resources" {
  type        = map(map(number))
  description = "All resources for virtual machine"
}
```
#### В файле terraform.tfvars написал значения 
```
vms_resources = {
     web ={
       cores = 2
       memory = 1
       core_fraction = 5        
     },
     db = {
       cores = 2
       memory = 2
       core_fraction = 20        
     }
   }
```
#### Заменил переменные  для  ресурсов ВМ
```
resources {    
    cores         = var.vms_resources["db"]["cores"]
    memory        = var.vms_resources["db"]["memory"]
    core_fraction = var.vms_resources["db"]["core_fraction"]
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

#### Объявил переменные в файле variables.tf
```
variable "metadata" {
  type        =map(any)  
  description = "metadata block variables for all VMs"
}
```
#### В файле terraform.tfvars задал  значения 
```
metadata = {
     serial-port-enable = 1
     ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpEVTvLfMVp0ZydLogg5s1D8WzKQaY2n0MqDsBNX2YkoaHP1vHs0Aqg5"
   }
```
#### Заменил переменные в файле main.tf  для  resource "yandex_compute_instance" 
```
metadata = {
    serial-port-enable = var.metadata["serial-port-enable"]
    ssh-keys           = var.metadata["ssh-keys"]
  }
```

5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.

![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/6.jpg)
------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
```
> local.test_list
[
  "develop",
  "staging",
  "production",
]
```
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
```
> length(local.test_list)
3
```
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
```
> local.test_map["admin"]
"John"
```
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.
```
> "${local.test_map["admin"]} is ${[for k,v in local.test_map  : k if v == "John"][0]} for ${local.test_list[2]} server based on OS ${local.servers.production["image"]} with ${local.servers.production["cpu"]} vcpu, ${local.servers.production["ram"]} ram and ${length(local.servers.production["disks"])} virtual disks" 
"John is admin for production server based on OS ubuntu-20-04 with 10 vcpu, 40 ram and 4 virtual disks"
>  
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/7.jpg)
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
#### Переменая test
```
variable "test" {
   type        = list(map(list(string)))
}
```
#### Проверка переменной  test в консоле 
```
> var.test
tolist([
  tomap({
    "dev1" = tolist([
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ])
  }),
  tomap({
    "dev2" = tolist([
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ])
  }),
  tomap({
    "prod1" = tolist([
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ])
  }),
])
>  
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/8.jpg)

2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.
```
> var.test[0]["dev1"][0]
"ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117"  
```
------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```
####  Изменил пароль  для пользователя ubuntu 
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/9.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/9_1.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/9_2.jpg)

####  Изменил nat=false в файле terraform.tfvars, создал ресурс  в файле nat_gateway.tf,  в resource "yandex_vpc_subnet" указал таблицу маршрутизации   и применил изменения
```
vm_db_network_interface_nat = false
vm_web_network_interface_nat = false
```
```
resource "yandex_vpc_gateway" "nat_gateway" {
#   folder_id      = "<идентификатор_каталога>"
  name = "test-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  name       = "test-route-table"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
```
```
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_subnet" "develop_1" {
  name           = var.vpc_1_name
  zone           = var.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr
  route_table_id = yandex_vpc_route_table.rt.id
}
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/9_3.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/9_4.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/9_5.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/02/screenshots/9_6.jpg)


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


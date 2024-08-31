# Домашнее задание к занятию «Введение в Terraform»

### Цели задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чек-лист готовности к домашнему заданию

1. Скачайте и установите **Terraform** версии ~>1.8.4 . Приложите скриншот вывода команды ```terraform --version```.
2. Скачайте на свой ПК этот git-репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
3. Убедитесь, что в вашей ОС установлен docker.

------

```
wget https://hashicorp-releases.yandexcloud.net/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip
unzip  terraform_1.9.5_linux_amd64.zip
file terraform
chmod 766 terraform
sudo cp terraform /usr/local/bin/
sudo chown miroshnichenko_an /usr/local/bin/terraform
terraform -v
``` 
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform-01/screenshots/0.jpg)

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Репозиторий с ссылкой на зеркало для установки и настройки Terraform: [ссылка](https://github.com/netology-code/devops-materials).
2. Установка docker: [ссылка](https://docs.docker.com/engine/install/ubuntu/). 
------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)
#### Ответ: Допустимо сохранить личную, секретную информацию в фале **personal.auto.tfvars**
```
# Local .terraform directories and files
**/.terraform/*
.terraform*
!.terraformrc
# .tfstate files
*.tfstate
*.tfstate.*
# own secret vars store.
personal.auto.tfvars
```
3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
#### Ответ:  "result": "A4OLPruh2OBU0qQ1"
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/1_3.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/1_3_1.jpg)

4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
#### Ответ:  Все блоки resource должны иметь 2 labels (type, name). Имя должно начинаться с буквы или символа подчеркивания и может содержать только буквы, цифры, символы подчеркивания и тире. В строке "name  = "example_${random_password.random_string_FAKE.resulT}" убрал "_FAKE" и исправил "result"

![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/1_4.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/1_4_0.jpg)

5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.
```
resource "docker_image" "nginx-stable" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx-stable.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/1_5.jpg)

6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.
#### Ответ: Опасность заключается в нежелательном приминении изменений к инфораструктуре без предварительного изучения плана, т.к  ключ  -auto-approve пропускает интерактивное утверждение. Данный ключ может буть полезен с скриптах, CI/CD пайплайна.  
```
resource "docker_container" "nginx" {
  image = docker_image.nginx-stable.image_id
#  name  = "example_${random_password.random_string.result}"
  name  = "hello_world"
  ports {
    internal = 80
    external = 9090
  }
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/1_6.jpg)

7. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 
```
terraform destroy
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/1_7.jpg)

8. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ**, а затем **ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ** строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )
#### Ответ: docker-образ **nginx:latest**  не был удален, потому что в схеме ресурса  указан параметр **keep_locally = true** .  Если удалить этот параметр или установить значение **false**  при дестрои  образ  будет удален. Строка из докементации: ""keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.""
```
resource "docker_image" "nginx-stable" {
  name         = "nginx:latest"
  keep_locally = true
}
```
------
## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 2*

1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл ```personal.auto.tfvars``` и гитигнор или иной, безопасный способ передачи токена!
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/2_1.jpg)

2. Подключитесь к ВМ по ssh и установите стек docker.
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/2_2.jpg)

3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
```
provider "docker" {
  host     = "ssh://miroshnichenko@84.201.128.234:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}
```
4. Используя terraform и  remote docker context, скачайте и запустите на вашей ВМ контейнер ```mysql:8``` на порту ```127.0.0.1:3306```, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(```name  = "example_${random_password.random_string.result}"```  , двойные кавычки и фигурные скобки обязательны!) 

```
resource "docker_image" "mysql" {
  name = "mysql:8"
  keep_locally = true
}

resource "random_password" "mysql_root_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_container" "mysql" {
  name  = "mysql"
  image = docker_image.mysql.image_id
  restart = "always"
  env = [
     "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
     "MYSQL_PASSWORD=${random_password.mysql_password.result}",
     "MYSQL_USER=${var.mysql_user}",
     "MYSQL_DATABASE=${var.mysql_database}",
     "MYSQL_ROOT_HOST=%" 
  ]
  volumes {
    container_path = "/var/lib/mysql"
    host_path = "/tmp/db_data"
  }  
  ports {
    external = 3306
    internal = 3306
    ip = 127.0.0.1    
  }
}
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/2_4.jpg)

5. Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды ```env```. Запишите ваш финальный код в репозиторий.
```
docker exec -it mysql bash
env
mysql -uroot -p1UomClPwDHo6PdPK
docker exec -it mysql mysql -uroot -p1UomClPwDHo6PdPK
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/2_5.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/2_5_1.jpg)

### Задание 3*
1. Установите [opentofu](https://opentofu.org/)(fork terraform с лицензией Mozilla Public License, version 2.0) любой версии
2. Попробуйте выполнить тот же код с помощью ```tofu apply```, а не terraform apply.
------
#### Ответ: Доступ [ссылка](https://habr.com/ru/companies/flant/news/839442/) к registry.opentofu.org закрыт с российских IP-адресов.  VPN  не помог.  Возможно каким-то спообом выполнить это задание?  

```
#Installing tooling
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

#Set up the OpenTofu repository
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg >/dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg

#Create the OpenTofu source list.
echo \
  "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | \
  sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
sudo chmod a+r /etc/apt/sources.list.d/opentofu.list

#Installing OpenTofu
sudo apt-get update
sudo apt-get install -y tofu
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/3_1.jpg)
![image](https://github.com/anmiroshnichenko/shdevops/blob/terraform/01/screenshots/3_2.jpg)

### Правила приёма работы

Домашняя работа оформляется в отдельном GitHub-репозитории в файле README.md.   
Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 

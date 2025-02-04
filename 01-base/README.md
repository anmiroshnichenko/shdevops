
# Домашнее задание к занятию 1 «Введение в Ansible»

## Подготовка к выполнению

1. Установите Ansible версии 2.10 или выше.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.
```
ansible -m ping localhost
ansible-playbook -i inventory/test.yml site.yml 
```

![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/1_1.jpg)

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.
![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/1_2.jpg)
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```
ansible-inventory -i inventory/prod.yml --graph
ansible-inventory -i inventory/prod.yml --list
ansible-inventory -i inventory/prod.yml --host ubuntu
ansible-playbook  -i inventory/prod.yml  site.yml
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/1_4.jpg)

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/1_6.jpg)

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
```
ansible-vault encrypt group_vars/deb/examp.yml group_vars/el/examp.yml
ansible-vault decrypt group_vars/deb/examp.yml group_vars/el/examp.yml # расшифровать
ansible-vault view  group_vars/deb/examp.yml # посмотреть без расшифровки  
ansible-vault edit  group_vars/deb/examp.yml # отредактировать без расшифровки 
ansible-vault encrypt_string  # зашифровать значение 

```
![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/1_7.jpg)

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
```
ansible-playbook  -i inventory/prod.yml  site.yml --ask-vault-pass
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/1_8.jpg)

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
```
ansible-doc --list  -t connection
ansible-doc --list  -t connection community.docker
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/1_9.jpg)

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/1_11.jpg)

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
13. Предоставьте скриншоты результатов запуска команд.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
```
ansible-vault decrypt group_vars/deb/examp.yml group_vars/el/examp.yml
ansible-vault encrypt_string
```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/2_2.jpg)

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
```
ansible-playbook  -i inventory/prod.yml  site.yml --ask-vault-pass
```
![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/2_3.jpg)

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).

![image](https://github.com/anmiroshnichenko/shdevops/blob/ansible/01-base/screenshots/2_4.jpg)

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```
#!/bin/bash
docker build -t ubuntu .
docker run -id  --name pycontribs   pycontribs/fedora
docker run -id  --name ubuntu ubuntu
docker run  -id  --name centos7 centos:centos7
ansible-playbook  -i inventory/prod.yml  site.yml --ask-vault-pass
docker stop pycontribs ubuntu centos7 && docker rm  pycontribs ubuntu centos7 
```
6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.



## Ansible Playbook для запуска Clickhouse + Vector + lighthouse 

## Первоначальная настройка 
Заполните инвентарный файл **[inventory/prod.yml]**
```YML      
ansible_host: <ip>
ansible_ssh_user: <user>
ansible_ssh_private_key_file: <path to file>
```

Укажите необходимую версию clickhouse **[group_vars/clickhouse/vars.yml]**, например "22.3.3.44"
```YML
clickhouse_version: 22.3.3.44
```
Укажите необходимую версию vector **[group_vars/clickhouse/vars.yml]**, например  "0.22.3""
```YML
vector_version: "0.22.3"
```
В файле **[group_vars/clickhouse/vars.yml]** укажите IP на котором будет запущен clickhouse, если сервис будет запущен на одной инстансе, то оставьте настройку как есть
```YML
all_clickhouse_url: "http://locakhost:8123" 
```

## Запуск Playbook
#
    ansible-playbook site.yml -i inventory/prod.yml
**Note**: После выполнения playbook Vector сразу начнет писать лог в БД


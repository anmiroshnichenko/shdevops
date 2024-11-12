Vector
=========

Install Vector on Centos8

Requirements
------------

Do not use this role for CentOS 7, because libc-2.18.so is not supported in CentOS 7

Role Variables
--------------

* vector_version: "0.22.3"
* vector_config_file: "vector.yaml.j2"


В файле **[vector/vars.yml]** укажите IP на котором будет запущен clickhouse, если сервис будет запущен на одной инстансе, то оставьте настройку как есть
```
YMLendpoint: http://localhost:8123
```
Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: vector }

License
-------

MIT
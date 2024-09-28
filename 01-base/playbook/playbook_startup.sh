#!/bin/bash
docker build -t ubuntu .
docker run -id  --name pycontribs   pycontribs/fedora
docker run -id  --name ubuntu ubuntu
docker run  -id  --name centos7 centos:centos7
ansible-playbook  -i inventory/prod.yml  site.yml --ask-vault-pass
docker stop pycontribs ubuntu centos7 && docker rm  pycontribs ubuntu centos7 



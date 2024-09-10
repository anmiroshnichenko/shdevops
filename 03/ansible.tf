# resource "local_file" "hosts_for" {
#   content =  <<-EOT
#   %{if length(yandex_compute_instance.web) > 0}
#   [webservers]
#   %{for i in yandex_compute_instance.web }
#   %{if length(i["network_interface"][0]["nat_ip_address"]) > 0}
#   ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}
#   %{else}
#   ${i["name"]}   ansible_host=${i["network_interface"][0]["ip_address"]}
#   %{endif}
#   %{endfor}
#   %{endif}
#   EOT  
# filename = "${abspath(path.module)}/for.ini"
# }

# locals{

# instances_yaml= concat(yandex_compute_instance.example,yandex_compute_instance.bastion)

# }



resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",

  { webservers = yandex_compute_instance.web
   databases = yandex_compute_instance.db
   storage = yandex_compute_instance.storage   
   } )

  filename = "${abspath(path.module)}/hosts.ini"
}

variable "web_provision" {
  type    = bool
  default = true
  description="ansible provision switch variable"
}



resource "null_resource" "web_hosts_provision" {
  count = var.web_provision == true ? 1 : 0 
  #Ждем создания инстанса
  depends_on = [yandex_compute_instance.web]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command = "eval $(ssh-agent) && cat ~/.ssh/id_rsa | ssh-add -"
    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок

  }
#Костыль!!! Даем ВМ 60 сек на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
  # # В случае использования cloud-init может потребоваться еще больше времени
  provisioner "local-exec" {
    command = "sleep 60"
  }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    # without secrets
    # command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key ~/.ssh/id_rsa -i ${abspath(path.module)}/hosts.cfg  ${abspath(path.module)}/test.yml"
    
    #secrets pass
    #> nonsensitive(jsonencode( {for k,v in random_password.each: k=>v.result}))
    /*
      "{\"netology-develop-platform-web-0\":\"u(qzeC#nKjp*wTOY\",\"netology-develop-platform-web-1\":\"=pA12\\u0026C2eCl[Oe$9\"}"
    */
    command  = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/hosts.ini ${abspath(path.module)}/test.yml --extra-vars '{\"secrets\": ${jsonencode( {for k,v in random_password.each: k=>v.result})} }'"

    # for complex cases instead  --extra-vars "key=value", use --extra-vars "@some_file.json"

    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
  triggers = {
    # always_run        = "${timestamp()}"                         #всегда т.к. дата и время постоянно изменяются
    # always_run_uuid = "${uuid()}" 
    playbook_src_hash = file("${abspath(path.module)}/test.yml") # при изменении содержимого playbook файла
    # ssh_public_key    = var.public_key                           # при изменении переменной with ssh
    template_rendered = "${local_file.hosts_templatefile.content}" #при изменении inventory-template
    password_change = jsonencode( {for k,v in random_password.each: k=>v.result})

  }

}

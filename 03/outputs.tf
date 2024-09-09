output "web_servers" {
    value = [ for i in yandex_compute_instance.web:{ 
        "name"  = i.name
        "id"    = i.id
        "fqdn"  = i.fqdn
        } 
    ]          
} 
    
output "db_servers" {
    value = [ for i in yandex_compute_instance.db:{ 
        "name"  = i.name
        "id"    = i.id
        "fqdn"  = i.fqdn
        } 
    ]          
} 








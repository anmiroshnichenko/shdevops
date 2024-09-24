# output "servers" {
#     value = [ for i in yandex_compute_instance.web :{ 
#         "name"  = i.name
#         "id"    = i.id,
#         "fqdn"  = i.fqdn
#         } 
#     ]         
# } 
    
# output "servers" {
#     value = [ for i in yandex_compute_instance.db:{ 
#         "name"  = i.name
#         "id"    = i.id
#         "fqdn"  = i.fqdn
#         } 
#     ]          
# } 

# output "servers" {
#     value =[for instace in [yandex_compute_instance.db, yandex_compute_instance.web] : [for k in instace :{
#         "name" = k.name, 
#         "id"    = k.id, 
#         "fqdn"  = k.fqdn} 
#         ]
#     ]  
# } 

# output "servers" {
#     value = [for instance in [yandex_compute_instance.db, yandex_compute_instance.web] : [for k in instance :{
#         "name" = k.name, 
#         "id"    = k.id, 
#         "fqdn"  = k.fqdn} 
#         ]
#     ]    
# } 

output "servers" {
    value = toset([for instance in [yandex_compute_instance.db, yandex_compute_instance.web] : [for k in instance : {"name" = k.name}

    # {
                # "name" = k.name, 
        # "id"    = k.id, 
        # "fqdn"  = k.fqdn } 
    ]
    ]  )  
} 



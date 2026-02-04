module "my_infrastructure" {

  source = "./mode/"

  vpc_range        = "10.0.0.0/16" 
  Subnet_count     = 2       
  instance_type    = "t2.micro"   
  if_Public_ip = true 
  
}

output "instance_ip" {
  value = module.my_infrastructure.public_instance_ip
}

output "final_alb_url" {
  value = module.my_infrastructure.alb_dns_name
}

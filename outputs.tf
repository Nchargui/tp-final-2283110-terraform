output "tp_final_instance_2283110_ip" {
  description = "Adresse IP publique de l'instance tp_final_instance_2283110"
  value       = try(aws_instance.tp_final_instance_2283110.public_ip, "")
}
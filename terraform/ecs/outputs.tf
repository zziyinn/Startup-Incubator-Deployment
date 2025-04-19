# outputs you can kist required endpoints, ip or instanceid's

output "alb_hostname" {
  value = aws_lb.main.dns_name
}

output "frontend_url" {
  value = "http://${aws_lb.main.dns_name}:${var.frontend_port}"
}

output "backend_url" {
  value = "http://${aws_lb.main.dns_name}:${var.backend_port}"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_names" {
  value = [
    aws_ecs_service.frontend.name,
    aws_ecs_service.backend.name
  ]
}

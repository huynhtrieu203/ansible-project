output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.compute.dns_name
}

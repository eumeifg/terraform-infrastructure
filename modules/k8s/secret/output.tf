output "name" {
  description = "The name of the secret."
  value       = kubernetes_secret.this.metadata[0].name
}

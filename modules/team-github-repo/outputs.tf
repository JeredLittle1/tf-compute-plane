output "http_clone_url" {
  description = "URL for the github repo"
  value       = resource.github_repository.repo.http_clone_url
}
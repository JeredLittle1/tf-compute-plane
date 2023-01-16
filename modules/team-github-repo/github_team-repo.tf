variable "repo_name" { type = string }
variable "directories_to_create" { type = list(any) }
variable "branch_name" { type = string }
variable "create_webhook" {
  type    = bool
  default = false
}
variable "webhook_config" {
  type    = map(any)
  default = {}
}

resource "github_repository" "repo" {
  name        = var.repo_name
  description = "Managed with Terraform"
  private     = false
}


resource "github_repository_file" "foo" {
  for_each            = { for directory in var.directories_to_create : directory => directory }
  repository          = github_repository.repo.name
  branch              = "master"
  file                = "${each.key}/.gitkeep"
  content             = ""
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@do-not-reply.com"
  overwrite_on_create = true
}


resource "github_repository_webhook" "foo" {
  count      = var.create_webhook ? 1 : 0
  repository = github_repository.repo.name

  name = "web"

  configuration {
    url          = "https://google.com/"
    content_type = "form"
    insecure_ssl = false
  }

  active = false

  events = ["issues"]
}

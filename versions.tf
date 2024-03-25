terraform {
  cloud {
    organization = "fiap-lanches-organization"

    workspaces {
      name = "hackaton-fiap-workspace"
    }
  }
}
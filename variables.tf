variable "spiritops_app_name" {
  description = "The name of the Container App."
  type        = string
  default     = "spiritops-app"
}

variable "spiritops_registry_name" {
  description = "The name of the Container Registry."
  type        = string
  default     = "spiritops"
}

variable "workspace_name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
  default     = "workspaceaicloudbuilder9db5"
}

variable "spiritops_container_app_env_name" {
  description = "The name of the Managed Environment."
  type        = string
  default     = "spiritops-container-app-env"
}

variable "spiritops_certificate_name" {
  description = "The name of the Managed Certificate."
  type        = string
  default     = "www.spiritops.in-spiritop-260227063125"
}

variable "spiritops_dnszone_name" {
  description = "The name of the DNS Zone."
  type        = string
  default     = "spiritops.in"
}

variable "location" {
  description = "The Azure location for resources."
  type        = string
  default     = "southindia"
}

variable "spiritops_registry_sku" {
  description = "The SKU for the Container Registry."
  type        = string
  default     = "Basic"
}

variable "workspace_sku" {
  description = "The SKU for the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"
}
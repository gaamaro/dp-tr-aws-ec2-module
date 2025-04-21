variable "instance_name" {
  description = "Nome da instância EC2"
  type        = string
}

variable "ssh_key_name" {
  description = "Nome da chave SSH existente na AWS (que será carregada via Vault)"
  type        = string
}

variable "tags" {
  description = "Tags padrão para rastreabilidade e FinOps"
  type        = map(string)
  default     = {}
}
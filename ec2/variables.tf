variable "instance_name" {
  description = "Nome da instância EC2 (usado em tags e nomes de recursos)."
  type        = string
}

variable "ssh_key_name" {
  description = "Nome da chave SSH existente na AWS (carregada via Vault, por exemplo)."
  type        = string
}

variable "tags" {
  description = "Tags adicionais para rastreabilidade, FinOps ou organização (ex: CostCenter, Owner, etc)."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = <<EOT
ID da VPC existente. 
Se não for fornecido, o módulo usará automaticamente a VPC default da conta e região.
EOT
  type    = string
  default = null
}

variable "subnet_id" {
  description = <<EOT
ID da Subnet existente. 
Se não for fornecido, o módulo buscará uma das subnets associadas à VPC default e a usará.
EOT
  type    = string
  default = null
}

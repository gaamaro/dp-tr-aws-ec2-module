# 🧱 Módulo Terraform: EC2 com rede pública e boas práticas

Este módulo provisiona uma instância EC2 com configuração de rede pública, regras de segurança, disco, acesso SSH e estrutura modularizada. Ele **não define provider nem backend**, permitindo integração com ferramentas externas como Vault, GitHub Actions, AWX, etc.

---

## 🚀 Funcionalidades

- Criação de VPC, Subnet pública e Internet Gateway
- Tabela de rotas com acesso à internet
- Instância EC2 com:
  - AMI Ubuntu fixa (`ami-084568db4383264d4`)
  - Tipo `t2.medium`
  - Disco de 15 GiB
  - SG com liberação para portas: `22`, `80`, `443`, `8080`, `8443`
- Key Pair definida externamente (pode ser injetada via Vault)
- Tags **definidas e manipuladas apenas pelo chamador**

---

## 📁 Estrutura do módulo

```bash
ec2/
├── main.tf
├── variables.tf
├── outputs.tf
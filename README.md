# Criando 4 Maquinas Virtuais na OCI com Terraform

Diz a lenda que a Oracle Cloud disponibiliza 1 Instância ARM com 4CPUs e 24GB de Ram no modo free-tier para sempre. **Vamos ver né!**
<br>
Dividimos a instância em 4 com 1 vcpu e 4gb mem cada.

https://docs.oracle.com/pt-br/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm


- Primeiramente tenha uma conta na OCI (Oracle Cloud).
- Tenha ou Instale o Terraform no seu Computador.
- Tenha ou Instale o OCI Cli no seu Computador.


## Detalhes do Projeto

Este projeto cria os seguintes recursos:

- Compartimento
- VCN
- Internet Gateway
- Rota padrão
- Security List
- Subnet
- 4 Instancias (VM)

- Mostra o IP Publico ao final

## Faça o clone para sua Estação

```
git clone https://github.com/julianorib/terraform-oracle-vm.git
```

## Ajustes no Projeto

Verificar as variáveis em *variables.tf* e defini-las em um novo arquivo *terraform.tfvars* se desejar

```
Nome
Tipo de instância
Quantidade Vms (Instancias)
SSH-Key
```

## Autenticação no Provedor

Para autenticar no Provedor, digite o comando abaixo:
```
oci session authenticate
```


## Execute para Criação

```
terraform init
```

```
terraform apply
```

## Execute para Remoção

```
terraform destroy
```


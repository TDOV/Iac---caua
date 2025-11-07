# Instância de Computação - Deploy com Docker

Este documento descreve como provisionar e configurar uma máquina virtual no Azure para executar aplicações em contêineres Docker.

## Pré-requisitos

Antes de começar, certifique-se de que:

1. ✅ Você completou a **configuração inicial** descrita em `CONFIGURACAO_INICIAL.md`
2. ✅ Está conectado à VM de administração via SSH
3. ✅ As credenciais do Azure estão ativas (variáveis ARM_* configuradas)

## Visão Geral do Processo

O deploy é dividido em duas etapas principais:

1. **Terraform**: Provisiona a infraestrutura (VM, rede, segurança) no Azure
2. **Ansible**: Configura a VM, instala Docker e faz deploy da aplicação

## Etapa 1: Provisionamento da Infraestrutura (Terraform)

### 1.1 Navegue até o diretório do Terraform

```bash
cd ~/iac/instancia_computacao/terraform
```

### 1.2 Configure as variáveis do projeto

Crie o arquivo `terraform.tfvars` com suas configurações específicas:

```bash
cat > terraform.tfvars << EOF
resource_group_name = "rg-a<MATRICULA>"  # Substitua pela sua matrícula
location            = "northcentralus"
ssh_public_key_path = "~/.ssh/azure_rsa.pub"
EOF
```

**Importante:** Substitua `rg-a<MATRICULA>` pelo nome do seu grupo de recursos (ex: `rg-a123456`).

### 1.3 Inicialize o Terraform

```bash
terraform init
```

Este comando:
- Baixa os providers necessários
- Configura o backend local
- Prepara o ambiente para execução

### 1.4 Planeje a infraestrutura

```bash
terraform plan
```

Este comando mostra o que será criado sem fazer alterações reais. Revise a saída para confirmar que está correto.

### 1.5 Crie a infraestrutura

```bash
terraform apply
```

Digite `yes` quando solicitado. O processo pode levar alguns minutos.

### 1.6 Anote o IP público

Ao final, o Terraform exibirá o IP público da sua VM:

```
Outputs:
public_ip_address = "52.123.45.67"
```

**Copie este IP** - você precisará dele na próxima etapa.

## Etapa 2: Configuração e Deploy (Ansible)

### 2.1 Navegue até o diretório do Ansible

```bash
cd ~/iac/instancia_computacao/ansible
```

### 2.2 Configure o inventário

Edite o arquivo `inventory/hosts` e substitua o IP placeholder pelo IP real da sua VM:


### 2.3 Teste a conectividade

```bash
ansible all -i inventory/hosts -m ping
```

Se bem-sucedido, você verá uma resposta "pong".

### 2.4 Execute o playbook de configuração

```bash
ansible-playbook -i inventory/hosts playbook.yml
```

Este processo irá:
- Instalar Docker na VM
- Configurar o ambiente
- Clonar repositórios da aplicação
- Iniciar contêineres Docker

## Verificação do Deploy

### Acesse sua VM diretamente

```bash
ssh azureuser@52.123.45.67 -i ~/.ssh/azure_rsa
```

### Verifique os contêineres em execução

```bash
docker ps
```

### Teste a aplicação

A aplicação estará disponível nas seguintes portas:
- **Frontend**: http://52.123.45.67:3000
- **Backend API**: http://52.123.45.67:8000

## Comandos Úteis

### Verificar logs dos contêineres

```bash
# Logs do frontend
docker logs frontend-container

# Logs do backend
docker logs backend-container
```

### Reiniciar a aplicação

```bash
# Reiniciar todos os contêineres
docker-compose restart

# Ou reiniciar individualmente
docker restart frontend-container
docker restart backend-container
```

### Parar a aplicação

```bash
docker-compose down
```

## Limpeza dos Recursos

### Destruir a infraestrutura

Quando terminar de usar os recursos, destrua-os para evitar custos:

```bash
cd ~/iac/instancia_computacao/terraform
terraform destroy
```

Digite `yes` quando solicitado.

## Solução de Problemas

### Erro de permissão no Azure

- **Causa**: Tentativa de criar recursos fora do seu grupo de recursos
- **Solução**: Verifique se o `resource_group_name` no `terraform.tfvars` está correto

### Erro de conectividade SSH

- **Causa**: Firewall ou configuração de rede
- **Solução**: Verifique se a regra de segurança SSH está configurada corretamente

### Contêineres não iniciam

- **Causa**: Problemas de configuração ou recursos insuficientes
- **Solução**: Verifique os logs com `docker logs <container_name>`

### Aplicação não responde

- **Causa**: Portas não expostas ou firewall
- **Solução**: Verifique se as portas 3000 e 8000 estão abertas no NSG

## Próximos Passos

Após completar este deploy:

1. Explore a aplicação em execução
2. Experimente modificar configurações
3. Pratique comandos Docker
4. Teste cenários de falha e recuperação

Para outros tipos de implementação, consulte os arquivos de instruções específicos que serão fornecidos.
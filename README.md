# Projeto de Infraestrutura como Código (IaC)

Este projeto contém os scripts e configurações para provisionar e gerenciar infraestrutura no Azure usando Terraform e Ansible.

## Estrutura do Projeto

```
aluno/
├── CONFIGURACAO_INICIAL.md     # Configuração inicial do ambiente
├── README.md                   # Este arquivo
├── instancia_computacao.md     # Instruções para deploy com Docker
├── instancia_computacao/       # Projeto específico para VM de computação
│   ├── terraform/             # Infraestrutura como código
│   └── ansible/               # Configuração e deploy
├── azure_rsa                  # Chave SSH privada
├── azure_rsa.pub              # Chave SSH pública
└── .gitignore                 # Arquivos ignorados pelo Git
```

## Como Começar

### 1. Configuração Inicial
Primeiro, siga as instruções em **`CONFIGURACAO_INICIAL.md`** para:
- Conectar-se à VM de administração
- Configurar credenciais do Azure
- Preparar o ambiente de trabalho

### 2. Projetos Disponíveis

#### Instância de Computação
Para provisionar uma VM com Docker e fazer deploy de aplicações:
- **Arquivo de instruções**: `instancia_computacao.md`
- **Diretório**: `instancia_computacao/`
- **Tecnologias**: Terraform + Ansible + Docker

#### Futuros Projetos
Novos projetos serão adicionados conforme necessário, cada um com:
- Instruções específicas em arquivo `.md` dedicado
- Diretório próprio com código organizado
- Documentação detalhada do processo

## Fluxo de Trabalho Geral

### Para Qualquer Projeto

1. **Configuração Inicial**: Siga `CONFIGURACAO_INICIAL.md`
2. **Escolha o Projeto**: Consulte o arquivo `.md` específico
3. **Execute o Terraform**: Provisione a infraestrutura
4. **Execute o Ansible**: Configure e faça deploy
5. **Teste e Valide**: Verifique se tudo está funcionando
6. **Limpeza**: Destrua recursos quando terminar

### Comandos Básicos

```bash
# Terraform
terraform init
terraform plan
terraform apply
terraform destroy

# Ansible
ansible-playbook -i inventory/hosts playbook.yml
```

## Suporte e Documentação

- **Configuração inicial**: `CONFIGURACAO_INICIAL.md`
- **Instância de computação**: `instancia_computacao.md`
- **Dúvidas**: Consulte o professor ou monitor

## Importante

- Sempre destrua os recursos após o uso para evitar custos
- Mantenha suas credenciais seguras
- Trabalhe apenas dentro do seu grupo de recursos designado
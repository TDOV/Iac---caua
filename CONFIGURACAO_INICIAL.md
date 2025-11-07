# Configuração Inicial do Ambiente

Este documento descreve o processo **passo a passo** para configurar seu ambiente de trabalho com Infraestrutura como Código (IaC).

## 📋 **O que você precisa do professor:**

1. **Endereço IP da VM de administração**
2. **Arquivo da chave SSH privada** (ex: `azure_rsa`)
3. **Sua matrícula** para identificação

## 🚀 **Passo 1: Conectar-se à VM de Administração**

Use o comando SSH para se conectar:

```bash
ssh a<MATRICULA>@<IP_DA_VM> -i <CAMINHO_CHAVE_RSA>
```

**Substitua os valores conforme a tabela:**

| Placeholder | Descrição | Exemplo |
|-------------|-----------|---------|
| `<IP_DA_VM>` | IP fornecido pelo professor | `192.168.1.100` |
| `<MATRICULA>` | Sua matrícula de aluno | `123456` |
| `<CAMINHO_CHAVE_RSA>` | Caminho para sua chave SSH | `/home/user/.ssh/azure_rsa` |


## ⚙️ **Passo 2: Configurar Credenciais do Azure**

Dentro da VM, você encontrará o arquivo `azure_credentials.txt` em seu diretório home. Este arquivo contém suas credenciais para o Azure.

### 2.1 Ativar Credenciais (Método Manual)

Execute este comando **toda vez** que se conectar à VM:

```bash
export $(jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' ~/azure_credentials.txt | sed 's/appId/ARM_CLIENT_ID/' | sed 's/password/ARM_CLIENT_SECRET/' | sed 's/tenant/ARM_TENANT_ID/')
export ARM_SUBSCRIPTION_ID=$(jq -r '.subscription' ~/azure_credentials.txt)
```

### 2.2 Automatizar Credenciais (Recomendado)

Para não precisar executar o comando acima toda vez:

```bash
echo 'export $(jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ~/azure_credentials.txt | sed "s/appId/ARM_CLIENT_ID/" | sed "s/password/ARM_CLIENT_SECRET/" | sed "s/tenant/ARM_TENANT_ID/")' >> ~/.bashrc
echo 'export ARM_SUBSCRIPTION_ID=$(jq -r ".subscription" ~/azure_credentials.txt)' >> ~/.bashrc
```

### 2.3 Verificar Configuração

```bash
env | grep ARM
```

**Deve mostrar 4 variáveis:**
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET` 
- `ARM_TENANT_ID`
- `ARM_SUBSCRIPTION_ID`

## 🔑 **Passo 3: Criar Chave SSH para os Projetos**

Agora você precisa criar um par de chaves SSH que será usado pelos scripts Terraform e Ansible:

```bash
# Criar diretório .ssh se não existir
mkdir -p ~/.ssh

# Gerar par de chaves SSH (pressione Enter para todas as perguntas)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/projeto_rsa -N ""

# Definir permissões corretas
chmod 600 ~/.ssh/projeto_rsa
chmod 644 ~/.ssh/projeto_rsa.pub

# Verificar se as chaves foram criadas
ls -la ~/.ssh/projeto_rsa*
```

**📝 Importante:**
- `projeto_rsa` = chave privada para conectar às VMs que você criar
- `projeto_rsa.pub` = chave pública instalada nas VMs pelo Terraform
- Esta chave é **diferente** da que você usa para conectar na VM de administração

## 📁 **Estrutura do Projeto**

```
aluno/
├── CONFIGURACAO_INICIAL.md     # Este arquivo (configuração inicial)
├── README.md                   # Visão geral do projeto
├── instancia_computacao.md     # Instruções para criar VM
├── instancia_computacao/       # Projeto específico
│   ├── terraform/             # Infraestrutura como código
│   └── ansible/               # Configuração e deploy
├── azure_rsa                  # Chave para conectar na VM de admin
├── azure_rsa.pub              # Chave pública para VM de admin
└── .gitignore                 # Arquivos ignorados pelo Git
```

**📍 Localização das Chaves:**
- `azure_rsa` / `azure_rsa.pub` → No diretório da máquina local (para conectar na VM de admin)
- `projeto_rsa` / `projeto_rsa.pub` → Em `~/.ssh/` dentro da VM (para os scripts)

## 🎯 **Próximos Passos**

Após completar a configuração inicial:

1. **Para criar uma VM de computação**: Consulte o arquivo `instancia_computacao.md`
2. **Para outros projetos**: Novos arquivos de instruções serão criados conforme necessário

## ⚠️ **Limitações de Segurança**

- Você só pode criar recursos dentro do seu Grupo de Recursos designado
- Tentativas de criar recursos fora do seu sandbox resultarão em erro de permissão
- Isso é esperado e faz parte da segurança do ambiente de aula

---

## 📞 **Precisa de Ajuda?**

Se encontrar problemas durante a configuração, consulte seu professor ou os arquivos de documentação específicos de cada projeto.
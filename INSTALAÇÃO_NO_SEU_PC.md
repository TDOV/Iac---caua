# 💻 Instalação no Seu PC - Ambiente Completo para IaC

Este guia te ajudará a configurar **seu próprio computador** para trabalhar com **Infraestrutura como Código (IaC)** usando **Terraform**, **Ansible** e **Azure**. 

Com este ambiente configurado, você poderá executar todos os projetos diretamente do seu PC, sem depender da VM de administração do professor.

## ⚠️ **IMPORTANTE: Limitação do Ansible no Windows**

**O Ansible NÃO roda nativamente no Windows!** Por isso, recomendamos fortemente que você:

### 🐧 **Recomendação: Use uma VM Linux com Interface Gráfica**

**A melhor opção é executar todo o processo (Terraform + Ansible) em uma máquina virtual Linux:**

- **💡 Sugestão**: **Ubuntu Desktop 22.04 LTS** (interface gráfica amigável)
- **🔧 Hypervisor**: VirtualBox (gratuito) ou VMware
- **💾 Recursos mínimos**: 4GB RAM, 25GB disco, 2 CPUs
- **🌐 Rede**: Configurar como "Bridge" ou "NAT" para acesso à internet

**Vantagens da VM Linux:**
- ✅ Ansible funciona perfeitamente
- ✅ Terraform roda nativamente
- ✅ Ambiente idêntico ao usado em produção
- ✅ Interface gráfica para facilitar o aprendizado
- ✅ Não interfere com seu sistema Windows

---

## 📋 **Pré-requisitos Gerais**

Antes de começar, certifique-se de que você tem:
- ✅ Conexão com a internet
- ✅ Permissões de administrador no seu computador
- ✅ Pelo menos 6GB de espaço livre em disco (para VM + ferramentas)
- ✅ Uma conta no Microsoft Azure (pode ser gratuita)
- ✅ **VM Ubuntu Desktop** configurada (se estiver no Windows)

---

## 🔧 **1. Instalação do Terraform**

O Terraform é a ferramenta que usaremos para criar e gerenciar a infraestrutura no Azure.

### Windows

**⚠️ ATENÇÃO**: Como mencionado no início, recomendamos usar uma **VM Ubuntu** para melhor experiência.

Se ainda assim quiser instalar no Windows, use uma dessas opções:

#### Opção 1: Chocolatey (Recomendado)
```powershell
# Instalar Chocolatey (se não tiver)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Instalar Terraform
choco install terraform
```

#### Opção 2: Download Manual
1. Acesse: https://www.terraform.io/downloads
2. Baixe o arquivo ZIP para Windows
3. Extraia para `C:\terraform\`
4. Adicione `C:\terraform\` ao PATH do sistema

### macOS

#### Opção 1: Homebrew (Recomendado)
```bash
# Instalar Homebrew (se não tiver)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

#### Opção 2: Download Manual
1. Acesse: https://www.terraform.io/downloads
2. Baixe o arquivo ZIP para macOS
3. Extraia e mova para `/usr/local/bin/`

### Linux (Ubuntu/Debian)

```bash
# Adicionar repositório HashiCorp
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Instalar Terraform
sudo apt update && sudo apt install terraform
```

### Verificação da Instalação
```bash
terraform --version
```

---

## 🤖 **2. Instalação do Ansible**

O Ansible será usado para configurar as VMs após a criação pelo Terraform.

**⚠️ IMPORTANTE**: O Ansible **NÃO funciona nativamente no Windows**. Por isso, **recomendamos fortemente usar uma VM Ubuntu Desktop** conforme sugerido no início deste guia.

### Ubuntu/Linux (Recomendado)

```bash
# Adicionar repositório oficial
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

### macOS

```bash
# Usando Homebrew
brew install ansible

# Ou usando pip
pip3 install ansible
```

### Windows (Alternativas - NÃO Recomendadas)

**🚨 AVISO**: Estas opções são complexas e podem causar problemas. **Use VM Ubuntu!**

#### Opção 1: WSL2 (Complexo)
```powershell
# Instalar WSL2
wsl --install -d Ubuntu

# Após reiniciar, abrir Ubuntu e executar:
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

#### Opção 2: Docker (Limitado)
```powershell
# Usar Ansible via Docker (funcionalidade limitada)
docker run --rm -it -v ${PWD}:/work -w /work quay.io/ansible/ansible:latest ansible-playbook playbook.yml
```

### Verificação da Instalação
```bash
ansible --version
```

---

## ☁️ **3. Instalação do Azure CLI**

O Azure CLI é necessário para autenticar e gerenciar recursos no Azure.

### Windows

#### Opção 1: MSI Installer (Recomendado)
1. Baixe o instalador: https://aka.ms/installazurecliwindows
2. Execute o arquivo `.msi` baixado
3. Siga o assistente de instalação

#### Opção 2: PowerShell
```powershell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
```

### macOS

```bash
# Usando Homebrew
brew update && brew install azure-cli
```

### Linux (Ubuntu/Debian)

```bash
# Método oficial
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Verificação da Instalação
```bash
az --version
```

---

## 🔐 **4. Autenticação no Azure**

Agora você precisa fazer login na sua conta Azure. **Não é necessário criar permissionamentos específicos de Resource Group** - você pode usar o login direto da sua conta.

### Passo 1: Login Interativo
```bash
az login
```
- Isso abrirá seu navegador para fazer login
- Entre com suas credenciais do Azure
- Após o login, você verá suas assinaturas disponíveis

### Passo 2: Verificar Autenticação
```bash
# Verificar conta atual
az account show

# Testar criação de resource group (será removido automaticamente)
az group create --name teste-rg --location "North Central US"
az group delete --name teste-rg --yes --no-wait
```

**💡 Dica sobre Regiões**: Recomendamos usar as regiões **North Central US** ou **South Central US**, pois possuem mais recursos disponíveis atualmente.

**💡 Dica**: Com sua conta pessoal do Azure, você já tem as permissões necessárias para criar recursos. Não precisa configurar Service Principals ou permissões especiais!

---

## 🔑 **5. Configuração de Chaves SSH**

As chaves SSH são necessárias para acessar as VMs criadas.

### Gerar Par de Chaves SSH

```bash
# Criar diretório (se não existir)
mkdir -p ~/.ssh

# Gerar chave SSH
ssh-keygen -t rsa -b 4096 -f ~/.ssh/projeto_rsa -N ""

# Verificar chaves criadas
ls -la ~/.ssh/projeto_rsa*
```

### Configurar Permissões (Linux/macOS)
```bash
chmod 600 ~/.ssh/projeto_rsa
chmod 644 ~/.ssh/projeto_rsa.pub
```

### No Windows (PowerShell)
```powershell
# Criar diretório
New-Item -ItemType Directory -Force -Path $env:USERPROFILE\.ssh

# Gerar chave SSH
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\projeto_rsa -N '""'
```

---

## ✅ **6. Verificação e Testes do Ambiente**

Vamos testar se tudo está funcionando corretamente.

### Teste 1: Verificar Versões
```bash
echo "=== Verificando Versões ==="
terraform --version
ansible --version
az --version
ssh -V
```

**✅ Resultado Esperado:**
- `terraform --version`: Deve mostrar "Terraform v1.x.x" (versão atual)
- `ansible --version`: Deve mostrar "ansible [core 2.x.x]" (versão atual)
- `az --version`: Deve mostrar "azure-cli 2.x.x" (versão atual)
- `ssh -V`: Deve mostrar "OpenSSH_x.x" (versão instalada)

### Teste 2: Teste do Azure CLI
```bash
echo "=== Testando Azure CLI ==="
az account show --output table
az group list --output table
```

**✅ Resultado Esperado:**
- Deve mostrar informações da sua conta Azure (nome, ID da assinatura, tenant)
- Deve listar os resource groups existentes na sua assinatura

### Teste 3: Teste do Terraform
```bash
echo "=== Testando Terraform ==="
mkdir ~/teste-terraform
cd ~/teste-terraform

# Criar arquivo de teste
cat > main.tf << 'EOF'
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "rg-teste-terraform"
  location = "North Central US"
}
EOF

# Inicializar e validar
terraform init
terraform validate
terraform plan

# Limpar teste
cd ~
rm -rf ~/teste-terraform
```

**✅ Resultado Esperado:**
- `terraform init`: Deve baixar o provider azurerm com sucesso
- `terraform validate`: Deve retornar "Success! The configuration is valid."
- `terraform plan`: Deve mostrar que criará 1 resource group

### Teste 4: Teste do Ansible
```bash
echo "=== Testando Ansible ==="
ansible localhost -m ping
```

**✅ Resultado Esperado:**
- Deve retornar: `localhost | SUCCESS => { "changed": false, "ping": "pong" }`

---

## 🚀 **7. Executando os Projetos**

🎉 **Parabéns! Seu ambiente está pronto para executar todos os projetos de IaC!**

Com o **login direto** (`az login`) configurado, você não precisa configurar variáveis ARM_* complexas. O **Terraform usará automaticamente suas credenciais do Azure CLI** para se conectar ao Azure.

Agora você pode navegar para qualquer projeto na pasta `instancia_computacao/` e executar tanto o Terraform quanto o Ansible diretamente do seu ambiente configurado.

---

## 🔧 **8. Troubleshooting - Problemas Comuns**

### Problema: "terraform: command not found"
**Solução**: Adicione o Terraform ao PATH do sistema
```bash
# Linux/macOS - adicionar ao ~/.bashrc ou ~/.zshrc
export PATH=$PATH:/caminho/para/terraform

# Windows - adicionar às variáveis de ambiente do sistema
```

### Problema: "ansible: command not found" no Windows
**Solução**: Use WSL2 ou Docker para executar Ansible

### Problema: "az: command not found"
**Solução**: Reinstale o Azure CLI e reinicie o terminal

### Problema: Erro de autenticação no Azure
**Solução**: 
```bash
az logout
az login
az account set --subscription "sua-assinatura"
```

### Problema: Permissão negada para chave SSH
**Solução**:
```bash
# Linux/macOS
chmod 600 ~/.ssh/projeto_rsa

# Windows (PowerShell como Admin)
icacls $env:USERPROFILE\.ssh\projeto_rsa /inheritance:r /grant:r "$env:USERNAME:R"
```

### Problema: Terraform não consegue criar recursos
**Solução**: Verifique se você tem permissões suficientes na assinatura Azure
```bash
az role assignment list --assignee $(az account show --query user.name -o tsv)
```

---

## 📚 **9. Próximos Passos**

Agora que seu ambiente está configurado:

1. ✅ **Configure sua VM Ubuntu** (se estiver no Windows): Instale Ubuntu Desktop 22.04 LTS
2. ✅ **Teste os projetos**: Execute os exemplos da pasta `instancia_computacao/`
3. ✅ **Explore**: Modifique os arquivos Terraform e Ansible para entender melhor
4. ✅ **Documente**: Anote suas configurações específicas
5. ✅ **Backup**: Faça backup das suas chaves SSH

**🐧 Lembre-se**: Para a melhor experiência, execute **todo o processo (Terraform + Ansible) dentro da VM Ubuntu** com interface gráfica!

---

## 🆘 **Precisa de Ajuda?**

- 📖 **Documentação Terraform**: https://www.terraform.io/docs
- 📖 **Documentação Ansible**: https://docs.ansible.com
- 📖 **Documentação Azure CLI**: https://docs.microsoft.com/cli/azure
- 🎓 **Tutoriais Azure**: https://docs.microsoft.com/azure

**Parabéns! 🎉 Seu ambiente está pronto para trabalhar com IaC!**
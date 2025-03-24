#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Script de Instalação do Sistema de Inventário ===${NC}"
echo -e "${YELLOW}Iniciando instalação...${NC}\n"

# Função para verificar se o comando foi executado com sucesso
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $1${NC}"
    else
        echo -e "${RED}✗ $1${NC}"
        exit 1
    fi
}

# Verificar se Node.js está instalado
if ! command -v node &> /dev/null; then
    echo -e "${RED}Node.js não encontrado. Por favor, instale o Node.js primeiro.${NC}"
    exit 1
fi

# Verificar se npm está instalado
if ! command -v npm &> /dev/null; then
    echo -e "${RED}npm não encontrado. Por favor, instale o npm primeiro.${NC}"
    exit 1
fi

echo -e "${YELLOW}Configurando Backend...${NC}"

# Entrar no diretório backend
cd backend

# Instalar dependências do backend
echo "Instalando dependências do backend..."
npm install
check_status "Instalação das dependências do backend"

# Configurar arquivo .env
if [ ! -f .env ]; then
    echo "Criando arquivo .env..."
    cp .env.example .env
    check_status "Criação do arquivo .env"
fi

echo -e "\n${YELLOW}Configurando Frontend...${NC}"

# Voltar para o diretório raiz e entrar no frontend
cd ../frontend

# Instalar dependências do frontend
echo "Instalando dependências do frontend..."
npm install
check_status "Instalação das dependências do frontend"

# Voltar para o diretório raiz
cd ..

echo -e "\n${GREEN}=== Instalação Concluída ===${NC}"
echo -e "${YELLOW}Para iniciar o sistema:${NC}"
echo -e "1. Backend: cd backend && npm start"
echo -e "2. Frontend: cd frontend && npm start"

# Criar arquivo de log da instalação
echo "$(date) - Instalação concluída com sucesso" > install.log

echo -e "\n${GREEN}Sistema instalado com sucesso!${NC}"
echo -e "${YELLOW}Consulte a documentação em LEIA-ME_DOCUMENTACAO.txt para mais informações.${NC}"
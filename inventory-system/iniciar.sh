#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Inicialização Rápida do Sistema de Inventário ===${NC}"

# Verificar se é a primeira execução
if [ ! -f ".initialized" ]; then
    echo -e "${YELLOW}Primeira execução detectada. Configurando o ambiente...${NC}"
    
    # Dar permissão de execução para todos os scripts
    echo "Configurando permissões..."
    chmod +x *.sh
    
    # Criar diretórios necessários
    echo "Criando diretórios..."
    mkdir -p logs backups
    
    # Criar arquivo de inicialização
    touch .initialized
fi

# Função para verificar se um processo está rodando na porta
check_port() {
    lsof -i:$1 > /dev/null 2>&1
    return $?
}

# Função para iniciar serviços
start_services() {
    echo -e "\n${YELLOW}Iniciando serviços...${NC}"
    
    # Verificar MongoDB
    if ! pgrep mongod > /dev/null; then
        echo "Iniciando MongoDB..."
        mongod --fork --logpath ./logs/mongodb.log
    fi
    
    # Iniciar Backend
    if ! check_port 5000; then
        echo "Iniciando Backend..."
        cd backend
        npm start &
        cd ..
    fi
    
    # Iniciar Frontend
    if ! check_port 3000; then
        echo "Iniciando Frontend..."
        cd frontend
        npm start &
        cd ..
    fi
}

# Menu rápido
echo -e "\n${BLUE}Escolha uma opção:${NC}"
echo "1. Iniciar Sistema Completo"
echo "2. Abrir Gerenciador Completo"
echo "3. Sair"

read -p "Opção: " choice

case $choice in
    1)
        start_services
        echo -e "\n${GREEN}Sistema iniciado!${NC}"
        echo -e "Frontend: ${BLUE}http://localhost:3000${NC}"
        echo -e "Backend: ${BLUE}http://localhost:5000${NC}"
        echo -e "\n${YELLOW}Para gerenciar o sistema use: ./gerenciador.sh${NC}"
        ;;
    2)
        ./gerenciador.sh
        ;;
    3)
        echo -e "${GREEN}Saindo...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Opção inválida${NC}"
        exit 1
        ;;
esac
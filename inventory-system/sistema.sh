#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Função para verificar se um processo está rodando na porta especificada
check_port() {
    lsof -i:$1 > /dev/null 2>&1
    return $?
}

# Função para iniciar o backend
start_backend() {
    echo -e "${YELLOW}Iniciando Backend...${NC}"
    cd backend
    if check_port 5000; then
        echo -e "${RED}Porta 5000 já está em uso. Tentando parar o processo...${NC}"
        kill $(lsof -t -i:5000) 2>/dev/null
        sleep 2
    fi
    npm start &
    cd ..
    echo -e "${GREEN}Backend iniciado na porta 5000${NC}"
}

# Função para iniciar o frontend
start_frontend() {
    echo -e "${YELLOW}Iniciando Frontend...${NC}"
    cd frontend
    if check_port 3000; then
        echo -e "${RED}Porta 3000 já está em uso. Tentando parar o processo...${NC}"
        kill $(lsof -t -i:3000) 2>/dev/null
        sleep 2
    fi
    npm start &
    cd ..
    echo -e "${GREEN}Frontend iniciado na porta 3000${NC}"
}

# Função para parar todos os serviços
stop_services() {
    echo -e "${YELLOW}Parando todos os serviços...${NC}"
    kill $(lsof -t -i:3000) 2>/dev/null
    kill $(lsof -t -i:5000) 2>/dev/null
    echo -e "${GREEN}Serviços parados${NC}"
}

# Função para verificar status dos serviços
check_status() {
    echo -e "${BLUE}=== Status dos Serviços ===${NC}"
    if check_port 5000; then
        echo -e "Backend: ${GREEN}Rodando${NC}"
    else
        echo -e "Backend: ${RED}Parado${NC}"
    fi
    
    if check_port 3000; then
        echo -e "Frontend: ${GREEN}Rodando${NC}"
    else
        echo -e "Frontend: ${RED}Parado${NC}"
    fi
}

# Menu de opções
show_menu() {
    echo -e "${BLUE}=== Sistema de Inventário ===${NC}"
    echo "1. Iniciar Sistema Completo"
    echo "2. Iniciar Apenas Backend"
    echo "3. Iniciar Apenas Frontend"
    echo "4. Parar Todos os Serviços"
    echo "5. Verificar Status"
    echo "6. Sair"
}

# Loop principal
while true; do
    show_menu
    read -p "Escolha uma opção: " choice

    case $choice in
        1)
            start_backend
            sleep 2
            start_frontend
            ;;
        2)
            start_backend
            ;;
        3)
            start_frontend
            ;;
        4)
            stop_services
            ;;
        5)
            check_status
            ;;
        6)
            echo -e "${GREEN}Saindo...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida${NC}"
            ;;
    esac
    echo -e "\nPressione ENTER para continuar..."
    read
    clear
done
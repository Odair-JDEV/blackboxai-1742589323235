#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Verificar se os scripts necessários existem
check_requirements() {
    local missing=0
    local scripts=("install.sh" "sistema.sh" "db_utils.sh" "verificar_requisitos.sh")
    
    for script in "${scripts[@]}"; do
        if [ ! -f "$script" ]; then
            echo -e "${RED}Erro: $script não encontrado${NC}"
            missing=1
        fi
    done
    
    if [ $missing -eq 1 ]; then
        exit 1
    fi
}

# Verificar requisitos do sistema
verify_system_requirements() {
    echo -e "${YELLOW}Verificando requisitos do sistema...${NC}"
    ./verificar_requisitos.sh
    if [ $? -ne 0 ]; then
        echo -e "${RED}Alguns requisitos do sistema não foram atendidos.${NC}"
        echo -e "${YELLOW}Verifique o relatório acima para mais detalhes.${NC}"
        read -p "Pressione ENTER para voltar ao menu principal..."
        return 1
    fi
    return 0
}

# Dar permissão de execução aos scripts
setup_permissions() {
    local scripts=("install.sh" "sistema.sh" "db_utils.sh" "verificar_requisitos.sh" "monitoramento.sh" "manutencao.sh")
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            chmod +x "$script"
            echo -e "${GREEN}Permissão de execução concedida: $script${NC}"
        fi
    done
}

# Função para mostrar o cabeçalho
show_header() {
    clear
    echo -e "${PURPLE}=================================================${NC}"
    echo -e "${PURPLE}   SISTEMA DE GERENCIAMENTO DE INVENTÁRIO v1.0    ${NC}"
    echo -e "${PURPLE}=================================================${NC}"
    echo
}

# Função para mostrar o status geral do sistema
show_system_status() {
    echo -e "${BLUE}=== Status do Sistema ===${NC}"
    
    # Verificar Backend
    if lsof -i:5000 &>/dev/null; then
        echo -e "Backend: ${GREEN}Rodando${NC}"
    else
        echo -e "Backend: ${RED}Parado${NC}"
    fi
    
    # Verificar Frontend
    if lsof -i:3000 &>/dev/null; then
        echo -e "Frontend: ${GREEN}Rodando${NC}"
    else
        echo -e "Frontend: ${RED}Parado${NC}"
    fi
    
    # Verificar MongoDB
    if pgrep mongod &>/dev/null; then
        echo -e "Banco de Dados: ${GREEN}Rodando${NC}"
    else
        echo -e "Banco de Dados: ${RED}Parado${NC}"
    fi
    
    echo
}

# Menu principal
show_menu() {
    echo -e "${BLUE}=== Menu Principal ===${NC}"
    echo "1. Verificar Requisitos do Sistema"
    echo "2. Instalar Sistema"
    echo "3. Gerenciar Serviços (Backend/Frontend)"
    echo "4. Utilitários do Banco de Dados"
    echo "5. Monitoramento do Sistema"
    echo "6. Manutenção do Sistema"
    echo "7. Verificar Status do Sistema"
    echo "8. Abrir Documentação"
    echo "9. Sair"
}

# Função para abrir documentação
open_docs() {
    echo -e "${BLUE}=== Documentação Disponível ===${NC}"
    echo "1. Tutorial de Instalação (TUTORIAL.txt)"
    echo "2. Guia Rápido (GUIA_RAPIDO.txt)"
    echo "3. Solução de Problemas (SOLUCAO_PROBLEMAS.txt)"
    echo "4. Documentação Completa (LEIA-ME_DOCUMENTACAO.txt)"
    echo "5. Voltar"
    
    read -p "Escolha um documento para visualizar: " doc_choice
    
    case $doc_choice in
        1) less TUTORIAL.txt ;;
        2) less GUIA_RAPIDO.txt ;;
        3) less SOLUCAO_PROBLEMAS.txt ;;
        4) less LEIA-ME_DOCUMENTACAO.txt ;;
        5) return ;;
        *) echo -e "${RED}Opção inválida${NC}" ;;
    esac
}

# Verificar requisitos
check_requirements

# Configurar permissões
setup_permissions

# Loop principal
while true; do
    show_header
    show_system_status
    show_menu
    
    read -p "Escolha uma opção: " choice
    
    case $choice in
        1)
            verify_system_requirements
            ;;
        2)
            if verify_system_requirements; then
                echo -e "${YELLOW}Iniciando instalação do sistema...${NC}"
                ./install.sh
            fi
            ;;
        3)
            echo -e "${YELLOW}Abrindo gerenciador de serviços...${NC}"
            ./sistema.sh
            ;;
        4)
            echo -e "${YELLOW}Abrindo utilitários do banco de dados...${NC}"
            ./db_utils.sh
            ;;
        5)
            echo -e "${YELLOW}Abrindo monitoramento do sistema...${NC}"
            ./monitoramento.sh
            ;;
        6)
            echo -e "${YELLOW}Abrindo sistema de manutenção...${NC}"
            ./manutencao.sh
            ;;
        7)
            echo -e "${YELLOW}Pressione ENTER para voltar ao menu...${NC}"
            read
            ;;
        8)
            open_docs
            ;;
        9)
            echo -e "${GREEN}Encerrando sistema...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida${NC}"
            sleep 2
            ;;
    esac
done
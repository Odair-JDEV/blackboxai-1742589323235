#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Diretório de logs
LOG_DIR="./logs"
mkdir -p $LOG_DIR

# Arquivo de log atual
CURRENT_LOG="$LOG_DIR/sistema_$(date +%Y%m%d).log"

# Função para registrar log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$CURRENT_LOG"
}

# Função para mostrar uso de recursos
show_resources() {
    echo -e "${BLUE}=== Uso de Recursos ===${NC}"
    
    # CPU
    echo -e "${YELLOW}Uso de CPU:${NC}"
    top -bn1 | grep "Cpu(s)" | awk '{print $2}'
    
    # Memória
    echo -e "\n${YELLOW}Uso de Memória:${NC}"
    free -h
    
    # Disco
    echo -e "\n${YELLOW}Uso de Disco:${NC}"
    df -h .
    
    # Processos do Sistema
    echo -e "\n${YELLOW}Processos do Sistema:${NC}"
    echo "Backend (porta 5000):"
    lsof -i:5000 2>/dev/null || echo "Não está rodando"
    
    echo -e "\nFrontend (porta 3000):"
    lsof -i:3000 2>/dev/null || echo "Não está rodando"
    
    echo -e "\nMongoDB:"
    pgrep mongod >/dev/null && echo "Rodando" || echo "Não está rodando"
}

# Função para mostrar logs recentes
show_recent_logs() {
    echo -e "${BLUE}=== Logs Recentes ===${NC}"
    if [ -f "$CURRENT_LOG" ]; then
        tail -n 20 "$CURRENT_LOG"
    else
        echo "Nenhum log encontrado para hoje"
    fi
}

# Função para limpar logs antigos
clean_old_logs() {
    echo -e "${YELLOW}Removendo logs mais antigos que 30 dias...${NC}"
    find $LOG_DIR -name "sistema_*.log" -mtime +30 -exec rm {} \;
    echo -e "${GREEN}Limpeza concluída${NC}"
}

# Função para verificar erros nos logs
check_errors() {
    echo -e "${BLUE}=== Verificando Erros nos Logs ===${NC}"
    if [ -f "$CURRENT_LOG" ]; then
        echo -e "${YELLOW}Erros encontrados hoje:${NC}"
        grep -i "erro\|error\|falha\|failed" "$CURRENT_LOG"
    else
        echo "Nenhum log encontrado para hoje"
    fi
}

# Função para monitoramento em tempo real
monitor_realtime() {
    echo -e "${BLUE}=== Monitoramento em Tempo Real ===${NC}"
    echo -e "${YELLOW}Pressione Ctrl+C para parar${NC}\n"
    
    while true; do
        clear
        date
        echo "----------------------------------------"
        
        # Verificar serviços
        echo -e "\n${YELLOW}Status dos Serviços:${NC}"
        if lsof -i:5000 >/dev/null 2>&1; then
            echo -e "Backend: ${GREEN}Rodando${NC}"
        else
            echo -e "Backend: ${RED}Parado${NC}"
        fi
        
        if lsof -i:3000 >/dev/null 2>&1; then
            echo -e "Frontend: ${GREEN}Rodando${NC}"
        else
            echo -e "Frontend: ${RED}Parado${NC}"
        fi
        
        if pgrep mongod >/dev/null; then
            echo -e "MongoDB: ${GREEN}Rodando${NC}"
        else
            echo -e "MongoDB: ${RED}Parado${NC}"
        fi
        
        # Mostrar uso de recursos
        echo -e "\n${YELLOW}Uso de CPU e Memória:${NC}"
        top -bn1 | head -n 3
        
        # Aguardar 5 segundos
        sleep 5
    done
}

# Menu
while true; do
    echo -e "\n${BLUE}=== Sistema de Monitoramento ===${NC}"
    echo "1. Mostrar Uso de Recursos"
    echo "2. Ver Logs Recentes"
    echo "3. Verificar Erros"
    echo "4. Limpar Logs Antigos"
    echo "5. Monitoramento em Tempo Real"
    echo "6. Sair"
    
    read -p "Escolha uma opção: " choice
    
    case $choice in
        1)
            show_resources
            ;;
        2)
            show_recent_logs
            ;;
        3)
            check_errors
            ;;
        4)
            clean_old_logs
            ;;
        5)
            monitor_realtime
            ;;
        6)
            echo -e "${GREEN}Encerrando monitoramento...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida${NC}"
            ;;
    esac
    
    echo -e "\nPressione ENTER para continuar..."
    read
done
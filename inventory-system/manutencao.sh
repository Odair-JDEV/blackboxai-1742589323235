#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Diretório de backup
BACKUP_DIR="./backups/$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# Função para fazer backup do sistema
backup_system() {
    echo -e "${YELLOW}Iniciando backup do sistema...${NC}"
    
    # Backup do frontend
    echo "Backup do frontend..."
    tar -czf "$BACKUP_DIR/frontend.tar.gz" frontend/ 2>/dev/null
    
    # Backup do backend
    echo "Backup do backend..."
    tar -czf "$BACKUP_DIR/backend.tar.gz" backend/ 2>/dev/null
    
    # Backup do banco de dados
    echo "Backup do banco de dados..."
    if command -v mongodump &> /dev/null; then
        mongodump --out "$BACKUP_DIR/mongodb" 2>/dev/null
    fi
    
    echo -e "${GREEN}Backup concluído: $BACKUP_DIR${NC}"
}

# Função para atualizar dependências
update_dependencies() {
    echo -e "${YELLOW}Atualizando dependências...${NC}"
    
    # Frontend
    echo "Atualizando frontend..."
    cd frontend
    npm update
    npm audit fix --force
    cd ..
    
    # Backend
    echo "Atualizando backend..."
    cd backend
    npm update
    npm audit fix --force
    cd ..
    
    echo -e "${GREEN}Dependências atualizadas${NC}"
}

# Função para verificar integridade do sistema
check_system_integrity() {
    echo -e "${YELLOW}Verificando integridade do sistema...${NC}"
    
    local errors=0
    
    # Verificar arquivos essenciais
    echo "Verificando arquivos essenciais..."
    local required_files=(
        "frontend/package.json"
        "frontend/src/index.js"
        "backend/package.json"
        "backend/server.js"
        "backend/.env"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}Arquivo não encontrado: $file${NC}"
            ((errors++))
        fi
    done
    
    # Verificar diretórios
    echo "Verificando diretórios..."
    local required_dirs=(
        "frontend/src"
        "frontend/public"
        "backend/src"
        "logs"
        "backups"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            echo -e "${RED}Diretório não encontrado: $dir${NC}"
            ((errors++))
        fi
    done
    
    # Verificar conexões
    echo "Verificando conexões..."
    if ! curl -s http://localhost:5000/api/health >/dev/null; then
        echo -e "${RED}Backend não está respondendo${NC}"
        ((errors++))
    fi
    
    if ! curl -s http://localhost:3000 >/dev/null; then
        echo -e "${RED}Frontend não está respondendo${NC}"
        ((errors++))
    fi
    
    # Resultado
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Sistema íntegro${NC}"
    else
        echo -e "${RED}Foram encontrados $errors problema(s)${NC}"
    fi
}

# Função para limpar arquivos temporários
clean_temp_files() {
    echo -e "${YELLOW}Limpando arquivos temporários...${NC}"
    
    # Limpar cache do npm
    echo "Limpando cache do npm..."
    npm cache clean --force
    
    # Remover node_modules
    echo "Removendo node_modules..."
    rm -rf frontend/node_modules
    rm -rf backend/node_modules
    
    # Remover logs antigos
    echo "Removendo logs antigos..."
    find ./logs -type f -mtime +30 -exec rm {} \;
    
    # Remover backups antigos
    echo "Removendo backups antigos..."
    find ./backups -type d -mtime +30 -exec rm -rf {} \;
    
    echo -e "${GREEN}Limpeza concluída${NC}"
}

# Função para reinstalar dependências
reinstall_dependencies() {
    echo -e "${YELLOW}Reinstalando dependências...${NC}"
    
    # Frontend
    echo "Reinstalando frontend..."
    cd frontend
    rm -rf node_modules package-lock.json
    npm install
    cd ..
    
    # Backend
    echo "Reinstalando backend..."
    cd backend
    rm -rf node_modules package-lock.json
    npm install
    cd ..
    
    echo -e "${GREEN}Dependências reinstaladas${NC}"
}

# Menu
while true; do
    echo -e "\n${BLUE}=== Sistema de Manutenção ===${NC}"
    echo "1. Fazer Backup do Sistema"
    echo "2. Atualizar Dependências"
    echo "3. Verificar Integridade"
    echo "4. Limpar Arquivos Temporários"
    echo "5. Reinstalar Dependências"
    echo "6. Sair"
    
    read -p "Escolha uma opção: " choice
    
    case $choice in
        1)
            backup_system
            ;;
        2)
            update_dependencies
            ;;
        3)
            check_system_integrity
            ;;
        4)
            clean_temp_files
            ;;
        5)
            reinstall_dependencies
            ;;
        6)
            echo -e "${GREEN}Encerrando manutenção...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida${NC}"
            ;;
    esac
    
    echo -e "\nPressione ENTER para continuar..."
    read
done
#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Verificação de Requisitos do Sistema ===${NC}\n"

# Função para verificar versão do Node.js
check_node() {
    if command -v node &> /dev/null; then
        VERSION=$(node -v | cut -d'v' -f2)
        MAJOR_VERSION=$(echo $VERSION | cut -d'.' -f1)
        if [ $MAJOR_VERSION -ge 14 ]; then
            echo -e "Node.js: ${GREEN}Instalado (v$VERSION)${NC}"
            return 0
        else
            echo -e "Node.js: ${RED}Versão incompatível (v$VERSION). Necessário v14 ou superior${NC}"
            return 1
        fi
    else
        echo -e "Node.js: ${RED}Não instalado${NC}"
        return 1
    fi
}

# Função para verificar npm
check_npm() {
    if command -v npm &> /dev/null; then
        VERSION=$(npm -v)
        echo -e "npm: ${GREEN}Instalado (v$VERSION)${NC}"
        return 0
    else
        echo -e "npm: ${RED}Não instalado${NC}"
        return 1
    fi
}

# Função para verificar MongoDB
check_mongodb() {
    if command -v mongod &> /dev/null; then
        VERSION=$(mongod --version | grep "db version" | cut -d'v' -f2)
        echo -e "MongoDB: ${GREEN}Instalado (v$VERSION)${NC}"
        return 0
    else
        echo -e "MongoDB: ${RED}Não instalado${NC}"
        return 1
    fi
}

# Função para verificar espaço em disco
check_disk_space() {
    REQUIRED_SPACE=1024  # 1GB em MB
    AVAILABLE_SPACE=$(df -m . | awk 'NR==2 {print $4}')
    
    if [ $AVAILABLE_SPACE -ge $REQUIRED_SPACE ]; then
        echo -e "Espaço em Disco: ${GREEN}Suficiente ($AVAILABLE_SPACE MB disponível)${NC}"
        return 0
    else
        echo -e "Espaço em Disco: ${RED}Insuficiente ($AVAILABLE_SPACE MB disponível, necessário $REQUIRED_SPACE MB)${NC}"
        return 1
    fi
}

# Função para verificar memória RAM
check_memory() {
    REQUIRED_MEMORY=2048  # 2GB em MB
    AVAILABLE_MEMORY=$(free -m | awk 'NR==2 {print $2}')
    
    if [ $AVAILABLE_MEMORY -ge $REQUIRED_MEMORY ]; then
        echo -e "Memória RAM: ${GREEN}Suficiente ($AVAILABLE_MEMORY MB)${NC}"
        return 0
    else
        echo -e "Memória RAM: ${RED}Insuficiente ($AVAILABLE_MEMORY MB, recomendado $REQUIRED_MEMORY MB)${NC}"
        return 1
    fi
}

# Função para verificar permissões
check_permissions() {
    if [ -w "." ]; then
        echo -e "Permissões: ${GREEN}OK${NC}"
        return 0
    else
        echo -e "Permissões: ${RED}Sem permissão de escrita no diretório atual${NC}"
        return 1
    fi
}

# Contador de erros
ERRORS=0

# Executar verificações
echo -e "${YELLOW}Verificando requisitos...${NC}\n"

check_node || ((ERRORS++))
check_npm || ((ERRORS++))
check_mongodb || ((ERRORS++))
check_disk_space || ((ERRORS++))
check_memory || ((ERRORS++))
check_permissions || ((ERRORS++))

echo -e "\n${BLUE}=== Resultado da Verificação ===${NC}"

if [ $ERRORS -eq 0 ]; then
    echo -e "\n${GREEN}✓ Todos os requisitos foram atendidos!${NC}"
    echo -e "${GREEN}✓ Você pode prosseguir com a instalação.${NC}"
    exit 0
else
    echo -e "\n${RED}✗ Foram encontrados $ERRORS problema(s).${NC}"
    echo -e "${YELLOW}Por favor, corrija os problemas acima antes de prosseguir com a instalação.${NC}"
    
    echo -e "\n${BLUE}Sugestões de correção:${NC}"
    echo "1. Node.js: https://nodejs.org/pt-br/download/"
    echo "2. MongoDB: https://docs.mongodb.com/manual/installation/"
    echo "3. Para problemas de permissão: sudo chown -R $USER:$USER ."
    echo "4. Para problemas de espaço: libere espaço ou use outro disco"
    exit 1
fi
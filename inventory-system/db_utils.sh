#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurações padrão
DB_NAME="inventory_system"
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Criar diretório de backup se não existir
mkdir -p $BACKUP_DIR

# Função para verificar se MongoDB está instalado
check_mongodb() {
    if ! command -v mongod &> /dev/null; then
        echo -e "${RED}MongoDB não encontrado. Por favor, instale o MongoDB primeiro.${NC}"
        exit 1
    fi
}

# Função para criar backup
create_backup() {
    echo -e "${YELLOW}Criando backup do banco de dados...${NC}"
    if mongodump --db $DB_NAME --out "$BACKUP_DIR/backup_$DATE" &> /dev/null; then
        echo -e "${GREEN}Backup criado com sucesso em: $BACKUP_DIR/backup_$DATE${NC}"
    else
        echo -e "${RED}Erro ao criar backup${NC}"
        exit 1
    fi
}

# Função para restaurar backup
restore_backup() {
    echo -e "${BLUE}Backups disponíveis:${NC}"
    ls -1 $BACKUP_DIR
    
    read -p "Digite o nome do backup para restaurar: " backup_name
    
    if [ -d "$BACKUP_DIR/$backup_name" ]; then
        echo -e "${YELLOW}Restaurando backup...${NC}"
        if mongorestore --db $DB_NAME "$BACKUP_DIR/$backup_name/$DB_NAME" &> /dev/null; then
            echo -e "${GREEN}Backup restaurado com sucesso${NC}"
        else
            echo -e "${RED}Erro ao restaurar backup${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Backup não encontrado${NC}"
        exit 1
    fi
}

# Função para limpar dados antigos
clean_old_backups() {
    echo -e "${YELLOW}Removendo backups mais antigos que 30 dias...${NC}"
    find $BACKUP_DIR -type d -mtime +30 -exec rm -rf {} \;
    echo -e "${GREEN}Limpeza concluída${NC}"
}

# Função para inicializar banco com dados padrão
init_database() {
    echo -e "${YELLOW}Inicializando banco de dados com dados padrão...${NC}"
    
    # Criar coleções básicas
    mongo $DB_NAME --eval '
        db.createCollection("users");
        db.createCollection("products");
        db.createCollection("categories");
        
        // Inserir usuário admin padrão
        db.users.insert({
            username: "admin",
            password: "admin123",
            role: "admin",
            createdAt: new Date()
        });
        
        // Inserir algumas categorias padrão
        db.categories.insert([
            {name: "Eletrônicos", createdAt: new Date()},
            {name: "Móveis", createdAt: new Date()},
            {name: "Livros", createdAt: new Date()}
        ]);
    ' &> /dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Banco de dados inicializado com sucesso${NC}"
    else
        echo -e "${RED}Erro ao inicializar banco de dados${NC}"
        exit 1
    fi
}

# Função para verificar status do banco
check_db_status() {
    echo -e "${BLUE}Verificando status do MongoDB...${NC}"
    if pgrep mongod &> /dev/null; then
        echo -e "Status: ${GREEN}Ativo${NC}"
        echo -e "${YELLOW}Estatísticas do banco:${NC}"
        mongo $DB_NAME --eval "
            print('Usuários: ' + db.users.count());
            print('Produtos: ' + db.products.count());
            print('Categorias: ' + db.categories.count());
        "
    else
        echo -e "Status: ${RED}Inativo${NC}"
    fi
}

# Menu de opções
show_menu() {
    echo -e "${BLUE}=== Utilitários do Banco de Dados ===${NC}"
    echo "1. Criar Backup"
    echo "2. Restaurar Backup"
    echo "3. Limpar Backups Antigos"
    echo "4. Inicializar Banco com Dados Padrão"
    echo "5. Verificar Status do Banco"
    echo "6. Sair"
}

# Verificar MongoDB
check_mongodb

# Loop principal
while true; do
    show_menu
    read -p "Escolha uma opção: " choice

    case $choice in
        1)
            create_backup
            ;;
        2)
            restore_backup
            ;;
        3)
            clean_old_backups
            ;;
        4)
            init_database
            ;;
        5)
            check_db_status
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
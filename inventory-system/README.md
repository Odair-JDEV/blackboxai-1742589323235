# Sistema de Gerenciamento de Inventário

## Estrutura do Projeto
```
inventory-system/
├── backend/               # API REST em Node.js
│   ├── src/
│   │   ├── config/       # Configurações do servidor
│   │   ├── controllers/  # Controladores da aplicação
│   │   ├── middlewares/  # Middlewares personalizados
│   │   ├── routes/       # Rotas da API
│   │   └── data/         # Modelos de dados
│   └── server.js         # Arquivo principal do servidor
│
├── frontend/             # Interface em React
│   ├── public/          # Arquivos públicos
│   └── src/             # Código fonte React
│       ├── components/  # Componentes React
│       ├── App.js       # Componente principal
│       └── index.js     # Ponto de entrada
│
├── TUTORIAL.txt         # Guia de instalação em português
└── README.md           # Este arquivo
```

## Tecnologias Utilizadas

### Backend
- Node.js
- Express.js
- MongoDB
- JWT para autenticação
- Middlewares personalizados

### Frontend
- React
- Tailwind CSS
- Axios para requisições HTTP
- React Router para navegação

## Funcionalidades Principais
- Autenticação de usuários
- Gerenciamento de produtos
- Controle de estoque
- Relatórios e análises

## Requisitos de Sistema
- Node.js 14+
- npm 6+
- MongoDB

Para instruções detalhadas de instalação e execução, consulte o arquivo TUTORIAL.txt

## Desenvolvimento

Para contribuir com o projeto:

1. Clone o repositório
2. Siga as instruções no TUTORIAL.txt
3. Crie um branch para suas alterações
4. Envie um pull request

## Suporte

Em caso de dúvidas ou problemas:
1. Consulte o TUTORIAL.txt
2. Verifique as issues existentes
3. Abra uma nova issue descrevendo o problema
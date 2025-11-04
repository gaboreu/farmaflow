# Projeto: Farmaflow

Este projeto é um sistema de controle de estoque hospitalar...

## Como Rodar o Projeto

1.  **Clone o repositório:**
    'git clone ...'

2.  **Crie o ambiente virtual:**
    'python -m venv venv'
    'source venv/bin/activate' (ou 'venv\Scripts\activate' no Windows)

3.  **Instale as dependências:**
    'pip install Flask flask-mysql-connector-python flask-cors python-dotenv'

4.  **Configure o Banco de Dados:**
    * Crie seu banco MySQL (ex: 'hospital_estoque').
    * Importe a estrutura: 'mysql -u seu_usuario -p hospital_estoque < schema.sql'
    * (Opcional) Importe os dados de teste: 'mysql -u seu_usuario -p hospital_estoque < seed.sql'

5.  **Crie seu arquivo '.env':**
    * Crie um arquivo '.env' na raiz do projeto.
    * Copie o conteúdo de '.env.example' (você pode criar esse arquivo) e preencha com suas credenciais:
        '''
        DB_HOST=localhost
        DB_USER=root
        DB_PASS=SUA_SENHA_AQUI
        DB_NAME=hospital_estoque
        '''

6.  **Rode o Backend:**
    'python app.py'

7.  **Abra o Frontend:**
    * Abra o 'index.html' no seu navegador.

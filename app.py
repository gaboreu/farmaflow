from flask import Flask, jsonify
from flask_mysql_connector import MySQL
from flask_cors import CORS

app = Flask(__name__)
CORS(app) 

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'sua_senha'
app.config['MYSQL_DATABASE'] = 'hospital_estoque'
mysql = MySQL(app)

@app.route('/')
def home():
    return "API do Sistema de Estoque Hospitalar está no ar!"

@app.route('/api/dashboard')
def get_dashboard_data():
    try:
        conn = mysql.new_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT SUM(saldo) as total_itens FROM ItensEstoque")
        total_itens = cursor.fetchone()['total_itens']

        cursor.execute("SELECT COUNT(id) as itens_criticos FROM ItensEstoque WHERE saldo <= nivel_minimo")
        itens_criticos = cursor.fetchone()['itens_criticos']
        
        mov_hoje = 326 

        cursor.execute("SELECT nome, saldo, setor, nivel_minimo FROM ItensEstoque ORDER BY setor")
        estoque_setor = cursor.fetchall()
        
        cursor.execute("SELECT nome, saldo, nivel_minimo, setor FROM ItensEstoque WHERE saldo <= nivel_minimo")
        alertas = cursor.fetchall()

        cursor.close()
        conn.close()

        return jsonify({
            'itens_em_estoque': total_itens,
            'itens_criticos': itens_criticos,
            'movimentacoes_hoje': mov_hoje,
            'estoque_por_setor': estoque_setor,
            'alertas': alertas
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/movimentacao/saida', methods=['POST'])
def add_saida():
    
    return jsonify({'message': 'Movimentação de saída registrada com sucesso (simulação)'}), 201


if __name__ == '__main__':
    app.run(debug=True)
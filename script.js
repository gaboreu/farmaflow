document.addEventListener('DOMContentLoaded', () => {
    fetchDashboardData();
});

async function fetchDashboardData() {
    try {
        const response = await fetch('http://127.0.0.1:5000/api/dashboard');
        
        if (!response.ok) {
            throw new Error('Falha ao buscar dados da API');
        }
        
        const data = await response.json();

        document.getElementById('kpi-total-itens').textContent = data.itens_em_estoque;
        document.getElementById('kpi-itens-criticos').textContent = data.itens_criticos;
        document.getElementById('kpi-mov-hoje').textContent = data.movimentacoes_hoje;

        const alertasContainer = document.getElementById('alertas-container');
        alertasContainer.innerHTML = '';
        data.alertas.forEach(alerta => {
            const div = document.createElement('div');
            const tipo = (alerta.saldo == 0) ? 'critico' : 'atencao'; 
            div.className = `alerta ${tipo}`;
            div.innerHTML = `
                ▲ Alerta - ${alerta.nome} (${alerta.setor})<br>
                Saldo: ${alerta.saldo} | Nível mínimo: ${alerta.nivel_minimo}
            `;
            alertasContainer.appendChild(div);
        });

        const tabelaBody = document.getElementById('tabela-estoque-setor');
        tabelaBody.innerHTML = ''; // Limpa a tabela
        data.estoque_por_setor.forEach(item => {
            const tr = document.createElement('tr');
            
            let statusClasse = 'status-ok';
            let statusTexto = 'OK';
            if (item.saldo <= item.nivel_minimo) {
                statusClasse = 'status-atencao';
                statusTexto = 'Atenção';
            }
            if (item.saldo < (item.nivel_minimo / 2)) {
                statusClasse = 'status-critico';
                statusTexto = 'Crítico';
            }

            tr.innerHTML = `
                <td>${item.setor} (${item.nome})</td>
                <td>${item.saldo}</td>
                <td>--</td> <td class="${statusClasse}">${statusTexto}</td>
            `;
            tabelaBody.appendChild(tr);
        });

    } catch (error) {
        console.error('Erro no script.js:', error);
        document.getElementById('alertas-container').innerHTML = 
            '<div class="alerta critico">Não foi possível carregar os dados. A API Python está rodando?</div>';
    }
}
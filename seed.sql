USE hospital_estoque;

INSERT INTO Hospitais (id, nome, cnpj, endereco) 
VALUES
(1, 'Hospital Piloto UNICID', '12.345.678/0001-99', 'Rua Fictícia, 123 - São Paulo/SP');

INSERT INTO Setores (id, hospital_id, nome, descricao)
VALUES
(1, 1, 'Farmácia Central', 'Estoque principal do hospital'),
(2, 1, 'Enfermaria', 'Setor de internação geral'),
(3, 1, 'UTI', 'Unidade de Terapia Intensiva'),
(4, 1, 'Centro Cirúrgico', 'Setor de operações'),
(5, 1, 'Emergência', 'Setor de pronto-atendimento');

INSERT INTO Perfis (id, nome_perfil)
VALUES
(1, 'Admin'),
(2, 'Farmacêutico'),
(3, 'Enfermeiro');

INSERT INTO Usuarios (id, hospital_id, username, password_hash, nome_completo, email, ativo)
VALUES
(1, 1, 'admin', '$2b$12$eI.Exi.f.Pn.9mco3h3RWO.sW7iP/P0/f.gE/D6nJdG2U/y.21dwa', 'Admin do Sistema', 'admin@hospital.com', 1),
(2, 1, 'farmaceutico', '$2b$12$eI.Exi.f.Pn.9mco3h3RWO.sW7iP/P0/f.gE/D6nJdG2U/y.21dwa', 'Willian Rossini', 'willian@hospital.com', 1),
(3, 1, 'enfermeiro', '$2b$12$eI.Exi.f.Pn.9mco3h3RWO.sW7iP/P0/f.gE/D6nJdG2U/y.21dwa', 'Lívia Mânfio', 'livia@hospital.com', 1);

INSERT INTO UsuarioPerfis (usuario_id, perfil_id)
VALUES
(1, 1), -- admin é Admin
(2, 2), -- willian é Farmacêutico
(3, 3); -- livia é Enfermeiro

INSERT INTO ItemCatalogo (id, nome, unidade_medida, storage_req)
VALUES
(1, 'Soro 0,9% Bolsa 500ml', 'unidade', 'Temperatura ambiente'),
(2, 'Heparina 5000 UI/ml Frasco 5ml', 'frasco', 'Manter entre 2°C e 8°C'),
(3, 'Fentanil 0,05mg/ml Ampola 2ml', 'ampola', 'Temperatura ambiente, protegido da luz'),
(4, 'Adrenalina 1mg/ml Ampola 1ml', 'ampola', 'Temperatura ambiente, protegido da luz'),
(5, 'Pentanli 50mg/ml (Fentanil) Ampola 10ml', 'ampola', 'Temperatura ambiente, protegido da luz');

INSERT INTO ItemLotes (item_catalogo_id, setor_id, numero_lote, saldo, data_validade, nivel_minimo)
VALUES
(1, 2, 'LOTE-S-11A', 38, '2026-10-30', 10);

INSERT INTO ItemLotes (item_catalogo_id, setor_id, numero_lote, saldo, data_validade, nivel_minimo)
VALUES
(2, 3, 'LOTE-H-22B', 6, '2026-05-15', 5); -- Nível mínimo 5, saldo 6 = Atenção [cite: 297, 298]

INSERT INTO ItemLotes (item_catalogo_id, setor_id, numero_lote, saldo, data_validade, nivel_minimo)
VALUES
(3, 4, 'LOTE-F-33C', 2, '2026-08-20', 5); -- Nível mínimo 5, saldo 2 = Crítico [cite: 301, 304, 299]

INSERT INTO ItemLotes (item_catalogo_id, setor_id, numero_lote, saldo, data_validade, nivel_minimo)
VALUES
(4, 5, 'LOTE-A-44D', 1, '2026-12-01', 4); -- Nível mínimo 4, saldo 1 = Alerta Crítico [cite: 300, 305]

INSERT INTO ItemLotes (item_catalogo_id, setor_id, numero_lote, saldo, data_validade, nivel_minimo)
VALUES
(5, 4, 'LOTE-P-55E', 1, '2026-11-25', 5); -- Nível mínimo 5, saldo 1 = Alerta Crítico [cite: 290, 302]

INSERT INTO Movimentacoes (item_lote_id, usuario_id, tipo, quantidade, setor_origem_id, setor_destino_id, observacao)
VALUES
(1, 3, 'saida', 2, 1, 2, 'Retirada para paciente Leito 101'),
(2, 3, 'saida', 1, 1, 3, 'Retirada para paciente UTI 05');

INSERT INTO Fornecedores (id, razao_social, cnpj)
VALUES
(1, 'MedSupply Distribuidora Ltda', '22.444.555/0001-11');

INSERT INTO Pedidos (id, fornecedor_id, usuario_solicitante_id, setor_destino_id, data_pedido, data_entrega_prevista, status)
VALUES
(1, 1, 2, 1, NOW(), '2025-11-10', 'pendente');

INSERT INTO PedidoItens (pedido_id, item_catalogo_id, quantidade_solicitada)
VALUES
(1, 2, 50), -- Pedido de Heparina
(1, 3, 100); -- Pedido de Fentanil
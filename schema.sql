CREATE DATABASE IF NOT EXISTS hospital_estoque CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hospital_estoque;

CREATE TABLE IF NOT EXISTS Hospitais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) UNIQUE,
    endereco TEXT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Setores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    FOREIGN KEY (hospital_id) REFERENCES Hospitais(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Perfis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_perfil VARCHAR(50) NOT NULL UNIQUE COMMENT 'Ex: admin, farmaceutico, enfermeiro'
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_id INT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nome_completo VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    ativo BOOLEAN DEFAULT true,
    FOREIGN KEY (hospital_id) REFERENCES Hospitais(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS UsuarioPerfis (
    usuario_id INT NOT NULL,
    perfil_id INT NOT NULL,
    PRIMARY KEY (usuario_id, perfil_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (perfil_id) REFERENCES Perfis(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ItemCatalogo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    unidade_medida VARCHAR(20) COMMENT 'Ex: 'caixa', 'unidade', 'ml'',
    storage_req TEXT COMMENT 'Ex: Manter entre 2°C e 8°C'
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ItemLotes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_catalogo_id INT NOT NULL,
    setor_id INT NOT NULL COMMENT 'Onde este lote está armazenado',
    numero_lote VARCHAR(100) NOT NULL,
    saldo INT NOT NULL DEFAULT 0 COMMENT 'Saldo atual deste lote neste setor',
    data_validade DATE NOT NULL,
    data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nivel_minimo INT NOT NULL DEFAULT 10 COMMENT 'Nível crítico para este item neste setor',
    
    FOREIGN KEY (item_catalogo_id) REFERENCES ItemCatalogo(id),
    FOREIGN KEY (setor_id) REFERENCES Setores(id),
    UNIQUE KEY (item_catalogo_id, setor_id, numero_lote)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Movimentacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_lote_id INT NOT NULL COMMENT 'Qual lote específico foi movido',
    usuario_id INT NOT NULL COMMENT 'Quem realizou a movimentação',
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    tipo ENUM('entrada', 'saida', 'transferencia', 'perda_vencimento', 'perda_dano', 'ajuste_positivo', 'ajuste_negativo') NOT NULL,
    
    quantidade INT NOT NULL,
    
    setor_origem_id INT NULL COMMENT 'De onde saiu (para transferências/saídas)',
    setor_destino_id INT NULL COMMENT 'Para onde foi (para transferências/entradas)',
    
    observacao TEXT,
    
    FOREIGN KEY (item_lote_id) REFERENCES ItemLotes(id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (setor_origem_id) REFERENCES Setores(id),
    FOREIGN KEY (setor_destino_id) REFERENCES Setores(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Fornecedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(200) NOT NULL,
    cnpj VARCHAR(18) UNIQUE,
    contato_nome VARCHAR(100),
    contato_email VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fornecedor_id INT NOT NULL,
    usuario_solicitante_id INT NOT NULL,
    setor_destino_id INT NOT NULL COMMENT 'Setor para onde o pedido será entregue',
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_entrega_prevista DATE,
    data_entrega_real TIMESTAMP NULL,
    status ENUM('pendente', 'aprovado', 'enviado', 'recebido_parcial', 'recebido_total', 'cancelado') NOT NULL,
    
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(id),
    FOREIGN KEY (usuario_solicitante_id) REFERENCES Usuarios(id),
    FOREIGN KEY (setor_destino_id) REFERENCES Setores(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS PedidoItens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    item_catalogo_id INT NOT NULL,
    quantidade_solicitada INT NOT NULL,
    quantidade_recebida INT DEFAULT 0,
    
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (item_catalogo_id) REFERENCES ItemCatalogo(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Sensores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setor_id INT NOT NULL,
    tipo_sensor VARCHAR(50) NOT NULL COMMENT 'Ex: temperatura, umidade',
    modelo VARCHAR(100),
    UNIQUE KEY (setor_id, tipo_sensor)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS SensorLogs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_leitura VARCHAR(50) NOT NULL,
    FOREIGN KEY (sensor_id) REFERENCES Sensores(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AuditLog (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL COMMENT 'Quem fez (NULL se for ação do sistema)',
    acao VARCHAR(255) NOT NULL,
    tabela_afetada VARCHAR(100),
    registro_id INT,
    detalhes_json JSON COMMENT 'Armazena o 'antes' e 'depois' da mudança',
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
) ENGINE=InnoDB;
SELECT 
    a.account_id,
    c.email AS identificador_cliente,
    a.account_number,
    UPPER(c.first_name || ' ' || c.last_name) AS titular_mayusculas,
    'CTA-' || RIGHT(a.account_number, 4) || '-' || UPPER(CAST(a.account_type AS VARCHAR)) AS etiqueta_presentacion,
    a.balance AS saldo_almacenado,
    a.is_active,
    CASE 
        WHEN a.is_active = false THEN 'CUENTA DESACTIVADA'
        ELSE 'CUENTA ACTIVA'
    END AS estado_operativo
FROM core.accounts a
LEFT JOIN core.customers c ON a.customer_id = c.customer_id
ORDER BY a.account_number;

SELECT 
    transaction_id,
    account_id,
    tx_type,
    amount AS importe_original,
    CAST(amount AS NUMERIC(15,2)) AS importe_presentacion,
    tx_timestamp AS marca_temporal_original,
    (tx_timestamp + INTERVAL '15 days') AS fecha_revision_calculada,
    EXTRACT(YEAR FROM tx_timestamp) AS anio_movimiento,
    EXTRACT(MONTH FROM tx_timestamp) AS mes_movimiento
FROM core.transactions
WHERE tx_timestamp < TIMESTAMP '2026-10-01 00:00+00'
ORDER BY tx_timestamp, transaction_id;

SELECT COUNT(*) AS total_cuentas_registradas FROM core.accounts;

SELECT COUNT(*) AS total_movimientos_registrados FROM core.transactions;
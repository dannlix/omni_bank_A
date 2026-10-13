SELECT 
    t1.account_id,
    t1.transaction_id AS transaction_id_1,
    t1.tx_timestamp AS timestamp_1,
    t1.amount AS amount_1,
    t2.transaction_id AS transaction_id_2,
    t2.tx_timestamp AS timestamp_2,
    t2.amount AS amount_2,
    t2.tx_timestamp - t1.tx_timestamp AS intervalo_transcurrido
FROM core.transactions t1
INNER JOIN core.transactions t2 
    ON t1.account_id = t2.account_id
    AND t1.transaction_id < t2.transaction_id
    AND t2.tx_timestamp >= t1.tx_timestamp
    AND t2.tx_timestamp <= t1.tx_timestamp + INTERVAL '48 hours'
ORDER BY t1.tx_timestamp, t1.transaction_id;

WITH 

tipos_cuenta AS (
    SELECT unnest(enum_range(NULL::core.tipo_cuenta)) AS account_type
),

matriz_teorica AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        t.account_type
    FROM core.customers c
    CROSS JOIN tipos_cuenta t
)

SELECT 
    m.email,
    m.first_name || ' ' || m.last_name AS titular,
    m.account_type AS tipo_cuenta_no_registrado
FROM matriz_teorica m
WHERE NOT EXISTS (
    SELECT 1 
    FROM core.accounts a 
    WHERE a.customer_id = m.customer_id 
      AND a.account_type = m.account_type
)
ORDER BY m.email, m.account_type;

SELECT transaction_id, account_id, amount, tx_timestamp 
FROM core.transactions 
WHERE account_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
ORDER BY tx_timestamp;

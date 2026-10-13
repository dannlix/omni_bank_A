SELECT 
    t1.transaction_id,
    t1.account_id,
    t1.tx_type,
    t1.amount AS importe_evento,
    (
        SELECT AVG(t2.amount) 
        FROM core.transactions t2 
        WHERE t2.account_id = t1.account_id
    ) AS promedio_propio_cuenta,
    t1.tx_timestamp
FROM core.transactions t1
WHERE t1.amount > (
    SELECT AVG(t2.amount) 
    FROM core.transactions t2 
    WHERE t2.account_id = t1.account_id
)
ORDER BY t1.tx_timestamp, t1.transaction_id;

SELECT 
    account_id,
    COUNT(transaction_id) AS total_movimientos,
    AVG(amount) AS promedio_agrupado_cuenta
FROM core.transactions
GROUP BY account_id
ORDER BY account_id;

SELECT 
    a.account_number,
    a.account_type,
    a.is_active,
    a.balance,
    CASE 
        WHEN a.is_active = false THEN 'CUENTA DESACTIVADA SIN EVENTOS'
        ELSE 'CUENTA ACTIVA SIN EVENTOS (INOPERANTE)'
    END as descripcion_estado
FROM core.accounts a
WHERE NOT EXISTS (
    SELECT 1 
    FROM core.transactions t 
    WHERE t.account_id = a.account_id
)
ORDER BY a.account_number;
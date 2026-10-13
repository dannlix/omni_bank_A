
SELECT 
    (SELECT COUNT(*) FROM core.customers) AS total_customers,
    (SELECT COUNT(*) FROM core.accounts) AS total_accounts,
    (SELECT COUNT(*) FROM core.transactions) AS total_transactions;

SELECT 
    t.transaction_id,
    c.first_name,
    c.last_name,
    a.account_number,
    t.tx_type,
    t.amount
FROM core.transactions t
INNER JOIN core.accounts a ON t.account_id = a.account_id
INNER JOIN core.customers c ON a.customer_id = c.customer_id
ORDER BY t.tx_timestamp, t.transaction_id;

SELECT 
    a.account_number,
    a.is_active,
    CASE 
        WHEN a.is_active = false THEN 'CUENTA DESACTIVADA SIN USO'
        ELSE 'CUENTA ACTIVA SIN MOVIMIENTOS REGISTRADOS'
    END AS etiqueta_presentacion
FROM core.accounts a
LEFT JOIN core.transactions t ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL
ORDER BY a.account_number;

SELECT 
    c.email,
    a.account_number,
    a.balance
FROM core.customers c
LEFT JOIN core.accounts a ON c.customer_id = a.customer_id AND a.balance > 0
ORDER BY c.email;
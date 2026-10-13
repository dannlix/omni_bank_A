WITH 
tx_summary AS (
    SELECT 
        account_id,
        COUNT(transaction_id) AS total_movimientos,
        SUM(amount) AS volumen_bruto_registrado
    FROM core.transactions
    GROUP BY account_id
),

active_accounts_metrics AS (
    SELECT 
        a.account_id,
        a.customer_id,
        a.account_number,
        a.currency,
        a.account_type,
        a.balance,
        COALESCE(s.total_movimientos, 0) AS total_movimientos,
        COALESCE(s.volumen_bruto_registrado, 0.00) AS volumen_bruto_registrado
    FROM core.accounts a
    LEFT JOIN tx_summary s ON a.account_id = s.account_id
    WHERE a.is_active = true
)

SELECT 
    m.account_number,
    m.account_type,
    m.currency,
    c.first_name || ' ' || c.last_name AS titular,
    m.total_movimientos,
    m.volumen_bruto_registrado,
    m.balance AS saldo_almacenado,
    CASE 
        WHEN m.total_movimientos = 0 THEN 'SIN ACTIVIDAD'
        WHEN m.total_movimientos BETWEEN 1 AND 2 THEN 'ACTIVIDAD MODERADA'
        ELSE 'ALTA ACTIVIDAD'
    END AS banda_actividad
FROM active_accounts_metrics m
INNER JOIN core.customers c ON m.customer_id = c.customer_id
ORDER BY m.account_number;

SELECT COUNT(*) AS total_cuentas_activas 
FROM core.accounts 
WHERE is_active = true;

SELECT SUM(amount) AS volumen_bruto_total_ledger 
FROM core.transactions;
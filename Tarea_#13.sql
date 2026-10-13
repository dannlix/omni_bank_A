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
),

currency_summary AS (
    SELECT 
        currency,
        COUNT(account_id) AS total_cuentas_activas,
        SUM(volumen_bruto_registrado) AS volumen_bruto_total,
        ROUND(AVG(volumen_bruto_registrado), 2) AS volumen_promedio_por_cuenta
    FROM active_accounts_metrics
    GROUP BY currency
)

SELECT 
    currency,
    total_cuentas_activas,
    volumen_bruto_total,
    volumen_promedio_por_cuenta
FROM currency_summary
ORDER BY currency;

SELECT COUNT(*) AS control_cuentas_activas 
FROM core.accounts 
WHERE is_active = true;

SELECT SUM(amount) AS control_volumen_bruto_total 
FROM core.transactions;

SELECT 
    (SELECT SUM(amount) FROM core.transactions)::NUMERIC / 
    (SELECT COUNT(*) FROM core.accounts WHERE is_active = true)::NUMERIC AS control_promedio_por_cuenta;
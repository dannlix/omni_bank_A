
SELECT 
    account_type,
    COUNT(*) AS total_cuentas_activas,
    SUM(balance) AS saldo_total_almacenado,
    MIN(balance) AS saldo_minimo_almacenado,
    MAX(balance) AS saldo_maximo_almacenado,
    AVG(balance) AS saldo_promedio_almacenado
FROM core.accounts
WHERE is_active = true
GROUP BY account_type
ORDER BY saldo_total_almacenado DESC, account_type ASC;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(t.transaction_id) AS total_movimientos,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto_registrado
FROM core.customers c
LEFT JOIN core.accounts a ON c.customer_id = a.customer_id
LEFT JOIN core.transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(t.transaction_id) >= 2 OR COALESCE(SUM(t.amount), 0) > 100.00
ORDER BY volumen_bruto_registrado DESC, c.email ASC;

SELECT 
    account_id,
    COUNT(transaction_id) AS eventos_por_cuenta,
    SUM(amount) AS volumen_por_cuenta
FROM core.transactions
GROUP BY account_id
ORDER BY volumen_por_cuenta DESC;

SELECT 
    SUM(balance) AS control_saldo_total_activo
FROM core.accounts
WHERE is_active = true;
SELECT 
    a.account_number,
    a.account_type,
    c.first_name || ' ' || c.last_name AS titular,
    a.balance AS saldo_almacenado,
    a.is_active
FROM core.accounts a
INNER JOIN core.customers c ON a.customer_id = c.customer_id
WHERE a.is_active = true
  AND NOT EXISTS (
      SELECT 1 
      FROM core.transactions t 
      WHERE t.account_id = a.account_id 
        AND t.tx_type = 'DEPOSIT'
  )
ORDER BY a.account_number;

SELECT COUNT(*) AS total_cuentas_activas 
FROM core.accounts 
WHERE is_active = true;

SELECT COUNT(*) AS cuentas_activas_con_deposito 
FROM core.accounts a
WHERE a.is_active = true
  AND EXISTS (
      SELECT 1 
      FROM core.transactions t 
      WHERE t.account_id = a.account_id 
        AND t.tx_type = 'DEPOSIT'
  );
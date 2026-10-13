SELECT 
    a.account_number,
    a.account_type,
    a.is_active,
    a.balance
FROM core.accounts a
WHERE a.is_active = true
  AND NOT EXISTS (
      SELECT 1 
      FROM core.transactions t 
      WHERE t.account_id = a.account_id
  )
ORDER BY a.account_number;

SELECT 
    a.account_number,
    a.account_type,
    a.is_active,
    a.balance
FROM core.accounts a
WHERE NOT EXISTS (
      SELECT 1 
      FROM core.transactions t 
      WHERE t.account_id = a.account_id 
        AND t.tx_type = 'DEPOSIT'
  )
ORDER BY a.account_number;

SELECT 
    'NOT IN con NULL' AS tecnica,
    10 NOT IN (SELECT val FROM (VALUES (1), (2), (NULL)) AS sub(val)) AS resultado_evaluacion;

SELECT 
    'NOT EXISTS con NULL' AS tecnica,
    NOT EXISTS (
        SELECT 1 
        FROM (VALUES (1), (2), (NULL)) AS sub(val) 
        WHERE sub.val = 10
    ) AS resultado_evaluacion;
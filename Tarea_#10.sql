
SELECT 
    AVG(val) AS promedio_ignorando_nulos,
    COUNT(val) AS denominador_con_conteo_valido,
    COUNT(*) AS total_filas_evaluadas
FROM (
    VALUES (10000.00), (0.00), (0.00), (NULL::NUMERIC)
) AS sample_data(val);

SELECT 
    AVG(COALESCE(val, 0.00)) AS promedio_convertido_a_cero,
    COUNT(val) AS valores_no_nulos_originales,
    COUNT(*) AS denominador_total_incluyendo_ceros
FROM (
    VALUES (10000.00), (0.00), (0.00), (NULL::NUMERIC)
) AS sample_data(val);

SELECT 
    a.account_id,
    a.account_number,
    a.balance AS saldo_almacenado,
    COUNT(t.transaction_id) AS numero_movimientos,
    COALESCE(SUM(t.amount), 0.00) AS volumen_bruto_registrado
FROM core.accounts a
LEFT JOIN core.transactions t ON a.account_id = t.account_id
WHERE a.account_type = 'CREDIT' 
  AND a.is_active = true
GROUP BY a.account_id, a.account_number, a.balance
HAVING COUNT(t.transaction_id) = 0 OR COALESCE(SUM(t.amount), 0.00) >= 300.00
ORDER BY a.account_number;
SELECT 
    COUNT(*) AS total_cuentas,
    SUM(CASE WHEN is_active = false THEN 1 ELSE 0 END) AS cuentas_desactivadas,
    ROUND(
        (SUM(CASE WHEN is_active = false THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)::NUMERIC) * 100.00, 
        2
    ) AS porcentaje_desactivadas
FROM core.accounts;

SELECT 
    transaction_id,
    account_id,
    tx_type,
    amount AS importe_original,
    tx_timestamp AS marca_temporal_original,
    (tx_timestamp + INTERVAL '15 days') AS fecha_revision_calculada,
    AGE(TIMESTAMP '2026-10-01 00:00+00', tx_timestamp) AS antiguedad_al_corte
FROM core.transactions
WHERE tx_timestamp < TIMESTAMP '2026-10-01 00:00+00'
ORDER BY tx_timestamp, transaction_id;
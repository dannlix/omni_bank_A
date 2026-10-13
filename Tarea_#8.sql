Reference Solution
SELECT transaction_id,account_id,tx_type,amount,
       COALESCE(NULLIF(TRIM(description),''),'SIN DESCRIPCIÓN') AS visible_description
FROM core.transactions
WHERE (tx_type IN ('TRANSFER','WITHDRAWAL') AND amount>=100)
   OR (tx_type='WITHDRAWAL' AND NULLIF(TRIM(description),'') IS NULL)
ORDER BY amount DESC,transaction_id;
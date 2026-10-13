SELECT 
    (SELECT COUNT(*) FROM core.customers) AS count_customers,
    (SELECT COUNT(*) FROM core.accounts) AS count_accounts,
    (SELECT COUNT(*) FROM core.transactions) AS count_transactions,
    (SELECT COUNT(*) FROM core.customers) 
    * (SELECT COUNT(*) FROM core.accounts) 
    * (SELECT COUNT(*) FROM core.transactions) AS total_cartesian_product;

SELECT 
    c.email,
    a.account_number,
    t.tx_type,
    t.amount,
    t.tx_timestamp
FROM core.transactions t
INNER JOIN core.accounts a ON t.account_id = a.account_id
INNER JOIN core.customers c ON a.customer_id = c.customer_id
WHERE c.is_active = true
  AND t.amount >= 100.00
ORDER BY t.tx_timestamp, t.transaction_id;
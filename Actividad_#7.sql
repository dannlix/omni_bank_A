
INSERT INTO core.customers (customer_id, first_name, last_name, email, phone, tax_id, birth_date)
VALUES 
    ('11111111-1111-1111-1111-111111111111', 'John', 'Doe', 'john.doe@email.com', '555-0100', 'TAX-100', '1985-04-12'),
    ('22222222-2222-2222-2222-222222222222', 'Jane', 'Smith', 'jane.smith@email.com', '555-0200', 'TAX-200', '1990-08-25'),
    ('33333333-3333-3333-3333-333333333333', 'Alice', 'Johnson', 'alice.j@email.com', '555-0300', 'TAX-300', '1978-11-05')
ON CONFLICT (email) DO NOTHING;


INSERT INTO core.accounts (account_id, customer_id, account_number, account_type, balance, credit_limit)
VALUES 
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'ACCT-1001', 'CHECKING', 5000.00, 0.00),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', 'ACCT-2001', 'SAVINGS', 15000.00, 0.00),
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', 'ACCT-3001', 'CREDIT', 0.00, 10000.00)
ON CONFLICT (account_number) DO NOTHING;


INSERT INTO core.transactions (transaction_id, from_account_id, to_account_id, amount, transaction_type, status)
VALUES 
    ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 150.00, 'TRANSFER', 'COMPLETED'),
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 300.00, 'TRANSFER', 'COMPLETED'),
    ('ffffffff-ffff-ffff-ffff-ffffffffffff', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL, 50.00, 'FEE', 'COMPLETED')
ON CONFLICT (transaction_id) DO NOTHING;


UPDATE core.accounts 
SET balance = balance - 50.00 
WHERE account_number = 'ACCT-1001'
RETURNING account_number, balance;
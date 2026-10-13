
CREATE SCHEMA IF NOT EXISTS core;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE core.customers (
    customer_id UUID DEFAULT gen_random_uuid(),
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(30),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT pk_customers_customer_id PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email UNIQUE (email)
);

CREATE TABLE core.accounts (
    account_id UUID DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    account_number VARCHAR(34) NOT NULL, -- Estándar de cuenta / IBAN
    tipo_moneda VARCHAR(3) NOT NULL DEFAULT 'USD', -- Estándar ISO 4217 (USD, EUR, MXN, etc.)
    tipo_cuenta VARCHAR(50) NOT NULL, -- Ahorros, Corriente, Nómina, etc.
    balance NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT pk_accounts_account_id PRIMARY KEY (account_id),
    CONSTRAINT uq_accounts_account_number UNIQUE (account_number),
    CONSTRAINT fk_accounts_customer_id FOREIGN KEY (customer_id) 
        REFERENCES core.customers(customer_id) 
        ON DELETE RESTRICT,
    CONSTRAINT chk_accounts_balance_non_negative CHECK (balance >= 0.00)
);

CREATE TABLE core.loans (
    loan_id UUID DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    amount NUMERIC(15, 2) NOT NULL,
    interest_rate NUMERIC(5, 4) NOT NULL, -- Porcentaje exacto (ej. 0.1250 para 12.5%)
    term_months INT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING', -- PENDING, APPROVED, ACTIVE, CLOSED, DEFAULTED
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_loans_loan_id PRIMARY KEY (loan_id),
    CONSTRAINT fk_loans_customer_id FOREIGN KEY (customer_id) 
        REFERENCES core.customers(customer_id) 
        ON DELETE RESTRICT,
    CONSTRAINT chk_loans_amount_positive CHECK (amount > 0.00),
    CONSTRAINT chk_loans_interest_rate_non_negative CHECK (interest_rate >= 0.00),
    CONSTRAINT chk_loans_term_months_positive CHECK (term_months > 0)
);

CREATE TABLE core.transactions (
    transaction_id UUID DEFAULT gen_random_uuid(),
    account_id UUID NOT NULL,
    amount NUMERIC(15, 2) NOT NULL,
    tipo_transaccion VARCHAR(50) NOT NULL, -- DEPOSIT, WITHDRAWAL, TRANSFER, PAYMENT
    reference_number VARCHAR(100),
    transaction_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_transactions_transaction_id PRIMARY KEY (transaction_id),
    CONSTRAINT fk_transactions_account_id FOREIGN KEY (account_id) 
        REFERENCES core.accounts(account_id) 
        ON DELETE RESTRICT,
    CONSTRAINT chk_transactions_amount_nonzero CHECK (amount <> 0.00)
);

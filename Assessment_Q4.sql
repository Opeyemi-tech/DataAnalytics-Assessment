WITH customer_tenure AS (
    -- Calculate account tenure in months
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS customer_name,
        ROUND(DATEDIFF(CURDATE(), created_on) / 30) AS tenure_months
    FROM users_customuser
),
transaction_data AS (
    -- Calculate total transactions and average transaction profit per customer
    SELECT 
        owner_id AS customer_id,
        COUNT(id) AS total_transactions,
        AVG(amount) * 0.001 AS avg_profit_per_transaction  -- Profit = 0.1% of average transaction amount
    FROM savings_savingsaccount
    GROUP BY owner_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.tenure_months,
    t.total_transactions,
    ROUND((t.total_transactions / c.tenure_months) * 12 * t.avg_profit_per_transaction, 2) AS estimated_clv
FROM customer_tenure c
JOIN transaction_data t ON c.customer_id = t.customer_id
ORDER BY estimated_clv DESC;
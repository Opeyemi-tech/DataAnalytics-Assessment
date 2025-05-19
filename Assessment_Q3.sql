WITH last_transactions AS (
    -- Get last transaction date for each savings account
    SELECT 
        owner_id,
        plan_id AS id,  
        'Savings' AS type,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY owner_id, plan_id

    UNION ALL

    -- Get last withdrawal date for each investment plan
    SELECT 
        owner_id,
        id,  
        'Investment' AS type,
        MAX(withdrawal_date) AS last_transaction_date
    FROM plans_plan
    WHERE withdrawal_date IS NOT NULL
    GROUP BY owner_id, id
)
SELECT 
    id AS plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM last_transactions
WHERE DATEDIFF(CURDATE(), last_transaction_date) > 365
ORDER BY inactivity_days DESC;
WITH monthly_transactions AS (
    -- Count transactions per customer per month
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,  -- Extracting year-month format
        COUNT(id) AS transaction_count                                -- Number of transactions per customer per month
    FROM 
		savings_savingsaccount
    GROUP BY 
		owner_id, 
        transaction_month
),
customer_avg_transactions AS (
    -- Calculate the average number of transactions per month for each customer
    SELECT 
        owner_id, 
        AVG(transaction_count) AS avg_transactions_per_month
    FROM 
		monthly_transactions
    GROUP BY owner_id
),
customer_frequency AS (
    -- Categorizing the customers based on transaction frequency
    SELECT
        owner_id,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
		customer_avg_transactions
)
-- Finally, the Count of customers in each category and their overall transaction averages
SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM 
	customer_frequency
JOIN customer_avg_transactions 
USING (owner_id)
GROUP BY 
	frequency_category
ORDER BY 
	avg_transactions_per_month DESC;
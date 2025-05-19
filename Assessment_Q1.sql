-- Step 1: Create a temporary table to store aggregated savings account data.
CREATE TEMPORARY TABLE temp_savings AS
SELECT 
    owner_id,                                      -- Unique identifier for each user
    COUNT(DISTINCT id) AS savings_count,          -- Total number of distinct savings accounts owned by the user
    SUM(new_balance) AS total_savings             -- Sum of balances across all funded savings accounts
FROM 
	savings_savingsaccount
WHERE new_balance > 0                             -- Consider only accounts with a positive balance
GROUP BY owner_id;                                -- Group data by user to get individual savings totals

-- Step 2: Create a temporary table to store aggregated investment plan data.
CREATE TEMPORARY TABLE temp_investments AS
SELECT 
    owner_id,                                      -- Unique identifier for each user
    COUNT(DISTINCT id) AS investment_count,       -- Total number of distinct investment plans owned by the user
    SUM(amount) AS total_investments              -- Sum of deposits across all funded investment plans
FROM
	plans_plan
WHERE amount > 0                                  -- Consider only investment plans with a positive amount
GROUP BY owner_id                                 -- Group data by user to get individual investment totals
ORDER BY investment_count DESC;                   -- Prioritize users with the highest number of investments

-- Step 3: Retrieve customer financial insights by combining savings and investment data.
SELECT 
    u.id AS owner_id,                                            -- Unique identifier for the user
    CONCAT(u.first_name, ' ', u.last_name) AS customer_name,     -- Full name of the user
    s.savings_count,                                             -- Number of funded savings accounts
    i.investment_count,                                          -- Number of funded investment plans
    ROUND((s.total_savings + i.total_investments), 2) AS total_deposit -- Total value of savings + investments, rounded to 2 decimal places
FROM 
	users_customuser u
JOIN temp_savings s 
	ON u.id = s.owner_id                        				-- Match users with their savings data
JOIN temp_investments i 
	ON u.id = i.owner_id                    					-- Match users with their investment data
ORDER BY total_deposit DESC;                                    -- Prioritize high-value customers by total deposit amount
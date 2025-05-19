# DataAnalytics-Assessment-Assessment_Q1.sql
### Assessment_Q1.sql

**Approach**  
To generate a financial profile for each user, I broke the problem into three main steps:

1. **Created a temporary table (`temp_savings`)** to calculate each user's total number of funded savings accounts and the sum of their savings balances.
2. **Created a second temporary table (`temp_investments`)** to compute each user’s total number of funded investment plans and the total invested amount.
3. **Joined the user table with both temporary tables** to consolidate savings and investment data for each user. I then calculated the **total deposit** (sum of savings and investments) and ranked users in descending order.

I am convinced that this modular strategy improves readability and makes the logic easier to troubleshoot especially when one large query using multiple subqueries became complex and couldn't run to on time

**Challenges**  
Initially, I considered writing one large query using multiple subqueries, but it quickly became complex and couldn't run to on time. So, I considered using temporary tables to break the task into digestible steps, which simplified debugging and made the final result cleaner and more efficient.


# DataAnalytics-Assessment-Assessment_Q2.sql
## Assessment_Q2.sql

### Approach  
This query analyzes customer engagement based on their transaction frequency over time. I used three CTEs to structure the solution:

1. **`monthly_transactions`**: Aggregated the number of transactions per customer, per month, using `DATE_FORMAT` to group by year and month.
2. **`customer_avg_transactions`**: Calculated each customer’s average number of transactions per month.
3. **`customer_frequency`**: Used a `CASE` statement to categorize each customer as:
   - **High Frequency**: ≥ 10 transactions/month
   - **Medium Frequency**: 3–9 transactions/month
   - **Low Frequency**: < 3 transactions/month

Finally, I summarized the number of customers in each category and their corresponding average transaction counts.

### Challenges  
The most challenging part was deciding what approach to use to get the transaction frequency.


# -DataAnalytics-Assessment-Assessment_Q3.sql
### Approach  
This query identifies inactive financial accounts (savings or investment plans) that have not had any transactions for over a year.

1. **`last_transactions` CTE**:
   - Extracted the latest `transaction_date` for each savings account.
   - Extracted the latest `withdrawal_date` for each investment plan (ignoring NULLs).
   - Combined both datasets using `UNION ALL` to create a unified list of the latest transaction dates across all account types.

2. **Final Output**:
   - Calculated inactivity using `DATEDIFF(CURDATE(), last_transaction_date)`.
   - Filtered for accounts that have been inactive for more than **365 days**.
   - Returned account ID, owner ID, type (Savings or Investment), and number of inactivity days.
   - Ordered results by `inactivity_days` in descending order to highlight the longest-inactive accounts.

### Challenges  
The key challenge was aligning transaction activity from two different tables (`savings_savingsaccount` and `plans_plan`) with different date fields. I solved this by standardizing column names and data formats in the `UNION ALL` and tagging each record with a type label. Ensuring NULL withdrawal dates were excluded was essential to maintain accurate inactivity tracking.


# DataAnalytics-Assessment-Assessment_Q4.sql

## Assessment_Q4.sql

### Approach  
This query estimates **Customer Lifetime Value (CLV)** by calculating each customer’s transaction activity, tenure, and profit contribution.

1. **`customer_tenure` CTE**:  
   - Calculated the number of months since account creation using `DATEDIFF` divided by 30.
   - Extracted customer ID and full name.

2. **`transaction_data` CTE**:  
   - Counted the total number of transactions per customer.
   - Estimated average profit per transaction as 0.1% of the average transaction amount (`AVG(amount) * 0.001`).

3. **Final Calculation**:  
   - Merged both datasets on customer ID.
   - Estimated CLV using the formula:  
     \[
     \text{CLV} = \left(\frac{\text{total\_transactions}}{\text{tenure\_months}}\right) \times 12 \times \text{avg\_profit\_per\_transaction}
     \]
   - Sorted results in descending order to identify high-value customers.

### Challenges  
The main challenge was CLV was alien to me, I had to do a little research and come up with my best. I used a simplified annualized formula that balances precision with interpretability. I also ensured division by tenure was safe by avoiding zero or extremely small values during testing. I just hope i am right.

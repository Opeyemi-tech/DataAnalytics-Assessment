# DataAnalytics-Assessment-Assessment_Q1.sql
### Assessment_Q1.sql

**Approach**  
To generate a financial profile for each user, I broke the problem into three main steps:

1. **Created a temporary table (`temp_savings`)** to calculate each user's total number of funded savings accounts and the sum of their savings balances.
2. **Created a second temporary table (`temp_investments`)** to compute each user’s total number of funded investment plans and the total invested amount.
3. **Joined the user table with both temporary tables** to consolidate savings and investment data for each user. I then calculated the **total deposit** (sum of savings and investments) and ranked users in descending order.

This modular strategy improves readability and makes the logic easier to troubleshoot.

**Challenges**  
Initially, I considered writing one large query using multiple subqueries, but it quickly became complex and couldn't run to on time. So, I considered using temporary tables to break the task into digestible steps, which simplified debugging and made the final result cleaner and more efficient.

CREATE OR REPLACE VIEW ActiveUsers_vw --- Active users in this month
AS
SELECT 
    TO_CHAR(creationdate, 'YYYY-MM') AS registration_month,
    COUNT(*) AS active_users
FROM 
    db_admin.customer
GROUP BY 
    TO_CHAR(creationdate, 'YYYY-MM')
ORDER BY 
    TO_CHAR(creationdate, 'YYYY-MM');
SELECT * FROM ActiveUsers_vw;
       
       
CREATE or REPLACE VIEW RetentionRate_vw --- Retention Rate of last month
AS
SELECT 
  TRUNC(s1.startdate, 'MONTH') AS month,
  COUNT(DISTINCT s1.customerid) AS starting_customers,
  COUNT(DISTINCT s2.customerid) AS returning_customers,
  CEIL(COUNT(DISTINCT s2.customerid) / COUNT(DISTINCT s1.customerid)*100) AS retention_rate
FROM db_admin.purchase s1
LEFT JOIN db_admin.purchase s2 ON s2.customerid = s1.customerid
AND s2.startdate > s1.startdate
AND s2.startdate <= Add_months(s1.startdate, 1)
GROUP BY TRUNC(s1.startdate, 'MONTH')
order by returning_customers desc;
SELECT * FROM RetentionRate_vw;
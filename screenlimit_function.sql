


CREATE OR REPLACE TYPE screen_limit_row AS OBJECT(
  customerid NUMBER,
  customername VARCHAR(35),
  planname VARCHAR(50),
  screenlimit NUMBER
);

CREATE OR REPLACE FUNCTION get_screenlimit_by_customer(customer_id NUMBER)
RETURN screen_limit_row AS
  screenlimit_info screen_limit_row;
BEGIN
 Select screen_limit_row(p.customerid,c.userfirstname,s.planname,s.screenlimit)
 into screenlimit_info
 from purchase p
 join subscription_plan s
 on p.planid = s.planid
 join customer c
 on c.customerid = p.customerid
 where p.customerid = customer_id; 
RETURN screenlimit_info;
END;

SELECT get_screenlimit_by_customer(25).customerid, get_screenlimit_by_customer(25).customername, get_screenlimit_by_customer(25).planname, get_screenlimit_by_customer(25).screenlimit
FROM dual;



select * from purchase where purchase.customerid = 215
select * from customer where customerid = 215










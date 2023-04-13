CREATE OR REPLACE TRIGGER set_status
AFTER INSERT ON Purchase
FOR EACH ROW
BEGIN
  UPDATE customer c
  SET c.customerstatus = 'active'
  WHERE customerid = c.customerid;
END;



CREATE OR REPLACE FUNCTION auto_renew_plan(plan_id IN NUMBER, customer_id IN NUMBER)
RETURN NUMBER
IS
  purchase_id NUMBER: = MAX(purchaseid);
  start_date DATE := SYSDATE;
  end_date DATE := ADD_MONTHS(SYSDATE, 1);
BEGIN
  INSERT INTO purchse (purchaseid, planid, customerid, startdate, enddate)
  VALUES (purchase_id+1, plan_id, customer_id, start_date, end_date);
  
  COMMIT;
  
  SELECT purchase_id INTO purchase_id FROM DUAL;
  
  RETURN purchase_id;
END;


CREATE OR REPLACE FUNCTION auto_renew_plan(plan_id IN NUMBER, customer_id IN NUMBER)
RETURN NUMBER
IS
  purchase_id NUMBER;
  start_date DATE := SYSDATE;
  end_date DATE := ADD_MONTHS(SYSDATE, 1);
BEGIN
  SELECT MAX(purchaseid) + 1 INTO purchase_id FROM purchase;
  
  INSERT INTO purchase (purchaseid, planid, customerid, startdate, enddate)
  VALUES (purchase_id, plan_id, customer_id, start_date, end_date);
  
  COMMIT;
  
  RETURN (purchase_id);
END;


DECLARE
  new_purchase_id NUMBER;
BEGIN
  new_purchase_id := auto_renew_plan(3, 221); -- replace with your plan_id and customer_id values
END;






INSERT INTO purchase (purchaseid, planid, customerid, startdate, enddate)
  VALUES (601, 3, 221, SYSDATE, ADD_MONTHS(SYSDATE, 1));
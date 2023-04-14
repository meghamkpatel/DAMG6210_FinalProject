

CREATE OR REPLACE TRIGGER update_customer_status
AFTER INSERT OR UPDATE ON purchase
FOR EACH ROW
DECLARE
  v_customer_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_customer_exists
  FROM customer
  WHERE CustomerID = :new.customerID;
  
  IF v_customer_exists > 0 THEN
    UPDATE customer
    SET customerstatus = 'ACTIVE'
    WHERE CustomerID = :new.customerID;
  END IF;
END;
/











CREATE OR REPLACE TRIGGER update_status
AFTER INSERT OR UPDATE ON Purchase
FOR EACH ROW
DECLARE
Nend_date purchase.enddate%type;
status varchar2(10);
BEGIN
SELECT CASE
WHEN MAX(enddate) > SYSDATE THEN 'Active' ELSE 'Inactive' 
END CASE INTO status 
FROM Purchase
WHERE CustomerID = :new.customerID;
UPDATE customer
SET customerstatus = status
WHERE CustomerID = :new.customerID;
End;










CREATE OR REPLACE TRIGGER update_status
AFTER INSERT OR UPDATE ON Purchase
FOR EACH ROW
DECLARE
Nend_date purchase.enddate%type;
BEGIN
SELECT max(enddate) into Nend_date 
FROM Purchase
Where CustomerID = :new.customerID;
IF Nend_date>= sysdate then set customerstatus = ‘Active’
Where CustomerID = :new.customerID;
Else
Update customer
Set customerstatus = ‘Inactive’
Where CustomerID = :new.customerID;
End if;
End;
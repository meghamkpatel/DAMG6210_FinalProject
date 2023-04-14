

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


------------------------------------------------------------------------------------------------------------------------------------------------------------------


--changes the status of the customer upon purchasing a new plan
CREATE OR REPLACE TRIGGER set_status
AFTER INSERT ON Purchase
FOR EACH ROW
BEGIN
  UPDATE customer c
  SET c.customerstatus = 'Active'
  WHERE c.customerid = :NEW.customerid;
END;

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Deletes the rows in watch list whenever an occurance of the same details are added in the watch history table 
CREATE OR REPLACE TRIGGER delete_watchlist_row
AFTER INSERT ON watch_history
FOR EACH ROW
BEGIN
  DELETE FROM watchlist
  WHERE customerid = :NEW.customerid
    AND movieid = :NEW.movieid;
END;


--testing the trigger
/*INSERT INTO watch_history (HistoryID, MovieID, CustomerID, DateWatched)
SELECT MAX(HistoryID) + 1, 57, 109, SYSDATE
FROM watch_history;*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------





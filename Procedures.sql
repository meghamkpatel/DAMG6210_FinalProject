





---1. Add to watchlist

CREATE OR REPLACE PROCEDURE ADD_TO_WATCHLIST(in_movie_id NUMBER, in_customer_id NUMBER) IS
  r_watchlist Watchlist%ROWTYPE;
BEGIN
  -- Check if movie is already in customer watchlist
  SELECT * INTO r_watchlist FROM Watchlist WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;

  IF r_watchlist.CustomerID IS NULL THEN
    -- Movie is not in watchlist, add it
    INSERT INTO Watchlist(CustomerID, MovieID) VALUES (in_customer_id, in_movie_id);
    DBMS_OUTPUT.PUT_LINE('Movie added to watchlist successfully');
  ELSE
    -- Movie is already in watchlist
    DBMS_OUTPUT.PUT_LINE('Movie is already in watchlist');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;



----2. add to download

CREATE OR REPLACE PROCEDURE ADD_TO_DOWNLOAD(in_movie_id NUMBER, in_customer_id NUMBER) IS
	r_download Download%ROWTYPE;
BEGIN
---- check if movie is already in customer download
SELECT * INTO r_download FROM Download WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;

IF r_download.CustomerID IS NULL THEN
    -- Movie is not in download, add it
    INSERT INTO Download(CustomerID, MovieID) VALUES (in_customer_id, in_movie_id);
    DBMS_OUTPUT.PUT_LINE('Downloading');
  ELSE
    -- Movie is already in Download
    DBMS_OUTPUT.PUT_LINE('Movie is already in download list');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;


 ---3. add to favorite

CREATE OR REPLACE PROCEDURE ADD_TO_FAVORITE(in_movie_id NUMBER, in_customer_id NUMBER) IS
	r_favorite Favorite%ROWTYPE;
BEGIN
---- check if movie is already in customer favorite
SELECT * INTO r_favorite FROM Favorite WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;

IF r_favorite.CustomerID IS NULL THEN
    -- Movie is not in favorite, add it
    INSERT INTO Favorite(CustomerID, MovieID) VALUES (in_customer_id, in_movie_id);
    DBMS_OUTPUT.PUT_LINE('Added in favorite list');
  ELSE
    -- Movie is already in favorite list
    DBMS_OUTPUT.PUT_LINE('Movie is already in favorite list');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;



---4. region restriction

CREATE OR REPLACE PROCEDURE REGION_RESTRICTED_MOVIE(in_customer_id IN NUMBER, in_movie_id in NUMBER) IS
  cust_region VARCHAR2(100);
  movie_region VARCHAR2(100);
  var_movie_id number;
BEGIN
    SELECT m.movieid INTO var_movie_id FROM customer c JOIN address a ON a.CustomerID = c.CustomerID JOIN REGION r on r.regionname=a.country
    JOIN   Movie m ON m.movieid = r.movieid  WHERE c.CustomerID = in_customer_id and m.movieid = in_movie_id;

  IF var_movie_id is not null THEN
    DBMS_OUTPUT.PUT_LINE('Play Movie');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Movie is not available in your Region');
  END IF;
END;

----5. add to watch history 

CREATE OR REPLACE PROCEDURE ADD_TO_WATCHHISTORY(in_movie_id NUMBER, in_customer_id NUMBER, in_watchtime Date) IS
  r_movie Watchlist%ROWTYPE;
  var_hisid number;
  
BEGIN
  -- Check if movie is already in customer watchlist
  select max(w.historyid) into var_hisid from watch_history w;

    var_hisid:=var_hisid+1;
    INSERT INTO watch_history(historyid,CustomerID, MovieID,datewatched) VALUES (var_hisid,in_customer_id, in_movie_id,in_watchtime);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;


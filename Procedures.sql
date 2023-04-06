--Procedures
create or replace PROCEDURE CREATE_MOVIE (VARGenre VARCHAR,VARDirectorFirstName VARCHAR,VARDirectorLastName VARCHAR,VARMovieTitle VARCHAR,VARDateOfRelease NUMBER, VARMovieDuration NUMBER,VARMovieDescription VARCHAR,VARRatings FLOAT, VARCountryOrigin VARCHAR)
IS
    VARMAXMOVIEID NUMBER;
    VARGENREID NUMBER;
    VARDIRECTORID NUMBER;

BEGIN
    FOR aRow IN (SELECT GENREID
       FROM GENRE
       WHERE GENRENAME = VARGenre)
    LOOP
        IF aRow.GENREID IS NULL THEN
            SELECT MAX(GENREID)+1 INTO VARGENREID from GENRE;
            INSERT INTO GENRE (GenreID, GenreName) VALUES (VARGENREID, VARGenre);
            DBMS_OUTPUT.PUT_LINE('Genre ' || VARGenre || ' created!');
        END IF;
    END LOOP;
    Select MAX(MOVIEID)+1 into VARMAXMOVIEID from MOVIE;
    SELECT MAX(DIRECTORID)+1 into VARDIRECTORID from DIRECTOR;
    INSERT INTO DIRECTOR VALUES(VARDIRECTORID, VARDirectorFirstName, VARDirectorLastName);
    INSERT INTO MOVIE VALUES(VARMAXMOVIEID,VARGENREID,VARDIRECTORID, VARMovieTitle, VARDateOfRelease,VARMovieDuration, VARMovieDescription, VARRatings, VARCountryOrigin);
    dbms_output.put_line('Movie ' || VARMovieTitle || ' added!');
END;
/
---------------------------------------------------------

create or replace PROCEDURE GET_MY_PROFILE (varusername IN varchar, varpassword in VARCHAR, CustomerName OUT VARCHAR, CustomerEmail OUT VARCHAR, CustomerUserName OUT VARCHAR, CustomerStatus OUT VARCHAR)
IS  
BEGIN
    FOR aRow IN (SELECT CUSTOMERID
       FROM CUSTOMER
       WHERE varusername = USERNAME and varpassword = USERPASSWORD)
    LOOP
        IF aRow.CUSTOMERID IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('oops! username or password does not correct');
        ELSE 
            SELECT userfirstname || ' ' || userlastname, email, username, customerstatus
            INTO CustomerName, CustomerEmail, CustomerUserName, CustomerStatus
            FROM Customer
            WHERE customerid = aRow.CUSTOMERID;   
        END IF;
    END LOOP;
END;
/
---------------------------------------------------------
create or replace PROCEDURE CHANGE_CUSTOMER_DETAIL (varusername IN varchar, varpassword in VARCHAR, varEmail IN varchar, CustomerName OUT VARCHAR, CustomerEmail OUT VARCHAR, CustomerUserName OUT VARCHAR, CustomerStatus OUT VARCHAR)
IS
BEGIN
    FOR aRow IN (SELECT userfirstname || ' ' || userlastname, email, username, customerstatus into CustomerName, CustomerEmail, CustomerUserName, CustomerStatus 
       FROM CUSTOMER
       WHERE varusername = USERNAME and varpassword = USERPASSWORD)
    LOOP
        IF aRow.EMAIL IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('username or password does not exist');
            ELSE IF varEmail is not NULL then
                UPDATE CUSTOMER SET EMAIL = varEmail;
                DBMS_OUTPUT.PUT_LINE('Email changed!');
                ELSE IF varusername is not NULL then
                    UPDATE CUSTOMER SET USERNAME = varUsername;
                    DBMS_OUTPUT.PUT_LINE('Username changed!');
                End IF; 
            END IF;
        END IF;
    END LOOP;
END;
/

create or replace PROCEDURE CREATE_CUSTOMER(vUserFirstName VARCHAR, vUserLastName VARCHAR,vEmail VARCHAR,vDateOfBirth DATE,vGender VARCHAR, vUsername VARCHAR,vUserPassword VARCHAR)
IS
varmaxcustomer number;
BEGIN
    FOR aRow IN (SELECT *
       FROM CUSTOMER
       WHERE Username = vUsername or Email = vEmail)
    LOOP
        IF aRow.customerid IS NULL THEN
            case
                when vEmail = '' or vEmail LIKE '_%@__%.__%' then
                    DBMS_OUTPUT.PUT_LINE('Please enter correct email!');
                when vUserFirstName = '' then
                    DBMS_OUTPUT.PUT_LINE('First name is required');
                when vUserLastName = '' then
                    DBMS_OUTPUT.PUT_LINE('Last name is required');
                when vDATEOFBIRTH = '' then
                    DBMS_OUTPUT.PUT_LINE('Birthday is required');
                when vGENDER = '' and vGENDER not in ('MALE', 'FEMALE', 'OTHER') then
                    DBMS_OUTPUT.PUT_LINE('Gender is required');
                when vUsername = '' then
                    DBMS_OUTPUT.PUT_LINE('Username is required');
                when vUserpassword = '' then
                    DBMS_OUTPUT.PUT_LINE('Password is required!');
                else     
                    SELECT MAX(customerid+1) into varmaxcustomer from customer;
                    INSERT INTO CUSTOMER VALUES(varmaxcustomer, vUserFirstName, vUserLastName,vEmail, vDateOfBirth, vGender, vUsername, vUserPassword,'NOT ACTIVE', sysdate);
                    DBMS_OUTPUT.PUT_LINE('Customer profile created!');
            END CASE;
        end if;
    END LOOP;  
END;
/

----ADD A MOVIE TO WATCHLIST
------------------------------------------------------------------------------ toggle
CREATE OR REPLACE PROCEDURE TOGGLE_WATCHLIST(in_movie_id NUMBER, in_customer_id NUMBER) IS
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
    DELETE FROM Watchlist WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
    DBMS_OUTPUT.PUT_LINE('Movie is removed from watchlist');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE TOGGLE_DOWNLOAD(in_movie_id NUMBER, in_customer_id NUMBER) IS
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
    DELETE FROM Download WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
    DBMS_OUTPUT.PUT_LINE('Movie is removed from download list');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
---------------------------------------------------------------------------------------------- change this to toggle from add to remove
CREATE OR REPLACE PROCEDURE TOGGLE_FAVORITE(in_movie_id NUMBER, in_customer_id NUMBER) IS
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
    delete from Favorite WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
    DBMS_OUTPUT.PUT_LINE('Movie is removed from favorite list');
END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/
--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE REGION_RESTRICTED_MOVIE(in_customer_id IN NUMBER, in_movie_id in NUMBER) IS
  cust_region VARCHAR2(100);
  movie_region VARCHAR2(100);
  var_movie_id number;
BEGIN
    SELECT m.movieid INTO var_movie_id FROM customer c JOIN address a ON a.CustomerID = c.CustomerID JOIN REGION r on r.regionname=a.country
    JOIN   Movie m ON m.movieid = r.movieid  WHERE c.CustomerID = in_customer_id and m.movieid = in_movie_id;

  IF var_movie_id is not null THEN
    INSERT INTO watch_history values((select max(historyid)+1 from watch_history), in_movie_id, in_customer_id, sysdate());
    DBMS_OUTPUT.PUT_LINE('Play Movie');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Movie is not available in your Region');
  END IF;
END;
/
-------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ADD_TO_WATCHHISTORY(in_movie_id NUMBER, in_customer_id NUMBER, in_watchtime Date) IS
  r_movie Watch_history%ROWTYPE;
  var_hisid number;
  r_list Watchlist%ROWTYPE;
  
BEGIN
    SELECT * INTO r_movie FROM Watch_history WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
    IF r_movie.CustomerID IS NULL THEN
        -- Movie is not in download, add it
        select max(w.historyid) into var_hisid from watch_history w;
        var_hisid:=var_hisid+1;
        INSERT INTO watch_history(historyid,CustomerID, MovieID,datewatched) VALUES (var_hisid,in_customer_id, in_movie_id,in_watchtime);
        DBMS_OUTPUT.PUT_LINE('Playing...');
        -- check if movie was in watchlist and remove it
        SELECT * INTO r_list FROM Watchlist WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        IF r_list.CustomerID IS NULL THEN
            delete from watchlist where MovieID = in_movie_id AND CustomerID = in_customer_id;
        END IF;
    ELSE
        -- Movie is already in Download
        Update watch_history set datewatched = in_watchtime WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DBMS_OUTPUT.PUT_LINE('Starting from where we left off..');
    END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
-------------------------------------------------------------------------------------------------------------
create or replace PROCEDURE Add_Address(vEmail VARCHAR, vAddress1 VARCHAR, vAddress2 VARCHAR, vCity VARCHAR, vState VARCHAR, vCountry VARCHAR, vPincode VARCHAR)
IS
    r_customer customer%ROWTYPE;
    varmaxcustomer number;
BEGIN
---first find customer
select * into r_customer from customer where email = vEmail;
if r_customer.customerid is null then 
    DBMS_OUTPUT.PUT_LINE('Please create a customer profile first.');
else 
---check if customer already has address
    --if yes update addess
    --if no create new address
    FOR aRow IN (SELECT *
       FROM ADDRESS
       WHERE customerid = r_customer.customerid)
    LOOP
    case
        when vEmail = '' then
            DBMS_OUTPUT.PUT_LINE('Customer not found');
        when vAddress1 = '' then
            DBMS_OUTPUT.PUT_LINE('Address1 is required');
        when vAddress2 = '' then
            DBMS_OUTPUT.PUT_LINE('Address2 is required');
        when vCity = '' then
            DBMS_OUTPUT.PUT_LINE('City is required');
        when vState = '' then
            DBMS_OUTPUT.PUT_LINE('State is required');
        when vCountry = '' then
            DBMS_OUTPUT.PUT_LINE('Country is required');
        when vPincode = '' then
            DBMS_OUTPUT.PUT_LINE('Pincode is required');
        END CASE;
        IF aRow.customerid IS NULL THEN -- creating new address
            INSERT INTO ADDRESS VALUES(aRow.customerid, vAddress1, vAddress2,vCity, vState, vCountry, vPincode);
            DBMS_OUTPUT.PUT_LINE('Address created!');
        ELSE 
            UPDATE ADDRESS SET Address1 = vAddress1, Address2 = Address2, City = vCity, State = vState, Country = vCountry, Pincode = vPincode WHERE customerid = aRow.customerid;
        end if;
    END LOOP; 
END IF;
END;
---------------------------------------------------------------
CREATE or REPLACE PROCEDURE ADD_SUBTITLE(vMovieName VARCHAR, vWords VARCHAR, vLang VARCHAR)
IS
    r_movie movie%ROWTYPE;
    vmaxsubid number;
BEGIN
---first find movie
select * into r_movie from movie where movietitle = vMovieName;
if r_movie.movieid is null then 
    DBMS_OUTPUT.PUT_LINE('Please add a movie first.');
else 
---check if movie already has subtitle for language
    --if yes update text
    --if no create new subtitle
    FOR aRow IN (SELECT *
       FROM subtitles
       WHERE movieid = r_movie.movieid and language = vLang)
    LOOP
    case
        when vMovieName = '' then
            DBMS_OUTPUT.PUT_LINE('Movie not found');
        when vWords = '' then
            DBMS_OUTPUT.PUT_LINE('Text is required');
        when vLang = '' then
            DBMS_OUTPUT.PUT_LINE('Language is required');
        END CASE;
        select max(subtitlesid)+1 into vmaxsubid from subtitles;
        IF aRow.subtitlesid IS NULL THEN -- creating new subtitle
            INSERT INTO Subtitles VALUES(vmaxsubid, vMovieName, vWords,vLang);
            DBMS_OUTPUT.PUT_LINE('Subtitle added!');
        ELSE 
            UPDATE Subtitles SET Text = vWords WHERE subtitlesid = aRow.subtitlesid;
            DBMS_OUTPUT.PUT_LINE('Subtitle updated!');
        end if;
    END LOOP; 
END IF;
END;
/
--------------------------------------------------------------------------------
CREATE or REPLACE PROCEDURE ADD_ACTOR(vfirstname VARCHAR, vlastname VARCHAR)
IS
    r_actor actor%ROWTYPE;
    vmaxactor number;
BEGIN
    ---first check if actor name exists
    select * into r_actor from actor where ACTORFIRSTNAME = vfirstname and ACTORLASTNAME = vlastname;
    if r_actor.actorid is not null then
        DBMS_OUTPUT.PUT_LINE('Actor exists');
    else
        select max(actorid)+1 into vmaxactor from actor;
        INSERT INTO ACTOR VALUES(vmaxactor, vfirstname, vlastname);
        DBMS_OUTPUT.PUT_LINE('Actor added!');
    end if;
END;
/
------------------------------------------------------------------------------------------------
CREATE or REPLACE PROCEDURE ADD_SUBSCRIPTION_PLAN(vplanname VARCHAR, vplandescription VARCHAR, vscreenlimit NUMBER)
IS
    r_plan subscription_plan%ROWTYPE;
    vmaxplan number;
BEGIN
    ---first check if plan exists
    select * into r_plan from subscription_plan where planname = vplanname;
    
    if r_plan.planid is not null then
        DBMS_OUTPUT.PUT_LINE('Plan already exists.');
    else
        select max(planid)+1 into vmaxplan from subscription_plan;
        INSERT INTO subscription_plan VALUES(vmaxplan, vplanname, vplandescription, vscreenlimit);
        DBMS_OUTPUT.PUT_LINE('Plan added!');
    end if;
END;
/
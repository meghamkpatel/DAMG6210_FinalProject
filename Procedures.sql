--Procedures
create or replace PROCEDURE CREATE_MOVIE (
    VARGenre genre.genrename%type,
    VARDirectorFirstName director.DirectorFirstName%type,
    VARDirectorLastName director.DirectorLastName%type,
    VARMovieTitle movie.movietitle%type,
    VARDateOfRelease movie.dateofrelease%type,
    VARMovieDuration movie.movieduration%type,
    VARMovieDescription movie.moviedescription%type,
    VARRatings movie.ratings%type,
    VARCountryOrigin movie.countryorigin%type)
IS
    VARMAXMOVIEID NUMBER;
    VARGENREID NUMBER;
    VARDIRECTORID NUMBER;

BEGIN
    begin 
        select genreid into VARGENREID from genre where lower(VARGenre) = lower(genrename);
    exception
        when no_data_found then
            INSERT INTO GENRE (GenreID, GenreName) VALUES (genre_seq.nextval, VARGenre);
            VARGENREID := genre_seq.nextval;
    end;

    begin 
        select directorid into VARDIRECTORID from director where lower(VARDirectorFirstName) = lower(DirectorFirstName) and lower(VARDirectorLastName) = lower(DirectorLastName);
    exception
        when no_data_found then
            INSERT INTO director VALUES (director_seq.nextval, VARDirectorFirstName, VARDirectorLastName);
            VARDIRECTORID := director_seq.nextval;
    end;
    
    begin 
        select movieid into VARMAXMOVIEID from movie where lower(VARMovieTitle) = lower(movietitle) and lower(VARDateOfRelease) = lower(DateOfRelease);
            dbms_output.put_line('Movie ' || VARMovieTitle || ' already exisits!');
    exception
        when no_data_found then
            INSERT INTO MOVIE VALUES(movie_seq.nextval,VARGENREID,VARDIRECTORID, VARMovieTitle, VARDateOfRelease,VARMovieDuration, VARMovieDescription, VARRatings, VARCountryOrigin);
            dbms_output.put_line('Movie ' || VARMovieTitle || ' added!');
    end;
EXCEPTION
 when others then
    dbms_output.put_line(sqlerrm);
END;
/

--------------------------------------------------------- 
create or replace PROCEDURE CHANGE_CUSTOMER_DETAIL (
    varusername customer.username%type, 
    varpassword customer.userpassword%type, 
    varEmail customer.email%type)
IS
    VARUSER CUSTOMER%rowtype;
BEGIN
    begin 
        select * into VARUSER from customer where lower(varusername) = lower(username);
        if lower(varpassword) <> lower(VARUSER.userpassword) then
            DBMS_OUTPUT.PUT_LINE('Incorrect password');
        else 
            IF varEmail is not NULL then
                UPDATE CUSTOMER SET EMAIL = varEmail where customerid = VARUSER.customerid;
                DBMS_OUTPUT.PUT_LINE('Email changed!');
                ELSE IF varusername is not NULL then
                    UPDATE CUSTOMER SET USERNAME = varUsername;
                    DBMS_OUTPUT.PUT_LINE('Username changed!');
                End IF; 
            end if;
        end if;
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('User not found.');
    end;
EXCEPTION
 when others then
    dbms_output.put_line(sqlerrm);
END;
/
---------------------------------------------------------------------------------------------------------
create or replace PROCEDURE CREATE_CUSTOMER(
    vUserFirstName customer.userfirstname%type, 
    vUserLastName customer.userlastname%type,
    vEmail customer.email%type,
    vDateOfBirth customer.dateofbirth%type,
    vGender customer.gender%type, 
    vUsername customer.username%type,
    vUserPassword customer.userpassword%type)
IS
varcustomerid number;
BEGIN
    begin 
        select customerid into varcustomerid from customer where lower(vEmail) = lower(email) or lower(vUsername) = lower(username);
        DBMS_OUTPUT.PUT_LINE('Email or username is already in use. Please try another.');        
    exception
        when no_data_found then
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
                    INSERT INTO CUSTOMER VALUES(customer_seq.nextval, vUserFirstName, vUserLastName,vEmail, vDateOfBirth, vGender, vUsername, vUserPassword,'NOT ACTIVE', sysdate);
                    DBMS_OUTPUT.PUT_LINE('Customer profile created! Welcome ' || vUserFirstName || ' ' || vUserLastName);
            END CASE;
    end;
END;
/

----ADD A MOVIE TO WATCHLIST
------------------------------------------------------------------------------ toggle
CREATE OR REPLACE PROCEDURE TOGGLE_WATCHLIST(
    in_movie_id watchlist.movieid%type,
    in_customer_id watchlist.customerid%type)
IS
  r_watchlist Watchlist%ROWTYPE;
BEGIN
  -- Check if movie is already in customer watchlist
    begin 
        SELECT * INTO r_watchlist FROM Watchlist WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DELETE FROM Watchlist WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DBMS_OUTPUT.PUT_LINE('Movie is removed from watchlist');
    exception
        when no_data_found then
            INSERT INTO Watchlist(CustomerID, MovieID) VALUES (in_customer_id, in_movie_id);
            DBMS_OUTPUT.PUT_LINE('Movie added to watchlist successfully');
    end;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE TOGGLE_DOWNLOAD(
    in_movie_id download.movieid%type,
    in_customer_id download.customerid%type) 
IS
	r_download Download%ROWTYPE;
BEGIN
    begin 
        SELECT * INTO r_download FROM Download WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DELETE FROM Download WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DBMS_OUTPUT.PUT_LINE('Movie is removed from download list');
    exception
        when no_data_found then
            INSERT INTO Download(CustomerID, MovieID) VALUES (in_customer_id, in_movie_id);
            DBMS_OUTPUT.PUT_LINE('Downloading');
    end;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
---------------------------------------------------------------------------------------------- change this to toggle from add to remove
CREATE OR REPLACE PROCEDURE TOGGLE_FAVORITE(
    in_movie_id favorite.movieid%type,
    in_customer_id favorite.customerid%type) 
IS
	r_favorite Favorite%ROWTYPE;
BEGIN
    begin 
        --SELECT * INTO r_favorite FROM Favorite WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        delete from Favorite WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DBMS_OUTPUT.PUT_LINE('Movie is removed from favorite list');
    exception
        when no_data_found then
            INSERT INTO Favorite(CustomerID, MovieID) VALUES (in_customer_id, in_movie_id);
            DBMS_OUTPUT.PUT_LINE('Added in favorite list');
    end;
---- check if movie is already in customer favorite
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/

-------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ADD_TO_WATCHHISTORY(
    in_movie_id watch_history.movieid%type,
    in_customer_id watch_history.customerid%type) 
IS
  varmovieid number;
  varwatchid number;
BEGIN
    begin 
        Update watch_history set datewatched = sysdate WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DBMS_OUTPUT.PUT_LINE('Starting from where we left off...');
    exception
        when no_data_found then
            INSERT INTO watch_history VALUES(watchhistory_seq.nextval,in_movie_id,in_customer_id,sysdate);
            DBMS_OUTPUT.PUT_LINE('Playing...');
            -- check if movie was in watchlist and remove it
            begin 
                SELECT watchlistid INTO varwatchid FROM Watchlist WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
                delete from watchlist where MovieID = in_movie_id AND CustomerID = in_customer_id;
                DBMS_OUTPUT.PUT_LINE('Removed from watchlist');
            end;
    end;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/
-------------------------------------------------------------------------------------------------------------
create or replace PROCEDURE Add_Address(
    vEmail customer.email%type, 
    vAddress1 address.address1%type, 
    vAddress2 address.address2%type, 
    vCity address.city%type, 
    vState address.state%type, 
    vCountry address.country%type, 
    vPincode address.pincode%type)
IS
    varcustomerid number;
BEGIN
---first find customer  
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
    begin
        select customerid into varcustomerid from customer where email = vEmail;
        begin
            --SELECT * FROM ADDRESS WHERE customerid = varcustomerid;
            UPDATE ADDRESS SET Address1 = vAddress1, Address2 = vAddress2, City = vCity, State = vState, Country = vCountry, Pincode = vPincode WHERE customerid = varcustomerid;
            DBMS_OUTPUT.PUT_LINE('Address updated!');
        exception
            when no_data_found then
                INSERT INTO ADDRESS VALUES(varcustomerid, vAddress1, vAddress2,vCity, vState, vCountry, vPincode);
                DBMS_OUTPUT.PUT_LINE('Address created!');
        end;
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Please create a customer profile first.');
    end;
  
END;
/
---------------------------------------------------------------
CREATE or REPLACE PROCEDURE ADD_SUBTITLE(
    vMovieName movie.movietitle%type, 
    vWords subtitles.text%type, 
    vLang subtitles.language%type)
IS
    r_movie movie%ROWTYPE;
    vmaxsubid number;
BEGIN
---first find movie
    case
        when vMovieName = '' then
            DBMS_OUTPUT.PUT_LINE('Movie not found');
        when vWords = '' then
            DBMS_OUTPUT.PUT_LINE('Text is required');
        when vLang = '' then
            DBMS_OUTPUT.PUT_LINE('Language is required');
    END CASE;
    begin
        select * into r_movie from movie where movietitle = vMovieName;
        begin
            UPDATE Subtitles SET Text = vWords WHERE subtitlesid = (SELECT subtitlesid FROM subtitles WHERE movieid = r_movie.movieid and language = vLang);
            DBMS_OUTPUT.PUT_LINE('Subtitle updated!');
        exception
            when no_data_found then
                INSERT INTO Subtitles VALUES(subtitle_seq.nextval, vMovieName, vWords,vLang);
                DBMS_OUTPUT.PUT_LINE('Subtitle added!');
        end;
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Please add a movie first.');
    end;
---check if movie already has subtitle for language
    --if yes update text
    --if no create new subtitle
END;
/
--------------------------------------------------------------------------------
CREATE or REPLACE PROCEDURE ADD_ACTOR(
    vfirstname actor.actorfirstname%type, 
    vlastname actor.actorlastname%type)
IS
    r_actor actor%ROWTYPE;
    vmaxactor number;
BEGIN
    ---first check if actor name exists
    begin 
        select * into r_actor from actor where ACTORFIRSTNAME = vfirstname and ACTORLASTNAME = vlastname;
        DBMS_OUTPUT.PUT_LINE('Actor exists already');
    exception
        when no_data_found then
            INSERT INTO ACTOR VALUES(actor_seq.nextval, vfirstname, vlastname);
            DBMS_OUTPUT.PUT_LINE('Actor added!');
    end;
        
END;
/
------------------------------------------------------------------------------------------------
CREATE or REPLACE PROCEDURE ADD_SUBSCRIPTION_PLAN(
    vplanname subscription_plan.planid%type, 
    vplandescription subscription_plan.plandescription%type, 
    vscreenlimit subscription_plan.screenlimit%type)
IS
    r_plan subscription_plan%ROWTYPE;
    vmaxplan number;
BEGIN
    ---first check if plan exists
    begin
        select * into r_plan from subscription_plan where planname = vplanname;
        DBMS_OUTPUT.PUT_LINE('Plan already exists.');
    exception
        when no_data_found then
            INSERT INTO subscription_plan VALUES(plan_seq.nextval, vplanname, vplandescription, vscreenlimit);
            DBMS_OUTPUT.PUT_LINE('Plan added!');
    end;
END;
/

-----region-------------------------------------------------------------------------
CREATE or REPLACE PROCEDURE ADD_REGION (
vcountryname region.regionname%type,
vmovietitle movie.movietitle%type)
IS
    r_region region%ROWTYPE;
    varmovieid number;
BEGIN
    ---first check if region exists
    begin
        select movieid into varmovieid from movie where movietitle = vmovietitle;
        begin
            select * into r_region from region where regionname = vcountryname and movieid = varmovieid; 
            DBMS_OUTPUT.PUT_LINE('Movie already exists for this region.');
        exception
            when no_data_found then
                INSERT INTO region VALUES(region_seq.nextval, varmovieid, vcountryname);
                DBMS_OUTPUT.PUT_LINE('Region added!');
        end;
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Movie title does not exist!');
    end;
END;
/

-----Genre--------------------------------------------------------------------------
CREATE or REPLACE PROCEDURE ADD_Genre (vgenrename genre.genrename%type)
IS
    r_genre genre%ROWTYPE;
    vmaxgenre number;
BEGIN
    ---first check if genre exists
    begin
        select * into r_genre from genre where genrename = vgenrename;
        DBMS_OUTPUT.PUT_LINE('Genre already exists.');
    exception
        when no_data_found then
            INSERT INTO genre VALUES(genre_seq.nextval, vgenrename);
            DBMS_OUTPUT.PUT_LINE('Genre added!');
    end;
    
END;
/
---Director----------------------------------------------------------------------------f--------
CREATE or REPLACE PROCEDURE ADD_DIRECTOR(
    vdirectorfirstname director.directorfirstname%type, 
    vdirectorlastname director.directorlastname%type)
IS
    r_director director%ROWTYPE;
    vdirectorid number;
BEGIN
    ---first check if director name exists
    begin
        select directorid into vdirectorid from director where DIRECTORFIRSTNAME = vdirectorfirstname and DIRECTORLASTNAME = vdirectorlastname;
        DBMS_OUTPUT.PUT_LINE('Director exists already.');
    exception
        when no_data_found then
            INSERT INTO DIRECTOR VALUES(director_seq.nextval, vdirectorfirstname, vdirectorlastname);
            DBMS_OUTPUT.PUT_LINE('Director added!');
    end;
END;
/

--Procedures
------------------------------------------------------------------------------DONE content manager
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
    case
        when VARGenre = '' or VARGenre is NULL then
            DBMS_OUTPUT.PUT_LINE('Genre is required');
        when VARDirectorFirstName = '' or VARDirectorFirstName is NULL then
            DBMS_OUTPUT.PUT_LINE('Director First Name is required');
        when VARDirectorLastName = '' or VARDirectorLastName is NULL then
            DBMS_OUTPUT.PUT_LINE('Director Last Name is required');
        when VARMovieTitle = '' or VARMovieTitle is null then
            DBMS_OUTPUT.PUT_LINE('Movie Title is required');
        when VARDateOfRelease = '' or not REGEXP_LIKE(VARDateOfRelease, '^[[:digit:]]+$') or VARDateOfRelease is null then
            DBMS_OUTPUT.PUT_LINE('Year of Release is required');
        when VARMovieDuration = '' or not REGEXP_LIKE(VARMovieDuration, '^[[:digit:]]+$') or VARMovieDuration is null then
            DBMS_OUTPUT.PUT_LINE('Movie Duration is required');
        when VARMovieDescription = '' or VARMovieDescription is null then
            DBMS_OUTPUT.PUT_LINE('Movie Description is required');
        when VARRatings = '' or VARRatings is null then
            DBMS_OUTPUT.PUT_LINE('Movie Rating is required');
        when VARCountryOrigin = '' or VARCountryOrigin is null then
            DBMS_OUTPUT.PUT_LINE('Country Origin is required');
        else
            begin 
                select genreid into VARGENREID from genre where lower(VARGenre) = lower(genrename);
            exception
                when no_data_found then
                    VARGENREID := genre_seq.nextval;
                    INSERT INTO GENRE (GenreID, GenreName) VALUES (VARGENREID, VARGenre);
                    
            end;
        
            begin 
                select directorid into VARDIRECTORID from director where lower(VARDirectorFirstName) = lower(DirectorFirstName) and lower(VARDirectorLastName) = lower(DirectorLastName);
            exception
                when no_data_found then
                    VARDIRECTORID := director_seq.nextval;
                    INSERT INTO director VALUES (VARDIRECTORID, VARDirectorFirstName, VARDirectorLastName);
            end;
            
            begin 
                select movieid into VARMAXMOVIEID from movie where lower(VARMovieTitle) = lower(movietitle) and lower(VARDateOfRelease) = lower(DateOfRelease);
                    dbms_output.put_line('Movie ' || VARMovieTitle || ' already exists!');
            exception
                when no_data_found then
                    INSERT INTO MOVIE VALUES(movie_seq.nextval,VARGENREID,VARDIRECTORID, VARMovieTitle, VARDateOfRelease,VARMovieDuration, VARMovieDescription, VARRatings, VARCountryOrigin);
                    dbms_output.put_line('Movie ' || VARMovieTitle || ' added!');
            end;
    END CASE;
    
EXCEPTION
 when others then
    dbms_output.put_line(sqlerrm);
END;
/
execute create_movie('genre', 'megha', 'patel', 'cats', 1999, 3, 'this is a test',3.5, 'alaska');
execute create_movie('genre', 'megha', 'patel', 'another cat movie', 2001, 3, 'this is a test',4.5, 'canada');
execute create_movie('genre', 't','z','dsfsd',null, 34,'sfsdfsdsf',3, 'UK');
execute create_movie('genre', '','z','dsfsd',null, 34,'sfsdfsdsf',3, 'UK');
execute create_movie('genre', 'megha', 'patel', 'cats', 1999, 3, 'this is a test',3.5, 'alaska');
/
--------------------------------------------------------------------------------------------------------- DONE 
create or replace PROCEDURE CREATE_CUSTOMER(
    vUserFirstName customer.userfirstname%type, 
    vUserLastName customer.userlastname%type,
    vEmail customer.email%type,
    vDateOfBirth varchar,
    vGender VARCHAR, 
    vUsername customer.username%type,
    vUserPassword customer.userpassword%type
    )
IS
varcustomerid number;
usercounts number;
BEGIN
    begin 
        case
            when vEmail = '' or NOT REGEXP_LIKE(vEmail, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') or vEmail is null then
                DBMS_OUTPUT.PUT_LINE('Please enter correct email format');
            when vUserFirstName = '' or vUserFirstName is null then
                DBMS_OUTPUT.PUT_LINE('First name is required');
            when vUserLastName = '' or vUserLastName is null then
                DBMS_OUTPUT.PUT_LINE('Last name is required');
            when vDATEOFBIRTH = '' or vDATEOFBIRTH is null or NOT REGEXP_LIKE(vDATEOFBIRTH, '^[0-9]{1,2}-[A-Z]{3}-[0-9]{4}$') then
                DBMS_OUTPUT.PUT_LINE('Birthday is required as dd-MON-yyyy');
            when vGENDER = '' or vGENDER is null then 
                DBMS_OUTPUT.PUT_LINE('Gender is required');
            when upper(vGENDER) not in ('MALE', 'FEMALE', 'OTHER') then
                DBMS_OUTPUT.PUT_LINE('Gender must be Female, Male, or Other');
            when vUsername = '' or vUsername is null then
                DBMS_OUTPUT.PUT_LINE('Username is required');
            when vUserpassword = '' or vUserpassword is null then
                DBMS_OUTPUT.PUT_LINE('Password is required!'); 
            else 
                select count(*) into usercounts from customer where lower(vEmail) = lower(email) or lower(vUsername) = lower(username);
                if usercounts >= 1 then
                    DBMS_OUTPUT.PUT_LINE('Username or email is already in use');
                else
                    INSERT INTO CUSTOMER VALUES(customer_seq.nextval, vUserFirstName, vUserLastName,vEmail, to_date(vDateOfBirth), upper(vGENDER), vUsername, vUserPassword,'NOT ACTIVE', sysdate);
                    DBMS_OUTPUT.PUT_LINE('Customer profile created! Welcome ' || vUserFirstName || ' ' || vUserLastName);
                end if;
        END CASE;        
    exception
        when no_data_found then
            dbms_output.put_line(sqlerrm);
    end;
END;
/
execute CREATE_CUSTOMER('megha','patel','M@g.com','17-JUL-1999', 'female','meghamillions123','panda');
execute CREATE_CUSTOMER('megha','patel','Meg@g.com','17-JUL-1999', 'sdf','mmillions123','panda');
execute CREATE_CUSTOMER('megha','not patel','Moo@g.com','17-JUL-1999', 'female','meghamillions123','panda');
execute CREATE_CUSTOMER('megha','patel','Moo@g.com','17-JUL-1999', 'female','mmillions123','panda');
execute CREATE_CUSTOMER('megha','patel','Moo@g.com','17-JUL-1999', 'female','mee123','panda');
/
------------------------------------------------------------------------------------------------------- DONE 
create or replace PROCEDURE CHANGE_CUSTOMER_EMAIL (
    varusername customer.username%type, 
    varpassword customer.userpassword%type, 
    varEmail customer.email%type)
IS
    VARUSER CUSTOMER%rowtype;
BEGIN
    case
        when varEmail = '' or NOT REGEXP_LIKE(varEmail, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') or varEmail is null then
            DBMS_OUTPUT.PUT_LINE('Please enter correct email format.');
        when varusername = '' or varusername is null then
            DBMS_OUTPUT.PUT_LINE('Username is required');
        when varpassword = '' or varpassword is null then
            DBMS_OUTPUT.PUT_LINE('Password is required');
        else
            begin 
                select * into VARUSER from customer where lower(varusername) = lower(username);
                if lower(varpassword) <> lower(VARUSER.userpassword) then
                    DBMS_OUTPUT.PUT_LINE('Incorrect password');
                else 
                    IF varEmail is not NULL then
                        UPDATE CUSTOMER SET EMAIL = varEmail where customerid = VARUSER.customerid;
                        DBMS_OUTPUT.PUT_LINE('Email changed!');
                    end if;
                end if;
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('User not found.');
            end;
        end case;
EXCEPTION
 when others then
    dbms_output.put_line(sqlerrm);
END;
/
execute CHANGE_CUSTOMER_EMAIL('meghamillions123','panda','m@gmmmm.com');
execute CHANGE_CUSTOMER_Email('meghamillions123','pnda','m@gmmmm.com');
execute CHANGE_CUSTOMER_Email('meghamillions123','pnda','m@.com');

/
----TOGGLE CREATE OR DELETE A MOVIE TO WATCHLIST-------------------------------------------------------
CREATE OR REPLACE PROCEDURE TOGGLE_WATCHLIST(
    in_movie_id watchlist.movieid%type,
    in_customer_id watchlist.customerid%type)
IS
  r_watchlist Watchlist%ROWTYPE;
  vmovieid number;
  vcustomerid number;
BEGIN
  -- Check if movie is already in customer watchlist
    select movieid into vmovieid from movie where MovieID = in_movie_id;
    select customerid into vcustomerid from customer where customerid = in_customer_id;
    begin 
        SELECT * INTO r_watchlist FROM Watchlist WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DELETE FROM Watchlist WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DBMS_OUTPUT.PUT_LINE('Movie is removed from watchlist');
    exception
        when no_data_found then
            INSERT INTO Watchlist(watchlistid,CustomerID, MovieID) VALUES (watchlist_seq.nextval, in_customer_id, in_movie_id);
            DBMS_OUTPUT.PUT_LINE('Movie added to watchlist successfully');
    end;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/
select * from movie where movieid = 602;
select customerid from customer where username = 'meghamillions123';
execute TOGGLE_WATCHLIST(602,602);
execute TOGGLE_WATCHLIST(602,602);
execute TOGGLE_WATCHLIST(602,602);
/
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE TOGGLE_DOWNLOAD(
    in_movie_id download.movieid%type,
    in_customer_id download.customerid%type) 
IS
	r_download Download%ROWTYPE;
    vmovieid number;
    vcustomerid number;
BEGIN
    select movieid into vmovieid from movie where MovieID = in_movie_id;
    select customerid into vcustomerid from customer where customerid = in_customer_id;
    begin 
        SELECT * INTO r_download FROM Download WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DELETE FROM Download WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DBMS_OUTPUT.PUT_LINE('Movie is removed from download list');
    exception
        when no_data_found then
            INSERT INTO Download(downloadid,CustomerID, MovieID, dateofdownload) VALUES (download_seq.nextval, in_customer_id, in_movie_id,sysdate);
            DBMS_OUTPUT.PUT_LINE('Downloading');
    end;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/
execute TOGGLE_DOWNLOAD(602,602);
execute TOGGLE_DOWNLOAD(602,602);
execute TOGGLE_DOWNLOAD(602,602);
/
---------------------------------------------------------------------------------------------- change this to toggle from add to remove
CREATE OR REPLACE PROCEDURE TOGGLE_FAVORITE(
    in_movie_id favorite.movieid%type,
    in_customer_id favorite.customerid%type) 
IS
	r_favorite Favorite%ROWTYPE;
    vmovieid number;
    vcustomerid number;
BEGIN
    select movieid into vmovieid from movie where MovieID = in_movie_id;
    select customerid into vcustomerid from customer where customerid = in_customer_id;
    begin 
        SELECT * INTO r_favorite FROM Favorite WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        delete from Favorite WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
        DBMS_OUTPUT.PUT_LINE('Movie is removed from favorite list');
    exception
        when no_data_found then
            INSERT INTO Favorite(favoriteid, CustomerID, MovieID) VALUES (favorite_seq.nextval,in_customer_id, in_movie_id);
            DBMS_OUTPUT.PUT_LINE('Added in favorite list');
    end;
---- check if movie is already in customer favorite
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/
execute TOGGLE_Favorite(602,602);
execute TOGGLE_Favorite(602,602);
execute TOGGLE_Favorite(605,602);
/

-------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ADD_TO_WATCHHISTORY(
    in_movie_id watch_history.movieid%type,
    in_customer_id watch_history.customerid%type) 
IS
  varmovieid number;
  varwatchid number;
  vcustomerid number;
BEGIN
    begin
        select movieid into varmovieid from movie where MovieID = in_movie_id;
        select customerid into vcustomerid from customer where customerid = in_customer_id;
        begin 
            select historyid into varwatchid from watch_history WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
            Update watch_history set datewatched = sysdate WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
            DBMS_OUTPUT.PUT_LINE('Starting from where we left off...');
        exception
            when no_data_found then
                INSERT INTO watch_history VALUES(watchhistory_seq.nextval,in_movie_id,in_customer_id,sysdate);
                DBMS_OUTPUT.PUT_LINE('Playing...');
                begin 
                    SELECT watchlistid INTO varwatchid FROM Watchlist WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
                    delete from watchlist where MovieID = in_movie_id AND CustomerID = in_customer_id;
                    DBMS_OUTPUT.PUT_LINE('Removed from watchlist');
                end;
        end;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
    end;
EXCEPTION
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/
execute ADD_TO_WATCHHISTORY(602,602);
execute ADD_TO_WATCHHISTORY(600,602);
execute ADD_TO_WATCHHISTORY(605,602);
/
------------------------------------------------------------------------------------------------------------- DONE
create or replace PROCEDURE Add_or_Update_Address(
    vuserid customer.customerid%type, 
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
        when vuserid = '' or vuserid is null then
            DBMS_OUTPUT.PUT_LINE('Customer id is required');
        when vAddress1 = '' or vAddress1 is null then
            DBMS_OUTPUT.PUT_LINE('Address1 is required');
        when vCity = '' or vCity is null then
            DBMS_OUTPUT.PUT_LINE('City is required');
        when vState = '' or vState is null then
            DBMS_OUTPUT.PUT_LINE('State is required');
        when vCountry = '' or vCountry is null then
            DBMS_OUTPUT.PUT_LINE('Country is required');
        when vPincode = '' or vPincode is null or not REGEXP_LIKE(vPincode, '^\d{5}([-\s]\d{4})?$') then
            DBMS_OUTPUT.PUT_LINE('Pincode is required');
        else
            begin
                select customerid into varcustomerid from customer where customerid = vuserid;
                begin
                    SELECT customerid into varcustomerid FROM ADDRESS WHERE customerid = varcustomerid;
                    UPDATE ADDRESS SET Address1 = vAddress1, Address2 = vAddress2, City = vCity, State = vState, Country = vCountry, Pincode = vPincode WHERE customerid = varcustomerid;
                    DBMS_OUTPUT.PUT_LINE('Address updated!');
                exception
                    when no_data_found then
                        INSERT INTO ADDRESS VALUES(varcustomerid, vAddress1, vAddress2,vCity, vState, vCountry, vPincode);
                        DBMS_OUTPUT.PUT_LINE('Address created!');
                end;
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Customer not found. Please create a customer profile.');
            end;
        END CASE;  
END;
/
execute Add_or_Update_Address(602, '23 Boston Huskey Ave', 'Apt. 3', 'Boston', 'MA', 'United States of America', '02210');
execute Add_or_Update_Address(602, '23 Boston Huskey Ave', 'Apt. 3', 'Boston', 'MA', 'United States of America', '02-210');
execute Add_or_Update_Address(602, '23 Boston Huskey Ave', NULL, 'Boston', 'MA', 'United States of America', '02210');
execute Add_or_Update_Address(605, '23 Boston Huskey Ave', 'Apt. 3', 'Boston', 'MA', 'United States of America', '02210');
execute Add_or_Update_Address(602, '23 Boston Huskey Ave', 'Apt. 3', 'Boston', 'MA', 'United States of America', '02210-2343');

/
---------------------------------------------------------------
CREATE or REPLACE PROCEDURE ADD_UPDATE_SUBTITLE(
    vMovieName movie.movietitle%type, 
    vWords subtitles.text%type, 
    vLang subtitles.language%type)
IS
    vmovieid number;
    vmaxsubid number;
BEGIN
---first find movie
    case
        when vMovieName = '' or vMovieName is null then
            DBMS_OUTPUT.PUT_LINE('Movie not found');
        when vWords = '' or vWords is null then
            DBMS_OUTPUT.PUT_LINE('Text is required');
        when vLang = '' or vLang is null then
            DBMS_OUTPUT.PUT_LINE('Language is required');
        else
            begin
                select movieid into vmovieid from movie where lower(movietitle) = lower(vMovieName);
                begin
                    select subtitlesid into vmaxsubid from subtitles WHERE movieid = vmovieid and lower(language) = lower(vLang);
                    UPDATE Subtitles SET Text = vWords WHERE movieid = vmovieid and lower(language) = lower(vLang);
                    DBMS_OUTPUT.PUT_LINE('Subtitle updated!');
                exception
                    when no_data_found then
                        INSERT INTO Subtitles(subtitlesid, movieid, text, language) VALUES(subtitle_seq.nextval,vmovieid,vWords,vLang);
                        DBMS_OUTPUT.PUT_LINE('Subtitle added!');
                end;
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Please add a movie first.');
            end;
    END CASE;
    
---check if movie already has subtitle for language
    --if yes update text
    --if no create new subtitle
END;
/
execute ADD_SUBTITLE('cats','blah blah blah blah blah blah blah blah blah blah blah blah', 'dutch');
execute ADD_SUBTITLE('cats','blah blah blah blah blah blah blah blah blah blah blah blah', 'german');
/
--------------------------------------------------------------------------------DONE
CREATE or REPLACE PROCEDURE ADD_ACTOR(
    vfirstname actor.actorfirstname%type, 
    vlastname actor.actorlastname%type)
IS
    r_actor actor%ROWTYPE;
    vmaxactor number;
BEGIN
    ---first check if actor name exists
    case
        when vfirstname = '' or vfirstname is null then
            DBMS_OUTPUT.PUT_LINE('First name is required');
        when vlastname = '' or vlastname is null then
            DBMS_OUTPUT.PUT_LINE('Last name is required');
        else
            begin 
                select * into r_actor from actor where lower(ACTORFIRSTNAME) = lower(vfirstname) and lower(ACTORLASTNAME) = lower(vlastname);
                DBMS_OUTPUT.PUT_LINE('Actor exists already');
            exception
                when no_data_found then
                    INSERT INTO ACTOR VALUES(actor_seq.nextval, vfirstname, vlastname);
                    DBMS_OUTPUT.PUT_LINE('Actor added!');
            end;
    end case;    
END;
/
execute ADD_ACTOR('dfghjkuif','ghfuyruuiidd');
execute ADD_ACTOR('','ghfuyruuiidd');
execute ADD_ACTOR('dfghjkuif',NULL);
execute ADD_ACTOR('dfghjkuif','ghfuyruuiidd');
/
------------------------------------------------------------------------------------------------ DONE
CREATE or REPLACE PROCEDURE ADD_SUBSCRIPTION_PLAN(
    vplanname subscription_plan.planname%type, 
    vplandescription subscription_plan.plandescription%type, 
    vscreenlimit subscription_plan.screenlimit%type)
IS
    r_plan subscription_plan%ROWTYPE;
    vmaxplan number;
BEGIN
    ---first check if plan exists
    case
        when vplanname = '' or vplanname is null then
            DBMS_OUTPUT.PUT_LINE('Plan is required');
        when vplandescription = '' or vplandescription is null then
            DBMS_OUTPUT.PUT_LINE('Plan description is required');
        when vscreenlimit = '' or vscreenlimit is null or not REGEXP_LIKE(vscreenlimit, '^[[:digit:]]+$') then
            DBMS_OUTPUT.PUT_LINE('Screen limit is required and must be a number');
        else
            begin
                select * into r_plan from subscription_plan where lower(planname) = lower(vplanname);
                update subscription_plan set plandescription = vplandescription, screenlimit = to_Number(vscreenlimit) where lower(planname) = lower(vplanname);
                DBMS_OUTPUT.PUT_LINE('Plan updated.');
            exception
                when no_data_found then
                    INSERT INTO subscription_plan VALUES(plan_seq.nextval, vplanname, vplandescription, to_Number(vscreenlimit));
                    DBMS_OUTPUT.PUT_LINE('Plan added!');
            end;
    end case;
END;
/

execute ADD_SUBSCRIPTION_PLAN('family discount','nothing is free sorry', 4);
execute ADD_SUBSCRIPTION_PLAN('family discount','nothing is free sorry', 4);
execute ADD_SUBSCRIPTION_PLAN('family discount','', 4);
execute ADD_SUBSCRIPTION_PLAN('family discount','nothing is free sorry', NULL);
/
-----region------------------------------------------------------------------------- DONE
CREATE or REPLACE PROCEDURE ADD_MOVIE_TO_REGION (
vcountryname region.regionname%type,
vmovietitle movie.movietitle%type)
IS
    r_region region%ROWTYPE;
    varmovieid number;
BEGIN
    ---first check if region exists
    case
        when vcountryname = '' or vcountryname is null then
            DBMS_OUTPUT.PUT_LINE('Region name is required');
        when vmovietitle = '' or vmovietitle is null then
            DBMS_OUTPUT.PUT_LINE('Movie name is required');
        else
            begin
                select movieid into varmovieid from movie where movietitle = vmovietitle;
                begin
                    select * into r_region from region where lower(regionname) = lower(vcountryname) and movieid = varmovieid; 
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
    end case;
END;
/
execute ADD_MOVIE_TO_REGION('USA','cats');
execute ADD_MOVIE_TO_REGION('USA','cats');
execute ADD_MOVIE_TO_REGION('UK','cats');
execute ADD_MOVIE_TO_REGION('UK','');
execute ADD_MOVIE_TO_REGION(NULL,'cats');
/
-----Genre-------------------------------------------------------------------------- DONE
CREATE or REPLACE PROCEDURE ADD_Genre (vgenrename genre.genrename%type)
IS
    r_genre genre%ROWTYPE;
    vmaxgenre number;
BEGIN
    ---first check if genre exists
    case
        when vgenrename = '' or vgenrename is null then
            DBMS_OUTPUT.PUT_LINE('Genre name is required');
        else
            begin
                select * into r_genre from genre where lower(genrename) = lower(vgenrename);
                DBMS_OUTPUT.PUT_LINE('Genre already exists with id ' || r_genre.genreid);
            exception
                when no_data_found then
                    INSERT INTO genre VALUES(genre_seq.nextval, vgenrename);
                    DBMS_OUTPUT.PUT_LINE('Genre added!');
            end;
    end case;
END;
/
execute ADD_Genre('Scary!');
execute ADD_Genre('Scary!');
execute ADD_Genre('');
execute ADD_Genre(NULL);
/
---Director--------------------------------------------------------------------- DONE 
CREATE or REPLACE PROCEDURE ADD_DIRECTOR(
    vdirectorfirstname director.directorfirstname%type, 
    vdirectorlastname director.directorlastname%type)
IS
    r_director director%ROWTYPE;
    vdirectorid number;
BEGIN
    ---first check if director name exists
     case
        when vdirectorfirstname = '' or vdirectorfirstname is null then
            DBMS_OUTPUT.PUT_LINE('First name is required');
        when vdirectorlastname = '' or vdirectorlastname is null then
            DBMS_OUTPUT.PUT_LINE('Last name is required');
        else
            begin
                select directorid into vdirectorid from director where lower(DIRECTORFIRSTNAME) = lower(vdirectorfirstname) and lower(DIRECTORLASTNAME) = lower(vdirectorlastname);
                DBMS_OUTPUT.PUT_LINE('Director exists already with id ' ||  vdirectorid);
            exception
                when no_data_found then
                    INSERT INTO DIRECTOR(directorid,directorfirstname, directorlastname) VALUES(director_seq.nextval, vdirectorfirstname, vdirectorlastname);
                    DBMS_OUTPUT.PUT_LINE('Director added!');
            end;  
    end case;
END;
/
execute ADD_DIRECTOR('dfghjkuif','ghfuyruuiidd');
execute ADD_DIRECTOR('','ghfuyruuiidd');
execute ADD_DIRECTOR('dfghjkuif',NULL);
execute ADD_DIRECTOR('dfghjkuif','ghfuyruuiidd');

/
--update movie
create or replace PROCEDURE Update_MOVIE_ratings (
    VARMovieTitle movie.movietitle%type,
    VARRatings movie.ratings%type)
IS
    VARMAXMOVIEID NUMBER;
BEGIN
    case
        when VARMovieTitle = '' or VARMovieTitle is null then
            DBMS_OUTPUT.PUT_LINE('Movie Title is required');
        when VARRatings = '' or VARRatings is null then
            DBMS_OUTPUT.PUT_LINE('Movie Rating is required');
        else           
            begin 
                select movieid into VARMAXMOVIEID from movie where movietitle = VARMovieTitle;
                update movie set ratings = VARRatings where movieid = VARMAXMOVIEID;
                dbms_output.put_line('Movie ' || VARMovieTitle || ' updated!');
            exception
                when no_data_found then
                    dbms_output.put_line('Movie ' || VARMovieTitle || ' not found!');
            end;
    END CASE;
    
EXCEPTION
 when others then
    dbms_output.put_line(sqlerrm);
END;
/
execute Update_MOVIE_ratings('cats', 1.0);
execute Update_MOVIE_ratings('this should show an error', 1.0);
execute Update_MOVIE_ratings('cats', NULL);
execute Update_MOVIE_ratings('', 1.0);
/

--update actor names;
CREATE or REPLACE PROCEDURE Update_ACTOR(
    vactorid actor.actorid%type,
    vfirstname actor.actorfirstname%type, 
    vlastname actor.actorlastname%type)
IS
    r_actor actor%ROWTYPE;
    vmaxactor number;
BEGIN
    ---first check if actor name exists
    case
        when vactorid = '' or vactorid is null then
            DBMS_OUTPUT.PUT_LINE('ID is required');
        when vfirstname = '' or vfirstname is null then
            DBMS_OUTPUT.PUT_LINE('First name is required');
        when vlastname = '' or vlastname is null then
            DBMS_OUTPUT.PUT_LINE('Last name is required');
        else
            begin 
                select * into r_actor from actor where actorid = vactorid;
                update actor set ACTORFIRSTNAME = vfirstname, ACTORLASTNAME = vlastname where actorid = r_actor.actorid;
                DBMS_OUTPUT.PUT_LINE('Actor ' || vfirstname || '  ' || vlastname || ' is updated!');
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Actor does not exist!');
            end;
    end case;    
END;
/
execute Update_ACTOR(301, 'Harry', 'Potter');
execute Update_ACTOR(301, 'Professor', 'Naveen');
execute Update_ACTOR(NULL, 'Harry', 'Potter');
execute Update_ACTOR(302, 'Harry', 'Potter');
execute Update_ACTOR(301, 'Harry Potter', '');
execute Update_ACTOR(301, NULL, 'Potter');
/

--director delete
CREATE or REPLACE PROCEDURE DELETE_DIRECTOR(
    vdirectorid number)
IS
    r_director director%ROWTYPE;
BEGIN
    ---first check if director name exists
     case
        when vdirectorid = '' or vdirectorid is null then
            DBMS_OUTPUT.PUT_LINE('Director ID required');
        else
            begin
                select * into r_director from director where directorid = vdirectorid;
                delete director where directorid = vdirectorid;
                DBMS_OUTPUT.PUT_LINE('Director ' ||  r_director.directorfirstname || ' ' || r_director.directorlastname || 'is removed');
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Director does not exist!');
            end;  
    end case;
END;
/

---TO DO!!!!!!
/
--director update
CREATE or REPLACE PROCEDURE Update_DIRECTOR(
    vdirectorid number,
    vdirectorfirstname VARCHAR, 
    vdirectorlastname VARCHAR)
IS
    r_director director%ROWTYPE;
BEGIN
    ---first check if director name exists
     case
        when vdirectorid = '' or vdirectorid is null then
            DBMS_OUTPUT.PUT_LINE('Director ID required');
        else
            begin
                select * into r_director from director where directorid = vdirectorid;
                begin 
                    case
                        when vdirectorfirstname <>  '' or vdirectorfirstname  is not null then
                            update director set directorfirstname = vdirectorfirstname;
                        when vdirectorlastname <>  '' or vdirectorlastname is not null then
                            update director set directorlastname = vdirectorlastname;
                    end case;
                    DBMS_OUTPUT.PUT_LINE('Director ' ||  r_director.directorfirstname || ' ' || r_director.directorlastname || 'is changed to '|| vdirectorfirstname || ' ' || vdirectorlastname);
                end;
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Director does not exist!');
            end;  
    end case;
END;
/
-- TO DOOO!!!!!!!
/
--genre delete
CREATE or REPLACE PROCEDURE delete_Genre (vgenrename genre.genrename%type)
IS
    r_genre genre%ROWTYPE;
    vgenre number;
    
BEGIN
    ---first check if genre exists
    case
        when vgenrename = '' or vgenrename is null then
            DBMS_OUTPUT.PUT_LINE('Genre name is required');
        else
            begin
                select * into r_genre from genre where lower(genrename) = lower(vgenrename);
                select count(*) into vgenre from movie where genreid = r_genre.genreid;
                if vgenre >= 1 then
                    DBMS_OUTPUT.PUT_LINE(r_genre.genrename ||' has more than 1 movie associated. Cannot delete. ');
                else 
                    delete genre where genreid = r_genre.genreid;
                    DBMS_OUTPUT.PUT_LINE(r_genre.genrename ||' is deleted.');
                end if;
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Genre not found!');
            end;
    end case;
END;
/
execute DELETE_Genre('Scary!');
execute DELETE_Genre('Scary!');
execute DELETE_Genre('');
execute DELETE_Genre(NULL);
/
--add cast
CREATE OR REPLACE PROCEDURE ADD_CAST(
    in_movie_id movie_cast.movieid%type,
    in_actor_id movie_cast.actorid%type) 
IS
	r_moviecast MOVIE_CAST%ROWTYPE;
BEGIN
    begin 
        SELECT * INTO r_moviecast FROM movie_cast WHERE MovieID = in_movie_id AND actorid = in_actor_id;
        DBMS_OUTPUT.PUT_LINE('Actor already in Movie Cast');
    exception
        when no_data_found then
            INSERT INTO Movie_Cast(MovieID, ActorID) VALUES (in_movie_id, in_actor_id);
            DBMS_OUTPUT.PUT_LINE('Added to movie.');
    end;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/
select max(actorid) from actor;
execute add_cast(602, 301);
execute add_cast(602, 300);
execute add_cast(602, 305);
execute add_cast(662, 301);
execute add_cast(662, '');
execute add_cast(NULL, 301);
/
--delete cast
CREATE OR REPLACE PROCEDURE DELETE_CAST(
    in_movie_id movie_cast.movieid%type,
    in_actor_id movie_cast.actorid%type) 
IS
	r_moviecast MOVIE_CAST%ROWTYPE;
BEGIN
    begin 
        SELECT * INTO r_moviecast FROM movie_cast WHERE MovieID = in_movie_id AND actorid = in_actor_id;
        delete movie_cast WHERE MovieID = in_movie_id AND actorid = in_actor_id; 
        DBMS_OUTPUT.PUT_LINE('Actor removed from Movie Cast');
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Cast member does not exist.');
    end;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid movie or customer ID');
END;
/
execute DELETE_CAST(602, 301);
execute DELETE_CAST(602, 305);
execute DELETE_CAST(602, 299);
execute DELETE_CAST('', 305);
execute DELETE_CAST(602, NULL);
/
--delete actor
CREATE or REPLACE PROCEDURE DELETE_ACTOR(
    vactorid actor.actorid%type)
IS
    r_actor actor%ROWTYPE;
    vmaxactor number;
BEGIN
    ---first check if actor name exists

    begin 
        select * into r_actor from actor where actorid = vactorid;
        delete actor where actorid = r_actor.actorid;
        DBMS_OUTPUT.PUT_LINE('Actor ' || r_actor.ACTORFIRSTNAME || '  ' || r_actor.ACTORLASTNAME || ' is deleted');
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Actor does not exist!');
    end;
END;
/
execute DELETE_ACTOR(301);
execute DELETE_ACTOR(301);
execute DELETE_ACTOR(302);
execute DELETE_ACTOR(NULL);
execute DELETE_ACTOR('');
/
--add purchase
CREATE OR REPLACE PROCEDURE CREATE_PURCHASE(
    vplanname subscription_plan.planname%type,
    vcustomerusername customer.username%type,
    vcustomerpassword customer.userpassword%type) 
IS
	r_purchase PURCHASE%ROWTYPE;
    r_customer CUSTOMER%ROWTYPE;
    vplanid number;
    venddate date;
BEGIN
   case
        when vcustomerusername = '' or vcustomerusername is null then
            DBMS_OUTPUT.PUT_LINE('Username is required');
        when vcustomerpassword = '' or vcustomerpassword is null then
            DBMS_OUTPUT.PUT_LINE('Password is required');
        when vplanname = '' or vplanname is null then
            DBMS_OUTPUT.PUT_LINE('Plan Name is required');
        else
            begin --check if plan exists
                select * into r_customer from customer where lower(username) = lower(vcustomerusername);
                if vcustomerpassword <> r_customer.userpassword then
                    DBMS_OUTPUT.PUT_LINE('Incorrect password');
                else 
                    begin
                        SELECT * INTO r_purchase FROM purchase WHERE customerid = r_customer.customerid AND enddate > sysdate;
                        DBMS_OUTPUT.PUT_LINE('User can buy one plan at a time.');
                    exception
                        when no_data_found then
                            begin
                                select planid into vplanid from subscription_plan where vplanname = planname;
                                venddate := add_months(sysdate, 1);
                                INSERT INTO PURCHASE values(purchase_seq.nextval, vplanid, r_customer.customerid, sysdate, venddate);
                                DBMS_OUTPUT.PUT_LINE('Added to movie.');
                            exception
                                when no_data_found then
                                    DBMS_OUTPUT.PUT_LINE('Plan does not exist.');
                            end;
                    end;
                end if;  
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Invalid username.');
            end;
    end case;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid plan or customer ID');
END;
/
execute create_purchase('family discount', 'meghamillions123', 'panda');
execute create_purchase('family discount', 'millions123', 'panda');
execute create_purchase('this should fail', 'meghamillions123', 'panda');
execute create_purchase('family discount', 'meghamillions123', 'please');
/
--delete region
CREATE or REPLACE PROCEDURE DELETE_MOVIE_FROM_REGION (
vregionname region.regionname%type,
vmovietitle movie.movietitle%type)
IS
    r_region region%ROWTYPE;
    varmovieid number;
BEGIN
    ---first check if region exists
    case
        when vregionname = '' or vregionname is null then
            DBMS_OUTPUT.PUT_LINE('Region Name is required');
        when vmovietitle = '' or vmovietitle is null then
            DBMS_OUTPUT.PUT_LINE('Movie name is required');
        else
            begin
                select movieid into varmovieid from movie where movietitle = vmovietitle;
                begin
                    select * into r_region from region where regionname = vregionname and movieid = varmovieid; 
                    DELETE REGION WHERE regionid = r_region.regionid and movieid = varmovieid;
                    DBMS_OUTPUT.PUT_LINE('Movie removed from this region.');
                exception
                    when no_data_found then
                        DBMS_OUTPUT.PUT_LINE('Movie does not exist for this region');
                end;
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Movie title does not exist!');
            end;
    end case;
END;
/
execute DELETE_MOVIE_FROM_REGION('UK', 'cats');
execute DELETE_MOVIE_FROM_REGION('UK','');
execute DELETE_MOVIE_FROM_REGION(NULL,'cats');
execute DELETE_MOVIE_FROM_REGION('UK', 'cats');
/
--delete subscription
CREATE or REPLACE PROCEDURE DELETE_SUBSCRIPTION_PLAN(
    vplanname subscription_plan.planname%type)
IS
    r_plan subscription_plan%ROWTYPE;
BEGIN
    ---first check if plan exists
    case
        when vplanname = '' or vplanname is null then
            DBMS_OUTPUT.PUT_LINE('Plan name is required');
        else
            begin
                select * into r_plan from subscription_plan where lower(planname) = lower(vplanname);
                delete subscription_plan where lower(planname) = lower(vplanname);
                DBMS_OUTPUT.PUT_LINE('Plan deleted.');
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Invalid Plan Name!');
            end;
    end case;
END;
/
execute DELETE_SUBSCRIPTION_PLAN('family discount');
execute DELETE_SUBSCRIPTION_PLAN('this should fail');
/
--delete subtitles;
CREATE or REPLACE PROCEDURE DELETE_SUBTITLE(
    vMovieName movie.movietitle%type, 
    vLang subtitles.language%type)
IS
    vmovieid number;
    vmaxsubid number;
BEGIN
---first find movie
    case
        when vMovieName = '' or vMovieName is null then
            DBMS_OUTPUT.PUT_LINE('Movie name not found');
        when vLang = '' or vLang is null then
            DBMS_OUTPUT.PUT_LINE('Language is required');
        else
            begin
                select movieid into vmovieid from movie where lower(movietitle) = lower(vMovieName);
                begin
                    select subtitlesid into vmaxsubid from subtitles WHERE movieid = vmovieid and lower(language) = lower(vLang);
                    DELETE Subtitles WHERE movieid = vmovieid and lower(language) = lower(vLang);
                    DBMS_OUTPUT.PUT_LINE('Subtitle for ' || vMovieName || ' with language ' || vLang || ' is deleted');
                exception
                    when no_data_found then
                        DBMS_OUTPUT.PUT_LINE('Subtitle language not found!');
                end;
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('Cannot find movie.');
            end;
    END CASE;
    
---check if movie already has subtitle for language
    --if yes update text
    --if no create new subtitle
END;
--add validation to see if movie and customer exists in toggles, cast
/
execute DELETE_SUBTITLE('cats', 'dutch');
execute DELETE_SUBTITLE('cats', 'german');
execute DELETE_SUBTITLE('cats', 'english');
execute DELETE_SUBTITLE('', 'german');
execute DELETE_SUBTITLE('cats', NULL);
/
--delete movie;
create or replace PROCEDURE DELETE_MOVIE (
    VARMovieTitle movie.movietitle%type)
IS
    VARMAXMOVIEID NUMBER;
BEGIN
    case
        when VARMovieTitle = '' or VARMovieTitle is null then
            DBMS_OUTPUT.PUT_LINE('Movie Title is required');
        else           
            begin 
                select movieid into VARMAXMOVIEID from movie where movietitle = VARMovieTitle;
                delete movie where movieid = VARMAXMOVIEID;
                dbms_output.put_line('Movie ' || VARMovieTitle || ' deleted!');
            exception
                when no_data_found then
                    dbms_output.put_line('Movie ' || VARMovieTitle || ' not found!');
            end;
    END CASE;
    
EXCEPTION
 when others then
    dbms_output.put_line(sqlerrm);
END;
/
execute DELETE_MOVIE('cats');
execute DELETE_MOVIE('test');
execute DELETE_MOVIE('');
execute DELETE_MOVIE(NULL);
/
--customer delete
create or replace PROCEDURE DELETE_CUSTOMER(--make customer NOT ACTIVE, and change purchase end date to today
    vUsername customer.username%type,
    vUserPassword customer.userpassword%type
    )
IS
    VARUSER CUSTOMER%rowtype;
BEGIN
    case
        when vUsername = '' or vUsername is null then
            DBMS_OUTPUT.PUT_LINE('Username is required');
        when vUserPassword = '' or vUserPassword is null then
            DBMS_OUTPUT.PUT_LINE('Password is required');
        else
            begin 
                select * into VARUSER from customer where lower(vUsername) = lower(username);
                if vUserPassword <> VARUSER.userpassword then
                    DBMS_OUTPUT.PUT_LINE('Incorrect password');
                else 
                    UPDATE CUSTOMER SET CUSTOMERSTATUS = 'NOT ACTIVE' where customerid = VARUSER.customerid;
                    UPDATE PURCHASE SET ENDDATE = sysdate where customerid = VARUSER.customerid and startdate = (select max(startdate) from purchase where customerid = VARUSER.customerid); 
                    DBMS_OUTPUT.PUT_LINE('Customer ' || VARUSER.userfirstname || ' ' || VARUSER.userlastname || ' successfully cancelled their subsription.');
                end if;
            exception
                when no_data_found then
                    DBMS_OUTPUT.PUT_LINE('User not found.');
            end;
        end case;
EXCEPTION
 when others then
    dbms_output.put_line(sqlerrm);
END;
/
execute delete_customer('meghamillions123', 'p3');
execute delete_customer('momo', 'panda');
execute delete_customer('', 'panda');
execute delete_customer('meghamillions123', NULL);
execute delete_customer('meghamillions123', 'panda');
/
--commit;

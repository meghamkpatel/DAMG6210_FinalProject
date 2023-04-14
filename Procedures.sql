--Procedures
------------------------------------------------------------------------------DONE
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
                    INSERT INTO GENRE (GenreID, GenreName) VALUES (genre_seq.nextval, VARGenre);
                    VARGENREID := genre_seq.nextval;
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
BEGIN
    begin 
        select customerid into varcustomerid from customer where lower(vEmail) = lower(email) and lower(vUsername) = lower(username);
        DBMS_OUTPUT.PUT_LINE('Email or username is already in use. Please try another.');        
    exception
        when no_data_found then
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
                    INSERT INTO CUSTOMER VALUES(customer_seq.nextval, vUserFirstName, vUserLastName,vEmail, to_date(vDateOfBirth), upper(vGENDER), vUsername, vUserPassword,'NOT ACTIVE', sysdate);
                    DBMS_OUTPUT.PUT_LINE('Customer profile created! Welcome ' || vUserFirstName || ' ' || vUserLastName);
            END CASE;
    end;
END;
/
execute CREATE_CUSTOMER('megha','patel','M@g.com','17-JUL-1999', 'female','meghamillions123','panda');
execute CREATE_CUSTOMER('megha','patel','Meg@g.com','17-JUL-1999', 'sdf','mmillions123','panda');
execute CREATE_CUSTOMER('megha','not patel','Moo@g.com','17-JUL-1999', 'female','meghamillions123','panda');
execute CREATE_CUSTOMER('megha','patel','Moo@g.com','17-JUL-1999', 'female','mmillions123','panda');
execute CREATE_CUSTOMER('megha','patel','Mee@g.com','17-JUL-1999', 'female','mee123','panda');
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
BEGIN
  -- Check if movie is already in customer watchlist
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
select movieid from movie where movietitle = 'cats';
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
BEGIN
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
select movieid from movie where movietitle = 'cats';
select customerid from customer where username = 'meghamillions123';
execute TOGGLE_DOWNLOAD(602,602);
/
---------------------------------------------------------------------------------------------- change this to toggle from add to remove
CREATE OR REPLACE PROCEDURE TOGGLE_FAVORITE(
    in_movie_id favorite.movieid%type,
    in_customer_id favorite.customerid%type) 
IS
	r_favorite Favorite%ROWTYPE;
BEGIN
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
select movieid from movie where movietitle = 'cats';
select customerid from customer where username = 'meghamillions123';
execute TOGGLE_Favorite(602,602);
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
        select historyid into varwatchid from watch_history WHERE MovieID = in_movie_id AND CustomerID = in_customer_id;
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
select movieid from movie where movietitle = 'cats';
select customerid from customer where username = 'meghamillions123';
execute ADD_TO_WATCHHISTORY(602,602);
execute ADD_TO_WATCHHISTORY(600,602);
execute ADD_TO_WATCHHISTORY(602,602);
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
CREATE or REPLACE PROCEDURE ADD_SUBTITLE(
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
                        --INSERT INTO Subtitles(subtitlesid, movieid, text, language) VALUES(subtitle_seq.nextval,602,vWords,vLang);
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
select * from movie where movietitle = 'cats';
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
                update plan set plandescription = vplandescription, screenlimit = to_Number(vscreenlimit) where lower(planname) = lower(vplanname);
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
--delete movie;
create or replace PROCEDURE Update_MOVIE_ratings (
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
--delete actor
CREATE or REPLACE PROCEDURE DELETE_ACTOR(
    vactorid actor.actorid%type,
    vfirstname actor.actorfirstname%type, 
    vlastname actor.actorlastname%type)
IS
    r_actor actor%ROWTYPE;
    vmaxactor number;
BEGIN
    ---first check if actor name exists

    begin 
        select * into r_actor from actor where actorid = vactorid or (ACTORFIRSTNAME = vfirstname and ACTORLASTNAME = vlastname);
        delete actor where actorid = r_actor.actorid;
        DBMS_OUTPUT.PUT_LINE('Actor ' || r_actor.ACTORFIRSTNAME || '  ' || r_actor.ACTORLASTNAME || ' is deleted');
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Actor does not exist!');
    end;
END;
--customer delete
--director delete
--director update
--genre update
--add cast
CREATE OR REPLACE PROCEDURE ADD_CAST(
    in_movie_id movie_cast.movieid%type,
    in_actor_id movie_cast.actorid%type) 
IS
	r_moviecast MOVIE_CAST%ROWTYPE;
BEGIN
    begin 
        SELECT * INTO r_favorite FROM movie_cast WHERE MovieID = in_movie_id AND actorid = in_actor_id;
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
--delete cast
CREATE OR REPLACE PROCEDURE DELETE_CAST(
    in_movie_id movie_cast.movieid%type,
    in_actor_id movie_cast.actorid%type) 
IS
	r_moviecast MOVIE_CAST%ROWTYPE;
BEGIN
    begin 
        SELECT * INTO r_favorite FROM movie_cast WHERE MovieID = in_movie_id AND actorid = in_actor_id;
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
--add purchase
--update purchase
--update region
--delete region
--delete subscription
--delete subtitles;
--add validation to see if movie and customer exists in toggles, cast

commit;
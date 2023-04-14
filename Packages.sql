
--------------Packages-------------------------------------------------
/
CREATE OR REPLACE PACKAGE pkg_movie_management as
PROCEDURE CREATE_MOVIE (
    VARGenre genre.genrename%type,
    VARDirectorFirstName director.DirectorFirstName%type,
    VARDirectorLastName director.DirectorLastName%type,
    VARMovieTitle movie.movietitle%type,
    VARDateOfRelease movie.dateofrelease%type,
    VARMovieDuration movie.movieduration%type,
    VARMovieDescription movie.moviedescription%type,
    VARRatings movie.ratings%type,
    VARCountryOrigin movie.countryorigin%type);

PROCEDURE ADD_SUBTITLE(
    vMovieName movie.movietitle%type, 
    vWords subtitles.text%type, 
    vLang subtitles.language%type);

PROCEDURE ADD_ACTOR(
    vfirstname actor.actorfirstname%type, 
    vlastname actor.actorlastname%type);

PROCEDURE ADD_DIRECTOR(
    vdirectorfirstname director.directorfirstname%type, 
    vdirectorlastname director.directorlastname%type)

PROCEDURE ADD_MOVIE_TO_REGION (
vcountryname region.regionname%type,
vmovietitle movie.movietitle%type);

PROCEDURE ADD_Genre (vgenrename genre.genrename%type);

FUNCTION get_actormovies(p_actor IN VARCHAR2)RETURN VARCHAR2;

FUNCTION get_directormovies(p_director IN VARCHAR2)
RETURN VARCHAR2;

CREATE OR REPLACE FUNCTION get_movies(p_genre IN VARCHAR2)
RETURN VARCHAR2;


End pkg_movie_management;
/
----------------------------------------------------------------------------------------------------------------------

/
CREATE OR REPLACE PACKAGE pkg_customer_management as

PROCEDURE CREATE_CUSTOMER(
    vUserFirstName customer.userfirstname%type, 
    vUserLastName customer.userlastname%type,
    vEmail customer.email%type,
    vDateOfBirth varchar,
    vGender VARCHAR, 
    vUsername customer.username%type,
    vUserPassword customer.userpassword%type
    )

PROCEDURE CHANGE_CUSTOMER_DETAIL (varusername IN varchar, varpassword in VARCHAR, varEmail IN varchar, CustomerName OUT VARCHAR, CustomerEmail OUT VARCHAR, CustomerUserName OUT VARCHAR, CustomerStatus OUT VARCHAR);

PROCEDURE Add_or_Update_Address(
    vuserid customer.customerid%type, 
    vAddress1 address.address1%type, 
    vAddress2 address.address2%type, 
    vCity address.city%type, 
    vState address.state%type, 
    vCountry address.country%type, 
    vPincode address.pincode%type);

END pkg_customer_management;
/

--------------------------------------------------------------------------------------------------------------------------
/
CREATE or REPLACE PACKAGE pkg_operation_management as

PROCEDURE TOGGLE_WATCHLIST(
    in_movie_id watchlist.movieid%type,
    in_customer_id watchlist.customerid%type);

PROCEDURE TOGGLE_DOWNLOAD(
    in_movie_id download.movieid%type,
    in_customer_id download.customerid%type);

PROCEDURE TOGGLE_FAVORITE(
    in_movie_id favorite.movieid%type,
    in_customer_id favorite.customerid%type);

PROCEDURE ADD_TO_WATCHHISTORY(
    in_movie_id watch_history.movieid%type,
    in_customer_id watch_history.customerid%type);

FUNCTION REGION_RESTRICTED_MOVIE1(in_customer_id IN NUMBER, in_movie_id in NUMBER) 
Return VARCHAR2;

FUNCTION get_movie_recommendation(genre IN VARCHAR2)
RETURN VARCHAR2;

FUNCTION auto_renew_plan(plan_id IN NUMBER, customer_id IN NUMBER)
RETURN NUMBER;

FUNCTION get_screenlimit_by_customer(customer_id NUMBER)
RETURN screen_limit_row;


END PACKAGE pkg_operation_management;
/
--------------------------------------------------------------------------------------------------------------------------
/
CREATE OR REPLACE PACKAGE pkg_subscription_plan_management as
PROCEDURE ADD_SUBSCRIPTION_PLAN(
    vplanname subscription_plan.planname%type, 
    vplandescription subscription_plan.plandescription%type, 
    vscreenlimit subscription_plan.screenlimit%type);

END PACKAGE pkg_subscription_plan_management;
/

CREATE OR REPLACE FUNCTION REGION_RESTRICTED_MOVIE1(in_customer_id IN NUMBER, in_movie_id in NUMBER) 
Return VARCHAR2
IS
  cust_region VARCHAR2(100);
  movie_region VARCHAR2(100);
  var_movie_id number;
BEGIN
    SELECT m.movieid INTO var_movie_id FROM customer c JOIN address a ON a.CustomerID = c.CustomerID JOIN REGION r ON r.regionname=a.country
    JOIN   Movie m ON m.movieid = r.movieid  WHERE c.CustomerID = in_customer_id AND m.movieid = in_movie_id;
  IF var_movie_id IS NOT null THEN
    DBMS_OUTPUT.PUT_LINE('Play Movie');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Movie is not available in your Region');
  END IF;
END;


-----------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_movie_recommendation(genre IN VARCHAR2)
RETURN VARCHAR2
IS
  Movie_recommendations varchar2(100);
BEGIN
  Movie_recommendations:='';
  for row in (
    SELECT DISTINCT m.movietitle
    FROM movie m
    JOIN (
        SELECT m.genreid, COUNT(*) as total_count
        FROM movie m
        INNER JOIN watch_history w ON m.movieId = w.movieId
        GROUP BY m.genreid
        ORDER BY total_count DESC
        FETCH FIRST 3 ROWS ONLY
    ) g ON m.genreid = g.genreid
    WHERE m.movieId NOT IN (
        SELECT movieId
        FROM watch_history
    )
    FETCH FIRST 10 ROWS ONLY
  ) loop
    Movie_recommendations:=Movie_recommendations || ' ' || row.movietitle;
  end loop;
  RETURN Movie_recommendations;
END;

---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION is_customer_active (Ncustomer_id IN NUMBER)
RETURN VARCHAR2
IS
    c_active VARCHAR2(20);
BEGIN
    SELECT CASE
        WHEN p.enddate >= SYSDATE THEN 'Active'
        ELSE 'Not Active'
    END INTO c_active
    FROM purchase p
    JOIN customer c ON p.customerid = c.customerid
    WHERE c.customerid = Ncustomer_id ; 
    RETURN c_active;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid customer ID');
END;

-------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_avg_rating_movie(p_movietitle IN VARCHAR2)
RETURN NUMBER
IS
  v_avg_rating NUMBER;
BEGIN
  SELECT AVG(ratings) INTO v_avg_rating
  FROM movie where movietitle=p_movietitle;
  
  RETURN v_avg_rating;
END;

---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_movies(p_genre IN VARCHAR2)
RETURN VARCHAR2
IS
  v_movies VARCHAR2(32767); -- increase the size of the variable
BEGIN
  v_movies := '';
  FOR row IN (
    SELECT movietitle 
    FROM movie m
    JOIN genre g ON m.genreID = g.genreID
    WHERE genrename = p_genre
  ) LOOP
    v_movies := v_movies || row.movietitle || ' '; -- concatenate movie titles
  END LOOP;
  
  RETURN v_movies;
END;
------------------------------------------------------------------------------

CREATE OR REPLACE View TopViewed_vw ---- Top 10 viewed        movies
AS
SELECT m.Movietitle, COUNT(*)AS Views
FROM db_admin.watch_History h
JOIN db_admin.Movie m ON h.MovieID=m.MovieID
GROUP BY m.Movietitle
ORDER BY COUNT(*) DESC
FETCH FIRST 10 ROWS ONLY;       

SELECT * FROM TopViewed_vw;
       
       
       
CREATE OR REPLACE View NoUsers_region_vw ----Number of Users regionwise
   AS
   SELECT a.Country, count(c.CustomerID) as No_Users
   FROM db_admin.Customer c
   JOIN db_admin.ADDRESS a on c.customerid = a.customerid
   GROUP BY (a.Country)
   ORDER BY COUNT(*) DESC;
       
   SELECT * FROM NoUsers_region_vw;
       
       
       
CREATE OR REPLACE View LeastViewed_vw ----Least viewed movies regionwise
AS
SELECT m.movietitle, COUNT(*)AS Views
	FROM db_admin.WATCH_History h
	LEFT JOIN db_admin.Movie m ON h.MovieID=m.MovieID
	GROUP BY m.movietitle
    Having count(*) = 1
	ORDER BY COUNT(*) ASC;
SELECT * FROM LeastViewed_vw;
    
    
              
CREATE OR REPLACE View CountryContent_vw  ----countrywise content production
       AS
       SELECT CountryOrigin, Count(*) as Production
       FROM db_admin.Movie
       GROUP BY CountryOrigin
       ORDER BY Count(*) DESC;
       
       SELECT * FROM CountryContent_vw;
       
       
       
CREATE OR REPLACE View MostWatchGenre_vw ----Most watched genre
       As
       SELECT g.GenreName, Count(*) as GViews
       FROM db_admin.Genre g
       JOIN db_admin.Movie m on g.GenreID = m.GenreID
       JOIN db_admin.WATCH_History h on m.MovieID = h.MovieID
       GROUP BY g.GenreName
       ORDER BY Count(*) DESC;
       
       SELECT * FROM MostWatchGenre_vw;



CREATE OR REPLACE VIEW AgeDemographics_vw ----- Age demographics genre
	AS
SELECT
  	CASE
	WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, c.DATEOFBIRTH) / 12) BETWEEN 18 AND 25 THEN '18-25'
   	 WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, c.DATEOFBIRTH) / 12) BETWEEN 26 AND 40 THEN '26-40'
   	 ELSE '41-70'
  END AS AgeRange, g.GenreName, COUNT(*) AS WatchCount
FROM
  db_admin.Customer c
  JOIN db_admin.watch_history h ON c.Customerid = h.customerid
  JOIN db_admin.movie m ON h.Movieid = m.Movieid
  JOIN db_admin.genre g ON m.Genreid = g.GenreID
GROUP BY
  CASE
    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, c.DATEOFBIRTH) / 12) BETWEEN 18 AND 25 THEN '18-25'
    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, c.DATEOFBIRTH) / 12) BETWEEN 26 AND 40 THEN '26-40'
    ELSE '41-70'
  END,
  g.GenreName
ORDER BY
  AgeRange, WatchCount DESC;

SELECT * FROM AGEDEMOGRAPHICS_VW;



CREATE or REPLACE VIEW RetentionRate_vw --- Retention Rate of last month
AS
SELECT 
  TRUNC(s1.startdate, 'MONTH') AS month,
  COUNT(DISTINCT s1.customerid) AS starting_customers,
  COUNT(DISTINCT s2.customerid) AS returning_customers,
  CEIL(COUNT(DISTINCT s2.customerid) / COUNT(DISTINCT s1.customerid)*100) AS retention_rate
FROM db_admin.purchase s1
LEFT JOIN db_admin.purchase s2 ON s2.customerid = s1.customerid
AND s2.startdate > s1.startdate
AND s2.startdate <= Add_months(s1.startdate, 1)
GROUP BY TRUNC(s1.startdate, 'MONTH')
order by returning_customers desc;
SELECT * FROM RetentionRate_vw;



CREATE OR REPLACE VIEW MovieCatalogue_vw  --- Customer view
AS
SELECT MovieTITLE, GenreName, 
       listagg(ActorFIRSTName ||' '|| ACTORLASTNAME, ', ') WITHIN GROUP (ORDER BY ActorFIRSTName ||' '|| ACTORLASTNAME) AS Actors,
       DirectorFIRSTName, DirectorLASTName
FROM db_admin.Movie m 
JOIN db_admin.Genre g ON m.GenreID = g.GenreID
JOIN db_admin.Director d ON d.DirectorID = m.DirectorID
JOIN db_admin.movie_Cast c ON c.MovieID = m.MovieID
JOIN db_admin.Actor a ON a.ActorID = c.ActorID
GROUP BY MovieTITLE, GenreName, DirectorFIRSTName, DirectorLASTName
ORDER BY Movietitle;

SELECT * FROM moviecatalogue_vw;


       
CREATE OR REPLACE VIEW ActiveUsers_vw --- Active users in this month
AS
SELECT 
    TO_CHAR(creationdate, 'YYYY-MM') AS registration_month,
    COUNT(*) AS active_users
FROM 
    db_admin.customer
GROUP BY 
    TO_CHAR(creationdate, 'YYYY-MM')
ORDER BY 
    TO_CHAR(creationdate, 'YYYY-MM');

CREATE OR REPLACE VIEW topMovieswatchlist ------ movies in watchlist
AS
SELECT m.Movietitle, count(w.movieid) as in_watchlist
from db_admin.movie m
join db_admin.watchlist w on m.movieid = w.movieid
group by m.movietitle
order by count(w.movieid) desc;

select * From topMovieswatchlist;       
       

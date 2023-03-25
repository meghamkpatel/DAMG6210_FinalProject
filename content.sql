CREATE OR REPLACE View TopViewed_vw ---- Top 10 viewed        movies
AS
SELECT m.Movietitle, COUNT(*)AS Views
FROM db_admin.watch_history h
JOIN db_admin.Movie m ON h.MovieID=m.MovieID
GROUP BY m.Movietitle
ORDER BY COUNT(*) DESC
FETCH FIRST 10 ROWS ONLY;       

SELECT * FROM TopViewed_vw;

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

CREATE OR REPLACE VIEW topMovieswatchlist ------ movies in watchlist
AS
SELECT m.Movietitle, count(w.movieid) as in_watchlist
from db_admin.movie m
join db_admin.watchlist w on m.movieid = w.movieid
group by m.movietitle
order by count(w.movieid) desc;

select * From topMovieswatchlist;
       
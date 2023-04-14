--Least Viewed Movies

SELECT m.movietitle, COUNT(*)AS Views
	FROM WATCH_History h
	LEFT JOIN Movie m ON h.MovieID=m.MovieID
	GROUP BY m.movietitle
	ORDER BY COUNT(*) ASC
	FETCH FIRST 20 ROWS ONLY;
 
 --Age Demographic

 SELECT
  	CASE
	WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, c.DATEOFBIRTH) / 12) BETWEEN 18 AND 25 THEN '18-25'
   	 WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, c.DATEOFBIRTH) / 12) BETWEEN 26 AND 40 THEN '26-40'
   	 ELSE '41-70'
  END AS AgeRange, g.GenreName, COUNT(*) AS WatchCount
FROM
  Customer c
  JOIN watch_history h ON c.Customerid = h.customerid
  JOIN movie m ON h.Movieid = m.Movieid
  JOIN genre g ON m.Genreid = g.GenreID
GROUP BY
  CASE
    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, c.DATEOFBIRTH) / 12) BETWEEN 18 AND 25 THEN '18-25'
    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, c.DATEOFBIRTH) / 12) BETWEEN 26 AND 40 THEN '26-40'
    ELSE '41-70'
  END,
  g.GenreName
ORDER BY
  AgeRange, WatchCount DESC

  -- Most watched Genre 

  SELECT g.GenreName, Count(*) as GViews
       FROM Genre g
       JOIN Movie m on g.GenreID = m.GenreID
       JOIN WATCH_History h on m.MovieID = h.MovieID
       GROUP BY g.GenreName
       ORDER BY Count(*) DESC

-- Movie catalogue 

SELECT MovieTITLE, GenreName, ActorFIRSTName,ACTORLASTNAME, DirectorFIRSTName, DirectorLASTName
FROM Movie m 
JOIN Genre g ON m.MovieID = g.GenreID
JOIN Director d ON d.DirectorID = m.DirectorID
JOIN movie_Cast c ON c.MovieID = m.MovieID
JOIN Actor a ON a.ActorID = c.ActorID
ORDER BY Movietitle

--No. of users by region 

SELECT Country, count(a.CustomerID) as users
FROM Customer c
Join address a on c.customerid = a.customerid
GROUP BY rollup(Country)

--Top viewed movies 

SELECT m.Movietitle, COUNT(*) AS Views
  FROM watch_History h
  JOIN Movie m ON h.MovieID = m.MovieID
  GROUP BY m.Movietitle
  ORDER BY COUNT(*) DESC
  FETCH FIRST 10 ROWS ONLY
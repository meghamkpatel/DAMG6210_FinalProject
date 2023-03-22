/*
 * Team 11
 * Megha Patel, Sonali Godade, Utkarsh Naik, Disha Sanil, Sachit Wagle
 * 
 * */
DROP DATABASE TEAM11_Streaming_Service
GO

CREATE DATABASE TEAM11_Streaming_Service
GO

USE TEAM11_Streaming_Service

/*users password column encryption*/
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'Team11_Admin'

-- Create certificate to protect symmetric key
CREATE CERTIFICATE Team11_Certificate
WITH SUBJECT = 'Project Team11 Certificate',
EXPIRY_DATE = '2030-03-21'

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY Team11_SymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE Team11_Certificate

-- Open symmetric key
OPEN SYMMETRIC KEY Team11_SymmetricKey
DECRYPTION BY CERTIFICATE Team11_Certificate
----------------------------------------------------------------
/*
 * Create Table
 */

CREATE TABLE Watchlist
(
	WatchlistID INT IDENTITY(10000, 1) NOT NULL PRIMARY KEY,
	MovieID INT NOT NULL REFERENCES Movie(MovieID),
	CustomerID INT NOT NULL REFERENCES Customer(CustomerID)
)

CREATE TABLE Movie
(
	MovieID INT IDENTITY(5000,1) NOT NULL PRIMARY KEY,
	GenreID INT NOT NULL REFERENCES Genre(GenreID),
	DirectorID INT NOT NULL REFERENCES Director(DirectorID),
	MovieTitle VARCHAR(1000) NOT NULL,
	DateOfRelease DATETIME NOT NULL,
	Duration TIMESTAMP NOT NULL,
	MovieDescription VARCHAR(MAX)NOT NULL,
	Ratings NUMBER(1,1),
	Region VARCHAR(100) NOT NULL
)

CREATE TABLE Customer
(
	CustomerID INT IDENTITY(5000,1) NOT NULL PRIMARY KEY,
	FirstName VARCHAR(1000) NOT NULL,
	LastName VARCHAR(1000) NOT NULL,
	Email VARCHAR(1000) NOT NULL,
	DateOfBirth Date NOT NULL,
	Gender VARCHAR(50) NOT NULL,
	Username VARCHAR(1000) NOT NULL,
	UserPassword VARCHAR(1000) NOT NULL,
	CustomerStatus VARCHAR(45) NOT NULL CHECK (CustomerStatus IN ('ACTIVE', 'NOT ACTIVE')),
	CreationDate TIMESTAMP NOT NULL
)

CREATE TABLE [Address]
(
	CustomerID INT NOT NULL REFERENCES Customer(CustomerID),
	Address1 VARCHAR(1000) NOT NULL,
	Address2 VARCHAR(1000) NOT NULL,
	City VARCHAR(1000) NOT NULL,
	State VARCHAR(1000) NOT NULL,
	Country VARCHAR(1000) NOT NULL,
	Pincode VARCHAR(1000) NOT NULL

)

CREATE TABLE Movie_Plan
(
	PlanID INT IDENTITY(20,1) NOT NULL PRIMARY KEY,
	PlanName VARCHAR(1000) NOT NULL,
	PlanDescription VARCHAR(1000) NOT NULL,
	ScreenLimit INT(1) NOT NULL
)

CREATE TABLE Purchase 
(
	PurchaseID INT IDENTITY(9000,1) NOT NULL PRIMARY KEY,
	PlanID INT NOT NULL REFERENCES Movie_Plan(PlanID),
	CustomerID INT NOT NULL REFERENCES Customer(CustomerID),
	StartDate TIMESTAMP NOT NULL,
	EndDate TIMESTAMP NOT NULL
)

CREATE TABLE Download
(
	DownloadID INT IDENTITY(4000,1) NOT NULL PRIMARY KEY,
	MovieID INT NOT NULL REFERENCES Movie(MovieID),
	CustomerID INT NOT NULL REFERENCES Customer(CustomerID),
	DateOfDownload TIMESTAMP
)


CREATE TABLE Favorite
(
	FavoriteID INT IDENTITY(4000,1) NOT NULL PRIMARY KEY,
	MovieID INT NOT NULL REFERENCES Movie(MovieID),
	CustomerID INT NOT NULL REFERENCES Customer(CustomerID)

)

CREATE TABLE History
(
	HistoryID INT IDENTITY(4000,1) NOT NULL PRIMARY KEY,
	MovieID INT NOT NULL REFERENCES Movie(MovieID),
	CustomerID INT NOT NULL REFERENCES Customer(CustomerID),
	Watchtime TIMESTAMP

)

CREATE TABLE Director
(
	DirectorID INT IDENTITY(4000,1) NOT NULL PRIMARY KEY,
	DirectorFirstName VARCHAR(1000) NOT NULL,
	DirectorLastName VARCHAR(1000) NOT NULL
)

CREATE TABLE Subtitles
(
	SubtitlesID INT IDENTITY(4000,1) NOT NULL PRIMARY KEY,
	MovieID INT NOT NULL REFERENCES Movie(MovieID),
	Text VARCHAR(MAX),
	Language VARCHAR(100)
)

CREATE TABLE Genre
(
	GenreID INT IDENTITY(200,1) NOT NULL PRIMARY KEY,
	GenreName VARCHAR(1000) NOT NULL
)

CREATE TABLE Movie_Cast
(
	MovieID INT NOT NULL REFERENCES Movie(MovieID),
	ActorID INT NOT NULL REFERENCES Actor(ActorID)
)

CREATE TABLE Actor
(
	ActorID INT IDENTITY(10000,1) NOT NULL PRIMARY KEY,
	ActorFirstName VARCHAR(1000) NOT NULL,
	ActorLastName VARCHAR(1000) NOT NULL
)

GO

/*
 * Create Function
 */
-- Constraint Account.AccountType
CREATE FUNCTION dbo.CheckAccType (@AccType VARCHAR(45))
RETURNS SMALLINT
AS
BEGIN
    DECLARE @Flag SMALLINT
    IF @AccType IN ('Customer', 'Admin')
        SET @Flag = 1
    ELSE
        SET @Flag = 0

    RETURN @Flag
END
GO

ALTER TABLE Account ADD CONSTRAINT BanBadInput CHECK (dbo.CheckAccType(AccountType) = 1)
GO
-- Calculate the total number of active users by region
-- Calculate the most viewed movies within the past month by region
-- Calculate the total revenue made in the last year
-- Calculate the number of new users per month
-- Calculate the number of users who have bought another subscription
-- Calculate the most loyal customers and how much money the company made (retention)
-- Calculate demographics: age group by movie, region by  most watched genre
-- 



CREATE USER DB_ADMIN IDENTIFIED BY "DUSMS@2023dmdd";
GRANT CREATE VIEW TO DB_ADMIN;

CREATE USER DB_CONTENTMGR IDENTIFIED BY "DUSMS@2023cm";
GRANT CREATE VIEW TO DB_CONTENTMGR;

CREATE USER DB_BILLINGMGR IDENTIFIED BY "DUSMS@2023bm";
GRANT CREATE VIEW TO DB_BILLINGMGR;

CREATE USER DB_ANALYST IDENTIFIED BY "DUSMS@2023analyst";
GRANT CREATE VIEW TO DB_ANALYST;

CREATE USER DB_MANAGER IDENTIFIED BY "DUSMS@2023dman";
GRANT CREATE VIEW TO DB_MANAGER;

SELECT * FROM USER_TABLES;

GRANT CONNECT, RESOURCE TO DB_ADMIN;
GRANT CREATE SESSION TO DB_ADMIN;
GRANT UNLIMITED TABLESPACE TO DB_ADMIN;

GRANT CONNECT TO DB_CONTENTMGR;

GRANT CONNECT TO DB_BILLINGMGR;

GRANT CONNECT TO DB_ANALYST;

GRANT CONNECT TO DB_MANAGER;


create sequence movie_seq;
create sequence customer_seq;
create sequence genre_seq;
create sequence director_seq;
create sequence watchlist_seq;
create sequence favorite_seq;
create sequence download_seq;
create sequence watchhistory_seq;
create sequence address_seq;
create sequence subtitle_seq;
create sequence actor_seq;
create sequence purchase_seq;
create sequence region_seq;
create sequence plan_seq;

# Introduction

# SQL Quries

###### Table Setup (DDL)
##### Members Table
```
CREATE TABLE cd.members
    (
       memid integer NOT NULL, 
       surname character varying(200) NOT NULL, 
       firstname character varying(200) NOT NULL, 
       address character varying(300) NOT NULL, 
       zipcode integer NOT NULL, 
       telephone character varying(20) NOT NULL, 
       recommendedby integer,
       joindate timestamp NOT NULL,
       CONSTRAINT members_pk PRIMARY KEY (memid),
       CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
            REFERENCES cd.members(memid) ON DELETE SET NULL
    );
```
##### Facilities Table
```
 CREATE TABLE cd.facilities
    (
       facid integer NOT NULL, 
       name character varying(100) NOT NULL, 
       membercost numeric NOT NULL, 
       guestcost numeric NOT NULL, 
       initialoutlay numeric NOT NULL, 
       monthlymaintenance numeric NOT NULL, 
       CONSTRAINT facilities_pk PRIMARY KEY (facid)
    );
```

##### Bookings Table
```
 CREATE TABLE cd.bookings
    (
       bookid integer NOT NULL, 
       facid integer NOT NULL, 
       memid integer NOT NULL, 
       starttime timestamp NOT NULL,
       slots integer NOT NULL,
       CONSTRAINT bookings_pk PRIMARY KEY (bookid),
       CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
       CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
    );
```
##### Modifiying Data Section
###### Question 1
```sql
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) VALUES (9, 'Spa', 20, 30, 100000, 800);
```

###### Questions 2
```sql
insert into cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) SELECT (SELECT max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800; 
```

###### Question 3
```sql
UPDATE cd.facilities SET initialoutlay = 10000 WHERE facid = 1;
```

###### Question 4
```sql
UPDATE cd.facilities
SET 
	membercost = (SELECT membercost*1.1 FROM cd.facilities WHERE facid = 0),
	guestcost = (SELECT guestcost*1.1 FROM cd.facilities WHERE facid = 0)
WHERE facid = 1;
```

###### Question 5
```sql
DELETE FROM cd.bookings;
```

###### Question 6
```sql
DELETE FROM cd.members WHERE memid = 37;
```

##### Basics Section
###### Question 1
```sql
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0 AND membercost < monthlymaintenance/50;
```

###### Question 2
```sql
SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';
```

###### Question 3
```sql
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);
```

###### Question 4
```sql
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= '2012-09-01';
```

###### Question 5
```sql
SELECT surname
FROM cd.members
UNION
SELECT name
FROM cd.facilities;
```


##### Join Section
###### Question 1
```sql
SELECT starttime
FROM cd.bookings
JOIN cd.members
ON cd.members.memid = cd.bookings.memid
WHERE cd.members.firstname = 'David' AND cd.members.surname = 'Farrell';
```

###### Question 2
```sql
SELECT bks.starttime as start, facs.name as name
FROM cd.bookings as bks
JOIN cd.facilities as facs
ON bks.facid = facs.facid
WHERE facs.name in ('Tennis Court 2','Tennis Court 1') AND bks.starttime >= '2012-09-21' AND bks.starttime < '2012-09-22'
ORDER BY bks.starttime;
```

###### Question 3
```sql
SELECT mem.firstname as memfname, mem.surname as memsname, ref.firstname as recfname, ref.surname as recsname
FROM cd.members as mem
LEFT JOIN cd.members as ref
ON ref.memid = mem.recommendedby
ORDER BY memsname, memfname;
```

###### Question 4
```sql
SELECT DISTINCT ref.firstname as firstname, ref.surname as surname
FROM cd.members as ref
JOIN cd.members as mem
ON ref.memid = mem.recommendedby
ORDER BY surname, firstname;
```

###### Question 5
```sql
SELECT DISTINCT mems.firstname || ' ' || mems.surname as member,
(SELECT recs.firstname || ' ' || recs.surname as recommender
 FROM cd.members as recs
 WHERE recs.memid = mems.recommendedby)
FROM cd.members mems
ORDER BY member;
```

##### Aggregates Section


##### String Section
###### Question 1
```sql
SELECT surname || ', ' || firstname as name FROM cd.members;
```

###### Question 2
```sql
SELECT memid, telephone from cd.members where telephone ~ '[()]';
```

###### Question 3
```sql
SELECT substr(mems.surname, 1, 1) as letter, count(*) as count
FROM cd.members as mems
GROUP BY letter
ORDER BY letter;
```
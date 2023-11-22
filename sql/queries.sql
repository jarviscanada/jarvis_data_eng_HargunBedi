INSERT INTO cd.facilities (
  facid, name, membercost, guestcost, 
  initialoutlay, monthlymaintenance
) 
VALUES 
  (9, 'Spa', 20, 30, 100000, 800);


INSERT into cd.facilities (
  facid, name, membercost, guestcost, 
  initialoutlay, monthlymaintenance
) 
SELECT 
  (
    SELECT 
      max(facid) 
    from 
      cd.facilities
  )+ 1, 
  'Spa', 
  20, 
  30, 
  100000, 
  800;


UPDATE 
  cd.facilities 
SET 
  initialoutlay = 10000 
WHERE 
  facid = 1;


UPDATE 
  cd.facilities 
SET 
  membercost = (
    SELECT 
      membercost * 1.1 
    FROM 
      cd.facilities 
    WHERE 
      facid = 0
  ), 
  guestcost = (
    SELECT 
      guestcost * 1.1 
    FROM 
      cd.facilities 
    WHERE 
      facid = 0
  ) 
WHERE 
  facid = 1;



DELETE FROM 
  cd.bookings;

DELETE FROM 
  cd.members 
WHERE 
  memid = 37;

SELECT 
  facid, 
  name, 
  membercost, 
  monthlymaintenance 
FROM 
  cd.facilities 
WHERE 
  membercost > 0 
  AND membercost < monthlymaintenance / 50;

SELECT 
  * 
FROM 
  cd.facilities 
WHERE 
  name LIKE '%Tennis%';

SELECT 
  * 
FROM 
  cd.facilities 
WHERE 
  facid IN (1, 5);

SELECT 
  memid, 
  surname, 
  firstname, 
  joindate 
FROM 
  cd.members 
WHERE 
  joindate >= '2012-09-01';

SELECT 
  surname 
FROM 
  cd.members 
UNION 
SELECT 
  name 
FROM 
  cd.facilities;

SELECT 
  starttime 
FROM 
  cd.bookings 
  JOIN cd.members ON cd.members.memid = cd.bookings.memid 
WHERE 
  cd.members.firstname = 'David' 
  AND cd.members.surname = 'Farrell';

SELECT 
  bks.starttime as start, 
  facs.name as name 
FROM 
  cd.bookings as bks 
  JOIN cd.facilities as facs ON bks.facid = facs.facid 
WHERE 
  facs.name in (
    'Tennis Court 2', 'Tennis Court 1'
  ) 
  AND bks.starttime >= '2012-09-21' 
  AND bks.starttime < '2012-09-22' 
ORDER BY 
  bks.starttime;

SELECT 
  mem.firstname as memfname, 
  mem.surname as memsname, 
  ref.firstname as recfname, 
  ref.surname as recsname 
FROM 
  cd.members as mem 
  LEFT JOIN cd.members as ref ON ref.memid = mem.recommendedby 
ORDER BY 
  memsname, 
  memfname;

SELECT 
  DISTINCT ref.firstname as firstname, 
  ref.surname as surname 
FROM 
  cd.members as ref 
  JOIN cd.members as mem ON ref.memid = mem.recommendedby 
ORDER BY 
  surname, 
  firstname;

SELECT 
  DISTINCT mems.firstname || ' ' || mems.surname as member, 
  (
    SELECT 
      recs.firstname || ' ' || recs.surname as recommender 
    FROM 
      cd.members as recs 
    WHERE 
      recs.memid = mems.recommendedby
  ) 
FROM 
  cd.members mems 
ORDER BY 
  member;

SELECT 
  recommendedby, 
  count(*) 
FROM 
  cd.members 
WHERE 
  recommendedby IS NOT NULL 
GROUP BY 
  recommendedby 
ORDER BY 
  recommendedby ASC;


SELECT 
  facid, 
  SUM(slots) as "Total Slots" 
FROM 
  cd.bookings 
GROUP BY 
  facid 
ORDER BY 
  facid;

SELECT 
  facid, 
  SUM(slots) as "Total Slots" 
FROM 
  cd.bookings 
WHERE 
  starttime >= '2012-09-01' 
  AND starttime < '2012-10-01' 
GROUP BY 
  facid 
ORDER BY 
  "Total Slots";

SELECT 
  facid, 
  EXTRACT(
    month 
    from 
      starttime
  ) as month, 
  SUM(slots) as "Total Slots" 
FROM 
  cd.bookings 
WHERE 
  EXTRACT(
    year 
    from 
      starttime
  ) = 2012 
GROUP BY 
  facid, 
  month 
ORDER BY 
  facid, 
  month;

SELECT 
  count(distinct memid) 
from 
  cd.bookings;

SELECT 
  mem.surname, 
  mem.firstname, 
  mem.memid, 
  min(bks.starttime) as starttime 
FROM 
  cd.members as mem 
  JOIN cd.bookings as bks ON mem.memid = bks.memid 
WHERE 
  starttime >= '2012-09-01' 
GROUP by 
  mem.surname, 
  mem.firstname, 
  mem.memid 
ORDER BY 
  mem.memid;

SELECT 
  COUNT(*) over(), 
  firstname, 
  surname 
FROM 
  cd.members 
ORDER BY 
  joindate;

SELECT 
  row_number() over(), 
  firstname, 
  surname 
FROM 
  cd.members 
ORDER BY 
  joindate;

SELECT 
  facid, 
  total 
FROM 
  (
    SELECT 
      facid, 
      sum(slots) total, 
      rank() over (
        ORDER BY 
          sum(slots) DESC
      ) rank 
    from 
      cd.bookings 
    GROUP BY 
      facid
  ) as ranked 
WHERE 
  rank = 1;

SELECT 
  surname || ', ' || firstname as name 
FROM 
  cd.members;

SELECT 
  memid, 
  telephone 
from 
  cd.members 
where 
  telephone ~ '[()]';

SELECT 
  substr(mems.surname, 1, 1) as letter, 
  count(*) as count 
FROM 
  cd.members as mems 
GROUP BY 
  letter 
ORDER BY 
  letter;
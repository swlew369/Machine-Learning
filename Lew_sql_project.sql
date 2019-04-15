/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name FROM `Facilities` WHERE membercost != 0

Result: Tennis Court1, Tennis Court 2, Massage Room 1,
Massage Room 2, Squash Court


/* Q2: How many facilities do not charge a fee to members? */
	
		4

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT name,membercost,monthlymaintenance FROM `Facilities`
 WHERE membercost < 0.2*monthlymaintenance

Result:
 name					    membercost			monthlymaintenance
Tennis Court 1				5.0					         200
Tennis Court 2				5.0					         200
Badminton Court				0.0					          50
Table Tennis			  	0.0					          10
Massage Room 1				9.9					        3000
Massage Room 2				9.9					        3000
Squash Court			  	3.5					          80
Snooker Table			  	0.0					          15
Pool Table				  	0.0					          15


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
	SELECT *
	FROM `Facilities`
	WHERE facid IN (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */


SELECT name,monthlymaintenance,
CASE WHEN monthlymaintenance > 100 THEN 'expensive'
ELSE 'cheap' END AS mon_cost_rating
FROM `Facilities`


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname,surname FROM `Members`
ORDER BY joindate DESC

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT
    CONCAT(f.name,'_',CONCAT(m.firstname,'_',m.surname)) AS court_and_member
 	FROM Bookings b
    JOIN Members m
    ON b.memid = m.memid
    JOIN Facilities f
    ON f.facid = b.facid
   ORDER BY m.surname


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT  CONCAT(f.name,'_',CONCAT(m.firstname,'_',m.surname)) AS court_and_user,
      CASE WHEN m.memid != 0 THEN f.membercost * b.slots
      ELSE f.guestcost * b.slots END AS total_cost
   	FROM Bookings b
      JOIN Members m
      ON b.memid = m.memid
      JOIN Facilities f
      ON f.facid = b.facid
      WHERE DATE(b.starttime) = '2012-09-14' AND
      (((m.memid != 0) AND (f.membercost * b.slots > 30)) OR ((m.memid = 0) AND (f.guestcost * b.slots > 30)))
      ORDER BY total_cost DESC
      


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT CONCAT(f.name,'_',CONCAT(m.firstname,'_',m.surname)) AS court_and_user,
CASE WHEN m.memid != 0  THEN f.membercost * sub.slots
        WHEN m.memid = 0 THEN f.guestcost * sub.slots
        ELSE NULL END AS total_cost
FROM Facilities f
JOIN (SELECT memid,facid,slots FROM `Bookings` WHERE LEFT(starttime,10) = '2012-09-14') AS sub
ON f.facid = sub.facid
JOIN Members m
ON m.memid = sub.memid
WHERE (((m.memid != 0) AND (f.membercost * sub.slots > 30)) OR ((m.memid = 0) AND (f.guestcost * sub.slots > 30)))
ORDER BY total_cost DESC

# Alternate Version using Subquery
SELECT * FROM (
SELECT
CONCAT(f.name,'_',CONCAT(m.firstname,'_',m.surname)) AS    court_and_user,
      CASE WHEN m.memid != 0 THEN f.membercost * b.slots
      ELSE f.guestcost * b.slots END AS total_cost
   	FROM Bookings b
      JOIN Members m
      ON b.memid = m.memid
      JOIN Facilities f
      ON f.facid = b.facid
      WHERE DATE(b.starttime) = '2012-09-14'

      ) AS q

WHERE total_cost > 30
ORDER BY total_cost DESC



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT * FROM (SELECT f.name,
CASE WHEN m.memid != 0 THEN SUM(f.membercost * b.slots)
      ELSE SUM(f.guestcost * b.slots) END AS total_revenue
FROM Bookings b
JOIN Members m
   ON b.memid = m.memid
JOIN Facilities f
    ON f.facid = b.facid
  GROUP BY f.name) AS q
WHERE q.total_revenue < 1000
ORDER BY q.total_revenue DESC

Result:

name				total_revenue
Table Tennis			0.0
Pool Table				0.0
Badmington Court		0.0
Snooker Table			0.0
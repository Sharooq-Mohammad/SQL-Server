use mydb;

--Problem 1:
create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

with cte  as (
select Team_1 as team, 
CASE Team_1
	when Winner then 1
	else 0
End as point
from icc_world_cup
union all
select Team_2 as team, 
CASE Team_2
	when Winner then 1
	else 0
End as point
from icc_world_cup)

select team, count(team) matches_played, sum(point) no_of_wins, count(team)-sum(point) no_of_losses from cte
group by team;

--Problem 2:
create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;

select * from customer_orders;

with cte as (
select customer_id, min(order_date) join_date
from customer_orders
group by customer_id)

select order_date,
sum(case when order_date = join_date then 1 else 0 end) as new_customer,
sum(case when join_date is null then 1 else 0 end) as existing_customer
from cte
right join customer_orders c on cte.join_date = c.order_date and cte.customer_id=c.customer_id
group by order_date;


--Problem-3

create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR');

select * from entries;

with most_visited_floor as (
select name, floor, count(1) no_of_visits, rank() over(partition by name order by count(*) desc) rn  --count is applied on group by, rank is applied on partition by (after group by runs)
from entries
group by name, floor
),
distinct_resources as(
select distinct name, resources
from entries
),
agg_resources as (
select name, STRING_AGG(resources, ',') resources_used
from distinct_resources
group by name
),
total_visits as (
select name, count(*) no_of_visits
from entries
group by name
)
select tv.name, tv.no_of_visits, mvf.floor, ar.resources_used from most_visited_floor mvf
inner join total_visits tv on mvf.name = tv.name
inner join agg_resources ar on tv.name = ar.name
where mvf.rn=1

use mydb;

--Problem -4

declare @today_date date;
declare @n int;
set @today_date = '2024-8-12';
set @n = 3

select dateadd(week, @n - 1, DATEADD(day, (8 - datepart(WEEKDAY, @today_date)), @today_date));

--Problem -5

Create table friend (pid int, fid int)
insert into friend (pid , fid ) values ('1','2');
insert into friend (pid , fid ) values ('1','3');
insert into friend (pid , fid ) values ('2','1');
insert into friend (pid , fid ) values ('2','3');
insert into friend (pid , fid ) values ('3','5');
insert into friend (pid , fid ) values ('4','2');
insert into friend (pid , fid ) values ('4','3');
insert into friend (pid , fid ) values ('4','5');
create table person (PersonID int,	Name varchar(50),	Score int)
insert into person(PersonID,Name ,Score) values('1','Alice','88')
insert into person(PersonID,Name ,Score) values('2','Bob','11')
insert into person(PersonID,Name ,Score) values('3','Devis','27')
insert into person(PersonID,Name ,Score) values('4','Tara','45')
insert into person(PersonID,Name ,Score) values('5','John','63')

select * from person
select * from friend

select p.PersonID, p.Name, COUNT(f.fid) no_of_friends, SUM(p.Score) sum_of_marks from person p 
left join friend f on p.PersonID = f.pid
left join person p2 on f.fid = p2.PersonID
group by p.PersonID, p.Name
having SUM(p2.score)>100;

use data;

with cte as (
select product_id, SUM(list_price) total_sales,
SUM(SUM(list_price)) over(order by SUM(list_price) DESC rows between unbounded preceding and current row) running_sum
from sales.order_items
group by product_id
)
select * from cte
where running_sum <= (select SUM(total_sales)*0.8 from cte)

--Problem-6

Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users (users_id int, banned varchar(50), role varchar(50));
Truncate table Trips;
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
Truncate table Users;
insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

select * from trips;
select * from users;

select request_at,
cast(count(
	case LEFT(status, 9)
	when 'cancelled' then 1
	else null
	end
) as decimal) / count(1) * 100 cancellation_rate
from Trips t
join users c on t.client_id = c.users_id
join users d on t.driver_id = d.users_id
where c.banned = 'No' and d.banned = 'No'
group by request_at

--Problem-7

create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

select * from players;
select * from matches;

with cte as (
select first_player player, first_score score
from matches
union all
select second_player, second_score
from matches),

ranking as (select player, group_id, SUM(score) total_score,
RANK() over(partition by group_id order by sum(score) desc, player asc) rk
from cte join players on players.player_id = cte.player
group by player, group_id)

select * from ranking
where rk = 1;

--Problem -8

create table users2 (
 user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users2 values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

select * from orders;
select * from users2;
select * from items;

with cte as (
select o.*, u.*, i.item_brand,
rank() over (partition by seller_id order by order_date) rk
from orders o
right join users2 u on o.seller_id = u.user_id
left join items i on o.item_id = i.item_id)

select user_id,
case when favorite_brand = item_brand then 'Yes'
else 'No'
end
from cte
where rk =2;


with cte as (
select *,
rank() over (partition by seller_id order by order_date) rk
from orders
)
select user_id,
case when favorite_brand = item_brand then 'Yes'
else 'No'
end item_fav_brand
from cte c
right join users2 u on c.seller_id = u.user_id and rk = 2
left join items i on c.item_id = i.item_id

-- Problem - 9

create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success')

insert into tasks
values ('2019-01-07','success'),('2019-01-08','success');

update tasks
set state = 'fail'
where date_value = '2019-01-07';

with cte as (
select *,
--ROW_NUMBER() over(order by date_value),
--ROW_NUMBER() over(partition by state order by date_value),
ROW_NUMBER() over(order by date_value) - ROW_NUMBER() over(partition by state order by date_value) ki
from tasks)
select MIN(date_value) min_date, MAX(date_value) max_date, state
from cte
group by state, ki
order by min_date;

-- Problem -10

create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

select * from spending;

with cte as (
select spend_date, user_id, MAX(platform) platform, SUM(amount) amount
from spending
group by spend_date, user_id
having COUNT(distinct platform)=1
union all
select spend_date, user_id, 'both' platform, SUM(amount) amount
from spending
group by spend_date, user_id
having COUNT(distinct platform)=2
union all
select spend_date, null, 'both' platform, 0 amount
from spending)

select spend_date, platform, SUM(amount) amount, count(user_id) user_count
from cte
group by spend_date, platform
order by spend_date, platform desc;

--Random Problem

CREATE TABLE orders1 (
    order_id INT PRIMARY KEY,
    item VARCHAR(255) NOT NULL
);

INSERT INTO orders1(order_id, item) VALUES
(1, 'Chow Mein'),
(2, 'Pizza'),
(3, 'Veg Nuggets'),
(4, 'Paneer Butter Masala'),
(5, 'Spring Rolls'),
(6, 'Veg Burger'),
(7, 'Paneer Tikka');

with cte as (
select *,
LAG(item) over(order by order_id) prev,
LEAD(item) over(order by order_id) nxt
from orders1)
select order_id,
case
when order_id%2 = 1 and nxt is not null then nxt
when order_id%2 = 0 then prev
else item
end correct_order
from cte;

with cte as (
select COUNT(order_id) countoforders
from orders1)
select
case 
when order_id = countoforders then order_id
when order_id%2 != 0 then order_id+1
else order_id-1
end corrected_order_id,
item
from orders1
cross join cte
order by corrected_order_id



with cte as (
select 1 as num
union all
select num+1 as num
from cte
where num<10
)

select * from cte
option (maxrecursion 1000)

select  DATENAME(WEEKDAY, 0)

--Problem -11

create table sales (
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);

use master
select * from sales;

with cte as (
select MIN(period_start) min_date, MAX(period_end) max_date from sales
union all
select DATEADD(day, 1, min_date), max_date from cte
where min_date < max_date)
select product_id, DATEPART(YEAR, min_date), SUM(average_daily_sales) from cte c
left join sales s on c.min_date >= s.period_start and c.min_date <= s.period_end
group by product_id, DATEPART(YEAR, min_date)
order by product_id
option (maxrecursion 1000)

-- Problem 12

use mydb;
drop table if exists orders;

create table orders
(
order_id int,
customer_id int,
product_id int,
);

insert into orders VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products (
id int,
name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

select * from orders;
select * from products;

select p1.name + ' ' + p2.name pair, count(*) freq
select *
from orders o1 join orders o2 on o1.order_id = o2.order_id and o1.product_id<o2.product_id
inner join products p1 on p1.id = o1.product_id
inner join products p2 on p2.id = o2.product_id
group by p1.name + ' ' + p2.name;

--Problem - 30

create table players_location
(
name varchar(20),
city varchar(20)
);
delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');

with cte as (
select *,
ROW_NUMBER() over(partition by city order by name) rnk
from players_location)
select
max(case when city = 'Bangalore' then name end) as 'Bangalore',
min(case when city = 'Mumbai' then name end) as 'Mumbai',
min(case when city = 'Delhi' then name end) as 'Delhi'
from cte
group by rnk
order by rnk;

SELECT Bangalore, Mumbai, Delhi
FROM (
SELECT *
      ,ROW_NUMBER() OVER(PARTITION BY city ORDER BY name ASC) AS rnk
FROM players_location
) AS a
PIVOT(MIN(name) FOR city in (Bangalore, Mumbai, Delhi)) AS b
ORDER BY rnk;

create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150)
;

select DATEPART(MONTH, this_month.order_date) Mon, COUNT(distinct last_month.cust_id) Cust_Reten
from transactions this_month left join transactions last_month 
on last_month.cust_id = this_month.cust_id and DATEDIFF(MONTH, last_month.order_date, this_month.order_date) =1
group by DATEPART(MONTH, this_month.order_date)

select DATEPART(MONTH, last_month.order_date) Mon, COUNT(case when this_month.cust_id is null then 1 else null end)
from transactions last_month left join transactions this_month
on last_month.cust_id = this_month.cust_id and DATEDIFF(MONTH, last_month.order_date, this_month.order_date) =1
group by DATEPART(MONTH, last_month.order_date)

create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');

with cte as (
select *,
RANK() over(partition by username order by startdate desc) rk,
count(*) over(partition by username) cnt
from UserActivity)
select * from cte
where rk = 2 or cnt = 1;

select * from UserActivity;

create table billings 
(
emp_name varchar(10),
bill_date date,
bill_rate int
);
delete from billings;
insert into billings values
('Sachin','01-JAN-1990',25)
,('Sehwag' ,'01-JAN-1989', 15)
,('Dhoni' ,'01-JAN-1989', 20)
,('Sachin' ,'05-Feb-1991', 30)
;

create table HoursWorked 
(
emp_name varchar(20),
work_date date,
bill_hrs int
);
insert into HoursWorked values
('Sachin', '01-JUL-1990' ,3)
,('Sachin', '01-AUG-1990', 5)
,('Sehwag','01-JUL-1990', 2)
,('Sachin','01-JUL-1991', 4)

with cte as (
select *,
DATEADD(DAY, -1, LEAD(bill_date, 1, '9999-12-31') over(partition by emp_name order by bill_date)) till 
from billings)
select HoursWorked.emp_name, SUM(HoursWorked.bill_hrs * cte.bill_rate) totalcharges
from HoursWorked inner join cte
on HoursWorked.emp_name = cte.emp_name and HoursWorked.work_date between cte.bill_date and cte.till
group by HoursWorked.emp_name;

with cte as (
select hw.*, bl.bill_rate,
RANK() over(partition by hw.emp_name, work_date order by bill_date desc) rk
from HoursWorked hw inner join billings bl
on hw.emp_name = bl.emp_name and hw.work_date >= bl.bill_date)
select emp_name, SUM(bill_hrs*bill_rate) totalcharges
from cte
where rk = 1
group by emp_name;

-- Problem -19

CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

select event_date, count(distinct user_id) active_users from activity
group by event_date;

select datepart(WEEK, event_date) week_number, count(distinct user_id) active_users from activity
group by datepart(WEEK, event_date);

--select event_date, count (user_id) no_of_users_purchase_sameday from (
--select event_date, user_id, COUNT(*) activity_count from activity
--group by event_date, user_id
--having COUNT(*) =2) a
--group by event_date;

select event_date, count (new_user) no_of_users_purchase_sameday from (
select event_date, user_id, case when COUNT(distinct event_name)=2 then user_id else null end new_user from activity
group by event_date, user_id
-- having COUNT(*) =2
) a
group by event_date;

select case when country in ('India', 'USA') then country else 'Others' end country, count(*)*100./(select count(*) from activity where event_name = 'app-purchase') perc_users from activity
where event_name = 'app-purchase'
group by case when country in ('India', 'USA') then country else 'Others' end;

select event_date, COUNT(case when DATEDIFF(DAY, installed_date, event_date) = 1 then 1 else null end) cnt_users
from (
select *,
LAG(event_date) over(partition by user_id order by event_date) installed_date
from activity) a
group by event_date
;

--Prob - 20

create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');

with cte as (
select *,
seat_no - ROW_NUMBER() over(order by seat_no) dif
from bms
where is_empty = 'Y')
, counter as (
select *,
COUNT(*) over(partition by dif) cnt
from cte)
select seat_no
from counter
where cnt>=3;

with cte as (
select *,
LAG(is_empty, 2) over(order by seat_no) prev_2,
LAG(is_empty, 1) over(order by seat_no) prev_1,
LEAD(is_empty, 1) over(order by seat_no) next_1,
LEAD(is_empty, 2) over(order by seat_no) next_2
from bms)
select seat_no from cte
where is_empty = 'Y' and prev_2 = 'Y' and prev_1 = 'Y'
or is_empty = 'Y' and prev_1 = 'Y' and next_1 = 'Y'
or is_empty = 'Y' and next_1 = 'Y' and next_2 = 'Y';

with cte as (
select *,
sum(case when is_empty = 'Y' then 1 else 0 end) over(order by seat_no rows between 2 preceding and current row) prev_2,
sum(case when is_empty = 'Y' then 1 else 0 end) over(order by seat_no rows between 1 preceding and 1 following) prev_next_1,
sum(case when is_empty = 'Y' then 1 else 0 end) over(order by seat_no rows between current row and 2 following) next_2
from bms)
select seat_no
from cte
where prev_2 = 3 or prev_next_1 = 3 or next_2 = 3
;

--Probl - 21

CREATE TABLE STORES (
Store varchar(10),
Quarter varchar(10),
Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

with cte as (
select distinct s1.Store, s2.Quarter 
from STORES s1, STORES s2)
select c.Store, c.Quarter from cte c
left join STORES s
on s.Store = c.Store and s.Quarter = c.Quarter
where s.Store is null;

with cte as (
select distinct Store, 1 as q_no from STORES
union all
select store, q_no + 1 from cte
where q_no <= 3),
full_data as (
select Store, CONCAT('Q', CAST(q_no as varchar)) Quarter from cte)
select c.Store, c.Quarter from full_data c
left join STORES s
on s.Store = c.Store and s.Quarter = c.Quarter
where s.Store is null;

select Store, CONCAT('Q', CAST(10 - SUM(CAST(RIGHT(Quarter, 1) as int)) as VARCHAR )) Quarter from STORES
group by Store;

--Problem - 22

create table exams (student_id int, subject varchar(20), marks int);
delete from exams;
insert into exams values (1,'Chemistry',91),(1,'Physics',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80)
,(4,'Chemistry',71),(4,'Physics',54);

select * 
from exams e1
join exams e2 on e1.student_id = e2.student_id and e1.subject < e2.subject
where e1.marks = e2.marks;

select student_id, MIN(marks) marks from exams
where subject in ('Chemistry', 'Physics')
group by student_id
--having COUNT(distinct subject)=2 and MIN(marks) = MAX(marks)
having COUNT(distinct subject)=2 and COUNT(distinct marks) = 1


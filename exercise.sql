--- 1.Query all columns for all American cities in the CITY table with populations larger than 100000.
--- The CountryCode for America is USA
select * from city
where countrycode='USA' and population>100000;

--- Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
--- The CountryCode for America is USA.
select name from city
where countrycode='USA' and population>120000;
--- Q3. Query all columns (attributes) for every row in the CITY table
show columns from city;
--- Q4. Query all columns for a city in CITY with the ID 1661
select * from city where id=1661;
--- Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN
select * from city where countrycode='JPN';
--- Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.
select name from city where countrycode='JPN';

--- Q7. Query a list of CITY and STATE from the STATION table.
select city,state from station;

--- Q8. Query a list of CITY names from STATION for cities that have an even ID number. Print the results
--- in any order, but exclude duplicates from the answer.
select distinct(city) as city,id from station 
where id % 2 <>1
order by id;
--- Q9. Find the difference between the total number of CITY entries in the table and the number of
--- distinct CITY entries in the table.
select count(city) - count(distinct(city)) as different_count from station;

--- Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their
--- respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
--- largest city, choose the one that comes first when ordered alphabetically.

select city from station
order by length(city) desc limit 1;
select city from station
order by length(city) limit 1;

--- Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates
select distinct(city) from station
where city like 'a%' or city like 'e%' or city like 'i%' or city like 'o%' or city like 'u%';

--- Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
select distinct(city) from station
where city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u';

--- Q13. Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
select distinct(city) from station
where city not like '%a' or city not like '%e' or city not like '%i' or city not like '%o' or city not like '%u';

--- Q14. Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
select distinct(city) from station
where city not like 'a%' or city not like 'e%' or city not like 'i%' or city not like 'o%' or city not like 'u%';

--- Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
select distinct(city) from station
where city not like 'a%' or city not like 'e%' or city not like 'i%' or city not like 'o%' or city not like 'u%'or 
city not like '%a' or city not like '%e' or city not like '%i' or city not like '%o' or city not like '%u';

--- Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.
select distinct(city) from station
where city not like 'a%' and city not like 'e%' and city not like 'i%' and city not like 'o%' and city not like 'u%' and
city not like '%a' and city not like '%e' and city not like '%i' and city not like '%o' and city not like '%u';

--- 17 Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
--- between 2019-01-01 and 2019-03-31 inclusive. Return the result table in any order


select p.product_id,p.product_name from product p
inner join sales s
on p.product_id = s.product_id
where p.product_name not in (select p.product_name from product p
inner join sales s
on p.product_id = s.product_id 
where s.sale_date>'2019-03-31'); 
--- or 
select product_id,product_name from product 
where product_id not in (select product_id from sales where sale_date not between '2019-01-01' and '2019-03-31' );

--- 18 Write an SQL query to find all the authors that viewed at least one of their own articles.
--- Return the result table sorted by id in ascending order
select distinct author_id as id from Views where author_id = viewer_id
order by author_id asc;


--- 19 If the customers preferred delivery date is the same as the order date, then the order is called
--- immediately; otherwise, it is called scheduled.Write an SQL query to find the percentage of immediate orders 
--- in the table, rounded to 2 decimal places.

select round(((count(*)/(select count(*) from Delivery))*100),2) as immediate_percentage from Delivery
where customer_pref_delivery_date=order_date;
--- or
select round(100*d2.immediate_orders/count(d1.delivery_id), 2) as
immediate_percentage
from Delivery d1,
(select count(order_date) as immediate_orders
from Delivery
where (order_date = customer_pref_delivery_date)) d2;

--- 20 Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
--- Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of atie

select ad_id,
ifnull(
	round(
		avg(
			case
				when action = "Clicked" then 1
				when action = "Viewed" then 0
				else null
			end
		) * 100,
	2),
0) as ctr
 from ads
group by ad_id
order by ctr desc,ad_id asc;

--- 21 Write an SQL query to find the team size of each of the employees.
--- Return result table in any order
select employee_id,
count(*) over(partition by team_id) as team_size
 from employee
 order by team_size desc;
 
 --- 22 Write an SQL query to find the type of weather in each country for November 2019.
--- The type of weather is:
--- Cold if the average weather_state is less than or equal 15,
--- Hot if the average weather_state is greater than or equal to 25, and
--- Warm otherwise.

select c.country_name,
	case when avg(w.weather_state*1.0) <=15 then 'Cold'
		 when avg(w.weather_state*1.0)>=25 then 'Hot'
         else 'Warm'
	end as weather_type
 from countries c
inner join weather w
on c.country_id=w.country_id
where w.day between '2019-11-01' and '2019-11-30'
group by w.country_id;

--- 23 Write an SQL query to find the average selling price for each product. average_price should be
--- rounded to 2 decimal places.

select p.product_id
, round(SUM(u.units * p.price) / SUM(u.units), 2) AS
average_price
 from UnitsSold u
inner join Prices p
on (p.product_id=u.product_id and u.purchase_date>=p.start_date and 
u.purchase_date<=p.end_date)
group by p.product_id;

--- 24 Write an SQL query to report the first login date for each player.
select temp.player_id,temp.event_date from (select *,
row_number() over(partition by player_id order by event_date ) as rn 
 from Activity)temp
where rn=1;

--- 25 Write an SQL query to report the device that is first logged in for each player.
select temp.player_id,temp.device_id from (select *,
row_number() over(partition by player_id order by event_date ) as rn 
 from Activity)temp
where rn=1;












































create database Flight_details_project
 

select * from transact
-- TID,TMode,Amount,Tsuccess
select * from pass_details
-- PID,pName, Booking_date, Tr_ID,Age,F_No,F_rewards
select * from flight_details
-- FNo,Pil_Name,Journey_Date,Depart_time,arr_time,source_city,dest_city,crew_members
select count(*) from transact -- 36
select count(*) from pass_details -- 36

-- Q1) Select Avg Transaction amount based on Transaction Mode in descending order 
-- of avg transction amount

select t.tmode,avg(t.amount) as AvgTransaction from transact t
group by t.tmode
order by AvgTransaction desc


-- Q2) Select All Transaction mode and Transaction amount along with Passenger Name, 
-- Booking_date of passengers where booking date in on weekends

select t.tmode,t.amount,p.pname,p.booking_date, date_format(p.booking_date,'%a')
from transact t 
left join pass_details p
on t.tid = p.tr_id
where date_format(p.booking_date,'%a') in ('Sat','Sun')

-- Q3) Select passenger name who are travelling multiple times

select pname,count(pname) as PassCount
from pass_details 
group by pname
having PassCount>1
order by PassCount desc

-- Q4) Select all the passengers who have earned more Flight rewards than the 
-- avg flight rewards earned by passenders whose payment mode is Credit or Debit Card

select * from pass_details where f_rewards >
(select avg(p.f_rewards) from pass_details p
join transact t on p.tr_id=t.tid where t.tmode in ('CC','DC')) 


-- Q5) Select all the passengers name, flight_rewards, transaction mode of those passengers
-- whose payment mode is Credit or Debit Card and
-- who have earned more Flight rewards than the avg flight rewards earned 
-- by all the passengers. 

select p.pid,p.pname,p.f_rewards,t.tmode from pass_details p
inner join transact t
on p.tr_id=t.tid
where p.f_rewards > 
(select avg(f_rewards) from pass_details) -- 18.333
and t.tmode in ('CC','DC')
order by p.pid


-- Q6) Display count of failed transactions based on transaction mode

select tmode, count(tsuccess) from transact
where tsuccess=0
group by tmode

-- Find all transaction details where transaction success is null
select * from transact where tsuccess is null


-- Q7) Select All Transaction mode and Transaction amount along with Passenger Name, 
-- of passengers those who have made the payment using 'CC' or 'UPI'. 
-- Also display 10% cashback and name it as Cashback that can be redeemed only if
-- payment mode is 'CC' and 0 cashback otherwise

select p.pname,t.tmode,t.amount, 
case 
	when t.tmode='CC' then 0.1*t.amount
    else 0
end as Cashback
from transact t
left join pass_details p
on t.tid = p.tr_id
where t.tmode in ('CC','UPI')


-- Q8) Select pilots name who are alloted to fly multiple flights

select f.pil_name,count(f.pil_name)
from flight_details f
group by f.pil_name
having count(f.pil_name)>1

-- Q9) Display the pilots, source_cty,dest_city,journey_date who flew from 
-- either Mumbai or Banglore but didnt land in Delhi or Chennai

select f.pil_name,f.source_city,dest_city,journey_date 
from flight_details f
where f.source_city in ('Mumbai','Bangalore') and
f.dest_city not in ('Delhi','Chennai')

-- Q10) Display the count of most frequent destination based on Destination city and
-- airlines company (Indigo, Air India and Spice Jet) 
-- where the flight arrived more than once

select dest_city,left(FNo,2),count(dest_city) as Count from flight_details
group by dest_city, left(FNo,2)
having Count>1
order by Count desc


-- Q11) Select PID,PName,Transaction_Mode, transaction_amount, Booking_Date, Age, 
-- Flight_No, Journey date, depart time, arrival time, source city and dest city
-- where flight departure time is on or after 6pm
 
select p.pid,p.pname,t.tmode,t.amount,p.booking_date,p.age,p.f_no,
f.journey_date,f.depart_time,f.arr_time,f.source_city,f.dest_city
from transact t
inner join pass_details p
on t.tid = p.tr_id
inner join flight_details f
on p.f_no = f.fno
where hour(f.depart_time)>=18

-- Q12) Select passenger id, passenger names,depart time,arrival time, transaction mode, 
-- time diff in minutes(including hours time) between arr_time 
-- and dest_time for passengers where Transcation mode is 'NB' or 'CC'

select p.pid,p.pname,f.depart_time,f.arr_time,t.tmode,
hour(timediff(f.arr_time,f.depart_time))*60 + (minute(timediff(f.arr_time,f.depart_time)))
as TimeDiff_InMin
from transact t
inner join pass_details p
on t.tid = p.tr_id
inner join flight_details f
on p.f_no = f.fno
where t.tmode in ('NB','CC')


-- Q13) Select Count of passengers per flight no

select f.fno,count(p.pid) as Pass_Count
from pass_details p
inner join flight_details f
on p.f_no = f.fno
group by f.fno

-- Q14) Display count of passengers based on airlines(Indigo, SPiceJet, Air India)
-- in descending order of count values

select left(f.fno,2),count(p.pid) as Pass_Count
from pass_details p
inner join flight_details f
on p.f_no = f.fno
group by left(f.fno,2)
order by Pass_Count desc

-- Q15) Select all pilots details (name,passengerID) who are travelling as passengers. 
-- Also display their flight_number,transaction amount and transaction mode

select p.pid,p.pname,f.fno,t.tmode,t.amount
from pass_details p
inner join flight_details f
on f.pil_name = p.pname
inner join transact t
on t.tid = p.tr_id

-- Q16) Display the passenger names, their IDs, FNo,age whose age is greater than
-- avg age of all passengers whose airlines is either Air India or Spice Jet
-- using sub query

select p.pid,p.pname,p.f_no,p.age 
from pass_details p where p.age >
(select avg(age) from pass_details where left(f_no,2) in ('AI','SJ'))

-- Q17) Display count and percentage of successful and failed transactions

select sum(tsuccess = 1) as Success, sum(tsuccess = 0) as Failed,
sum(tsuccess = 1) / (sum(tsuccess=0) + sum(tsuccess = 1)) as Per_Success,
sum(tsuccess = 0) / (sum(tsuccess=0) + sum(tsuccess = 1)) as Per_Fail
from transact


-- Q18) Select all passengers names, PID, flight_number, transaction_success details
-- who have failed transcations

select p.PID,p.pname,p.f_no,t.tsuccess from pass_details p
inner join transact t
on p.tr_id = t.tid
where t.tsuccess=0


-- Q19) Create a view containing the below mentioned query
-- a) Select airlines based sum of transaction amount and display them in descending order.
--    The view name has to be Airline_SumAmt
-- b) Write a select query on view to apply dense rank partion over airlines

-- a)
create or replace view Airline_SumAmt 
as
select left(p.f_no,2) as Airlines, sum(t.amount) as SumAmount
from transact t
inner join pass_details p
on t.tid = p.tr_id
group by Airlines
order by SumAmount desc

-- b)
-- select * from Airline_SumAmt
select Airlines,SumAmount,
dense_rank() over (partition by Airlines order by SumAmount desc) as Rank_SumAmt
from Airline_SumAmt



-- Q20) Allot 15% cashback to the passengers who are senior citizens(people aged 55 and above) 
-- on their transaction amount. Display PID, passenger names,Flight number,age,
-- and transaction amount renamed as DiscountedAmt

select p.pid,p.pname,p.f_no,p.age, 0.85*t.amount as DiscountedAmt
from transact t
inner join pass_details p
on t.tid = p.tr_id
where p.age>=55

-- Q21) Select transaction mode wise maximum age from tables 
-- oredered in ascending order of maximum age. Use sub query

select tmode, max(age) as MaxAge from
(select t.tmode , p.age
from pass_details p inner join transact t  
on p.tr_id = t.tid) dt
group by tmode
order by MaxAge

-- using Joins
select t.tmode, max(p.age) as MaxAge
from transact t
join pass_details p
on t.tid = p.tr_id
group by t.tmode
order by MaxAge

-- Q22) Find PID,passenger Names, Booking_date, Tr_ID, Age in each 
-- airlines(Indigo,SpiceJet,Air India)
-- whose age is more than avg age of passengers travellling in that airlines.
-- Use a correlated sub query 

select left(p1.f_no,2),avg(p1.age)
from pass_details p1
group by left(p1.f_no,2)
order by left(p1.f_no,2)

-- AI(25.875), IN(29,7), SJ(56.5455)

select p1.PID,p1.pname,p1.booking_date,p1.tr_id,left(p1.f_no,2),p1.age 
from pass_details p1 where p1.age >
(select avg(age) from pass_details p2 
where left(p2.F_NO,2) = left(p1.F_NO,2) 
group by left(p2.F_NO,2))
order by left(p1.f_no,2)


-- Q23) Display all transation details for the passengers where the 
-- flight duration is not more than 2.30hrs

select FNo,
hour(timediff(arr_time,depart_time)) + minute(timediff(arr_time,depart_time))/60
as Time_in_Hour
from flight_details where 
(hour(timediff(arr_time,depart_time)) + minute(timediff(arr_time,depart_time))/60)<=2.5

-- OR

select FNo,
hour(timediff(arr_time,depart_time))*60 + minute(timediff(arr_time,depart_time))
as Time_in_Min
from flight_details where 
(hour(timediff(arr_time,depart_time))*60 + minute(timediff(arr_time,depart_time)))<=150

-- Answer
select * from transact where TID in
(select Tr_ID from pass_details where F_NO in
	(select FNo from flight_details where 
    hour(timediff(arr_time,depart_time))*60 + minute(timediff(arr_time,depart_time))<=150)
); 


select * from transact where TID in
(select Tr_ID from pass_details where F_NO in
	(select FNo from flight_details where 
    hour(timediff(arr_time,depart_time)) + minute(timediff(arr_time,depart_time))/60<=2.5)
);

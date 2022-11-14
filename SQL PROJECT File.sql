select * from customer
-- C_ID,M_ID,C_NAME,C_EMAIL_ID,C_TYPE,C_ADDR,C_CONT_NO

SELECT * FROM EMPLOYEE_DETAILS
-- E_ID,E_NAME,E_DESIGNATION,E_ADDR,E_BRANCH,E_CONT_NO

SELECT * FROM EMPLOYEE_MANAGES_SHIPMENT
-- EMPLOYEE_E_ID,SHIPMENT_SH_ID,STATUS_SH_ID

SELECT * FROM MEMBERSHIP
-- M_ID,START_DATE,END_DATE

SELECT * FROM PAYMENT_DETAILS
-- PAYMENT_ID,C_ID,SH_ID,AMOUNT,PAYMENT_STATUS,PAYMENT_MODE,PAYMENT_DATE

SELECT * FROM SHIPMENT_DETAILS
-- SH_ID,C_ID,SH_CONTENT,SH_DOMAIN,SER_TYPE,SH_WEIGHT,SH_CHARGES,SR_ADDR,DS_ADDR
SELECT * FROM STATUS
-- SH_ID,CURRENT_STATUS,SENT_DATE,DELIVERY_DATE

-- Q1) Select count of customers based on customer type

select count(c_id) Cust_count,c_type
from customer
group by c_type

-- Q2) Select branch wise count of emp in descending order of count

select e_branch,count(e_id) emp_count
from employee_details
group by e_branch
order by emp_count desc

-- Q3) Select designation wise count of emp ID in descending order of count

select e_designation,count(e_id) emp_count
from employee_details
group by e_designation
order by emp_count desc

-- Q4) Select Count of customer based on payment status in descending order of count

select count(c.c_id) cust_count,p.payment_status
from customer c 
inner join payment_details p 
on c.c_id=p.c_id
group by p.payment_status
order by cust_count desc

-- Q5) Select Count of customer based on payment mode in descending order of count

select count(c.c_id) cust_count,p.payment_mode
from customer c 
inner join payment_details p 
on c.c_id=p.c_id
group by p.payment_mode
order by cust_count desc

-- Q6) Select Count of customer based on shipment_domain in descending order of count

select count(c.c_id) Cust_count,s.sh_domain
from customer c
inner join shipment_details s 
on s.c_id=c.c_id
group by s.sh_domain
order by Cust_count desc

-- Q7) Select Count of customer based on ser_type in descending order of count

select count(c.c_id) Cust_count,s.ser_type
from customer c
inner join shipment_details s 
on s.c_id=c.c_id
group by s.ser_type
order by Cust_count desc

-- Q8) Select Count of customer based on ser_type in descending order of count


-- Q9) Find C_ID,M_ID and tenure for those customers whose membership tenure is over 10 years.
-- Sort them in decreasing order of Tenure

select c.c_id, m.m_id,m.start_date,m.end_date,
left(datediff(end_date,start_date)/365,2) as Tenure
from membership m 
inner join customer c 
on m.m_id=c.m_id
group by c.c_id
having Tenure> 10
order by Tenure desc


-- Q10) Find average payment amount based on Customer Type where payment mode as COD

select p.amount,p.payment_mode,c.c_type 
from payment_details p 
inner join customer c 
on p.c_id=c.c_id
where p.payment_mode = 'COD'

-- Q11) Find avg payment amount based on payment mode where payment date is not null

select avg(amount) AVGAMOUNT,payment_mode,payment_date
from payment_details 
where payment_date is not null
group by payment_mode

-- Q12) Find sum of shipment charges based on payment_mode where service type is not regular

SELECT SUM(S.SH_CHARGES) SHIPMENT_CHARGES,S.SER_TYPE,P.PAYMENT_MODE
FROM SHIPMENT_DETAILS S
INNER JOIN PAYMENT_DETAILS P
ON S.C_ID=P.C_ID
WHERE S.SER_TYPE NOT LIKE 'REGULAR'
GROUP BY P.PAYMENT_MODE

-- Q13) Find avg shipment weight based on payment_status where shipment domain does not start with H

SELECT AVG(S.SH_WEIGHT) AVG_WEIGHT,S.SH_DOMAIN,P.PAYMENT_STATUS
FROM SHIPMENT_DETAILS S
INNER JOIN PAYMENT_DETAILS P
ON S.C_ID=P.C_ID
WHERE SH_DOMAIN NOT LIKE 'H%'
GROUP BY P.PAYMENT_STATUS

-- Q14) Find mean of payment amount based on shipping domain where service type 
-- is Express and payment status is paid

-- using like
SELECT AVG(P.AMOUNT) AVG_AMOUNT,P.PAYMENT_STATUS,S.SH_DOMAIN,S.SER_TYPE
FROM SHIPMENT_DETAILS S
INNER JOIN PAYMENT_DETAILS P
on P.C_ID=S.C_ID
WHERE S.SER_TYPE LIKE 'express'
AND P.PAYMENT_STATUS LIKE 'paid'
GROUP BY S.SH_DOMAIN

-- using in

SELECT AVG(P.AMOUNT) AVG_AMOUNT,P.PAYMENT_STATUS,S.SH_DOMAIN,S.SER_TYPE
FROM SHIPMENT_DETAILS S
INNER JOIN PAYMENT_DETAILS P
on P.C_ID=S.C_ID
WHERE S.SER_TYPE in ('express')
AND P.PAYMENT_STATUS in ('paid')
GROUP BY S.SH_DOMAIN


-- Q15) Find avg of shipment weight and shipment charges based on shipment status

SELECT AVG(S.SH_WEIGHT) AVG_WEIGHT, AVG(S.SH_CHARGES) AVG_SHIPPING_CHARGES,ST.CURRENT_STATUS 
FROM SHIPMENT_DETAILS S 
INNER JOIN STATUS ST
ON S.SH_ID=ST.SH_ID
GROUP BY ST.CURRENT_STATUS

-- USING WHERE CLAUSE
SELECT AVG(SH_WEIGHT) AVG_WEIGHT, AVG(SH_CHARGES) AVG_SHIPPING_CHARGES,CURRENT_STATUS 
FROM SHIPMENT_DETAILS S ,STATUS ST
WHERE S.SH_ID=ST.SH_ID
GROUP BY ST.CURRENT_STATUS

-- Q16) Display Sh_ID, shipment status,shipment_weight and delivery date where 
-- shipment weight is over 1000 and payment is done is Quarter 3

select s.sh_id,s.sh_weight,st.current_status,st.delivery_date,quarter(p.payment_date) 
from shipment_details s
inner join
status st
on st.sh_id=s.sh_id
inner join payment_details p
on p.sh_id=st.sh_id
where s.sh_weight > 100
and  quarter(p.payment_date) = 3

-- Q17) Display Sh_ID, shipment charges and shipment_weight and sent date where 
-- current_status is Not delivered and payment mode is Card_Payment
select * from status

select s.sh_id,s.sh_charges,s.sh_weight,st.sent_date,st.current_status,p.payment_mode
from shipment_details s
inner join
status st
on s.sh_id=st.sh_id
inner join
payment_details p 
on p.sh_id=st.sh_id
where st.current_status 
like 'not delivered'
and p.payment_mode in ('Card Payment')

-- Q18) Select all records from shipment_details where shipping charges is greater than 
-- avg shipping charges for all the customers

select * from shipment_details
where sh_charges >
     (select avg(sh_charges) from shipment_details)

-- Q19) Select average shipping weight and sum of shipping charges based on
-- shipping domain.

select sh_domain,avg(sh_weight) Avg_Weight,
sum(sh_charges) Total_ship_Charges
from shipment_details 
group by sh_domain

-- Q20) Find customer names, their email, contact,c_type and payment amount where C_type 
-- is either Wholesale or Retail

select c.c_name,c.c_email_id,c.c_cont_no,c.c_type,p.amount
from customer c 
inner join
payment_details p
on c.c_id=p.c_id
where c.c_type in ('Wholesale','Retail')

-- Q21) Find Emp_Id,Emp_Name, C_Id, shipping charges  the employees are managing customers 
-- whose shipping charges are over 1000

select es.employee_e_id,e.e_name,s.c_id,s.sh_charges
from shipment_details s
inner join  employee_manages_shipment es
on es.shipment_sh_id=s.sh_id
inner join employee_details e 
on es.employee_e_id=e.e_id
where s.sh_charges>1000

-- Q22) Find Emp_deisgnation wise the count of Customers that the employees of different
-- designation are handling in decreasing order of customer count

select e.e_designation,count(c.c_id) Count_of_customers,es.shipment_sh_id
from employee_details e 
inner join employee_manages_shipment es
on e.e_id=es.employee_e_id
inner join shipment_details s
on s.sh_id=es.shipment_sh_id
inner join customer c
on c.c_id=s.c_id
group by e.e_designation
order by Count_of_customers desc

-- Q23) Find Emp_deisgnation wise the count of Customers that the employees of different
-- designation are handling in decreasing order of customer count where the employess are
-- handling customers whose payment amount is greater than 
-- avg payment amount by all other customers

select e.e_designation,count(c.c_id) Count_of_customers,es.shipment_sh_id,p.amount
from employee_details e 
inner join employee_manages_shipment es
on e.e_id=es.employee_e_id
inner join shipment_details s
on s.sh_id=es.shipment_sh_id
inner join customer c
on c.c_id=s.c_id
inner join payment_details p
on p.c_id=c.c_id
where p.Amount > 
           (Select avg(Amount) as Avg_amount from payment_details)
group by e.e_designation
order by Count_of_customers desc

select c_type from customer
-- Q24) Find Employee branch and employee designation wise count of employee designation
-- who have managed customers whose shipping weight < 500. 
-- Display result in descending order of count

select e.e_branch,e.e_designation,count(e.e_designation) EMPDESIGNATION_COUNT,em.employee_e_id
,c.c_name,c.c_type,
s.sh_content,s.sh_weight
from employee_details e
inner join employee_manages_shipment em
on e.e_id=em.employee_e_id
inner join shipment_details s
on s.sh_id= em.shipment_sh_id
inner join customer c
on c.c_id= s.c_id
group by e.e_branch,e.e_designation
having s.sh_weight > 500
order by count(e.e_designation) desc

-- Q25) Find shipping content wise count of Employees for the employees who have managed
-- customers where shipping domain is International and shipping charges are greater 
-- than average shipping charges for all the cutomers.
-- Display result in descending order of count.

select s.sh_content,s.sh_domain,s.sh_charges,count(em.employee_e_id) Employee_count,c.c_id
from employee_manages_shipment em
inner join shipment_details s 
on s.sh_id=em.shipment_sh_id
inner join customer c 
on c.c_id=s.c_id
where sh_domain = 'International'
and s.sh_charges >
(select avg(sh_charges) from shipment_details)
group by s.sh_content 
order by Employee_count desc
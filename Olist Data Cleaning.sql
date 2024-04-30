SELECT TOP (1000) [order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_purchase_timestamp]
      ,[order_approved_datetime]
      ,[order_delivered_carrier_date]
      ,[order_delivered_customer_date]
      ,[order_estimated_delivery_date]
  FROM [Data Analysis Class ].[dbo].[olist_orders_dataset#csv$]


--Data Cleaning
--Checking for Duplicates
select 'order_id'column_name, COUNT(*)Count_of_Duplicates
from [dbo].[olist_orders_dataset#csv$]
group by order_id
having COUNT(*) >1
union --the number of the both columns has to be the same
select 'customer_id'column_name, COUNT(*)Count_of_CustomerID
from [dbo].[olist_orders_dataset#csv$]
group by customer_id
having COUNT(*) >1
Update [dbo].[olist_orders_dataset#csv$]
set order_status = 'Shipped' 
where order_status = 'Delivered' and order_delivered_customer_date is Null

--Checking for null values
select 'order_id'Column_Name, count(*)Null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_id
having order_id IS NULL
union
select 'customer_id'Customer_NULL, count(*)Null_values
from [dbo].[olist_orders_dataset#csv$]
group by customer_id
having customer_id ='NULL'
union 
select 'order_status'Status_NULL, count(*)Null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_status
having order_status ='NULL'
union
select 'order_purchase_timestamp'Tmestamp_NULL, count(*)Null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_purchase_timestamp
having order_purchase_timestamp is NULL
union
select 'order_approved_datetime' , count(*)Null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_approved_datetime
having order_approved_datetime  is NULL
union
select 'order_delivered_carrier_date', count(*)Null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_delivered_carrier_date
having order_delivered_carrier_date is NULL
union
select 'order_delivered_customer_date', count(*)Null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_delivered_customer_date
having order_delivered_customer_date is NULL
union
select 'order_estimated_delivery_date', count(*)Null_values
from [dbo].[olist_orders_dataset#csv$]
group by order_estimated_delivery_date
having order_estimated_delivery_date is NULL

UPDATE [dbo].[olist_orders_dataset#csv$]
SET order_approved_datetime = '00-00- 00:00:00'
where order_approved_datetime is NULL

--This is to find the time difference using the datedif and concatinate to join it together
select order_id, order_status,order_purchase_timestamp,order_approved_datetime,
concat (DATEDIFF(day,order_purchase_timestamp,order_approved_datetime)%30,'days',' ',
DATEDIFF(HOUR,order_purchase_timestamp,order_approved_datetime)%24,'hours',' ',
DATEDIFF(MINUTE,order_purchase_timestamp,order_approved_datetime)%60,'minutes',' ',
DATEDIFF(SECOND,order_purchase_timestamp,order_approved_datetime)%60,'seconds',' ')Time_Difference
from [dbo].[olist_orders_dataset#csv$]
where order_status = 'Canceled'
order by Time_Difference desc


--This is the average of the time difference
select order_id, order_status,order_purchase_timestamp,order_approved_datetime,
concat( Avg( DATEDIFF (day,order_purchase_timestamp,order_approved_datetime)%30),'day',
Avg (DATEDIFF (HOUR,order_purchase_timestamp,order_approved_datetime)%24),'hour',
Avg (DATEDIFF (MINUTE,order_purchase_timestamp,order_approved_datetime)%60),'minute',
Avg (DATEDIFF (SECOND,order_purchase_timestamp,order_approved_datetime)%60),'second')Time_Difference
from [dbo].[olist_orders_dataset#csv$]
group by order_id, order_status,order_purchase_timestamp,order_approved_datetime
order by Time_Difference asc

--Having order_status = 'Canceled' Alias doesn't work for 'having'

--SQL sees the rows with no number as the highest
select order_status,
concat( Avg( DATEDIFF (day,order_purchase_timestamp,order_approved_datetime)%30),'day',
Avg (DATEDIFF (HOUR,order_purchase_timestamp,order_approved_datetime)%24),'hour',
Avg (DATEDIFF (MINUTE,order_purchase_timestamp,order_approved_datetime)%60),'minute',
Avg (DATEDIFF (SECOND,order_purchase_timestamp,order_approved_datetime)%60),'second')Average_Time_Difference
from [dbo].[olist_orders_dataset#csv$]
group by  order_status
having order_status = 'canceled'
order by Average_Time_Difference desc

select order_id,order_status,order_purchase_timestamp,order_approved_datetime, 
 concat ( Avg(DATEDIFF (day,order_purchase_timestamp,order_approved_datetime)%30),'day'over (partition by order_status),
Avg (DATEDIFF (HOUR,order_purchase_timestamp,order_approved_datetime)%24),'hour'over (partition by order_status),
DATEDIFF (MINUTE,order_purchase_timestamp,order_approved_datetime)%60,'minute',
DATEDIFF (SECOND,order_purchase_timestamp,order_approved_datetime)%60,'second')Time_Difference  
from [dbo].[olist_orders_dataset#csv$]

where order_status = 'Canceled'

--Assignment 
--This is the time taken to delivered each of the order to the customer when its get to the carrier 
select order_id, order_status,order_delivered_carrier_date,order_delivered_customer_date,
concat (DATEDIFF (day,order_delivered_carrier_date,order_delivered_customer_date)%30,'day',
DATEDIFF (HOUR,order_delivered_carrier_date,order_delivered_customer_date)%24,'hour',
DATEDIFF (MINUTE,order_delivered_carrier_date,order_delivered_customer_date)%60,'minute',
DATEDIFF (SECOND,order_delivered_carrier_date,order_delivered_customer_date)%60,'second')Time_Difference
from [dbo].[olist_orders_dataset#csv$]
--where order_status = 'delivered'
order by Time_Difference desc

--This is the average time taken to delivered each of the order to the customer when its get to the carrier
select order_status,
concat( Avg(DATEDIFF (day,order_delivered_carrier_date,order_delivered_customer_date)%30),'day',
Avg (DATEDIFF (HOUR,order_delivered_carrier_date,order_delivered_customer_date)%24),'hour',
Avg (DATEDIFF (MINUTE,order_delivered_carrier_date,order_delivered_customer_date)%60),'minute',
Avg (DATEDIFF (SECOND,order_delivered_carrier_date,order_delivered_customer_date)%60),'second')Average_Time_Difference
from [dbo].[olist_orders_dataset#csv$]
group by order_status
order by Average_Time_Difference desc

--This is the time difference between the estimated date of delivery and the date the order got delivered to the customer
select order_id, order_status,order_delivered_customer_date,order_estimated_delivery_date,
concat (DATEDIFF (day,order_delivered_customer_date,order_estimated_delivery_date)%30,'day',
DATEDIFF (HOUR,order_delivered_customer_date,order_estimated_delivery_date)%24,'hour',
DATEDIFF (MINUTE,order_delivered_customer_date,order_estimated_delivery_date)%60,'minute',
DATEDIFF (SECOND,order_delivered_customer_date,order_estimated_delivery_date)%60,'second')Time_Difference
from [dbo].[olist_orders_dataset#csv$]
where order_status = 'delivered'
order by Time_Difference desc



--This is the average time difference between the estimated date of delivery and the date the order got delivered to the customer 
select order_status,
concat( Avg(DATEDIFF (day,order_delivered_customer_date,order_estimated_delivery_date)%30),'day',
Avg (DATEDIFF (HOUR,order_delivered_customer_date,order_estimated_delivery_date)%24),'hour',
Avg (DATEDIFF (MINUTE,order_delivered_customer_date,order_estimated_delivery_date)%60),'minute',
Avg (DATEDIFF (SECOND,order_delivered_customer_date,order_estimated_delivery_date)%60),'second')Average_Time_Difference
from [dbo].[olist_orders_dataset#csv$]
group by order_status
order by Average_Time_Difference desc


--sub query
select order_status,Time_Difference 
from (select order_id, order_status,order_delivered_carrier_date,order_delivered_customer_date,
concat (DATEDIFF (day,order_delivered_carrier_date,order_delivered_customer_date)%30,'day',
DATEDIFF (HOUR,order_delivered_carrier_date,order_delivered_customer_date)%24,'hour',
DATEDIFF (MINUTE,order_delivered_carrier_date,order_delivered_customer_date)%60,'minute',
DATEDIFF (SECOND,order_delivered_carrier_date,order_delivered_customer_date)%60,'second')Time_Difference
from [dbo].[olist_orders_dataset#csv$])Time_Difference_Table
group by order_status,Time_Difference
--where order_status = 'delivered'
/*order by Time_Difference desc*/
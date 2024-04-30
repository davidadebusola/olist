--This is inner join for people that ordered that is the thing common in both tables 
select *
from [dbo].[Sheet1$] as OT
inner join [dbo].[CustomerTable$] as CT
on OT.[customer id] = CT.[customer id]

--This is for the full joining of the table
select *
from [dbo].[Sheet1$] as OT
full join [dbo].[CustomerTable$] as CT
on OT.[customer id] = CT.[customer id]

--This is for the left join, the table at the from function is the left table
select *
from [dbo].[Sheet1$] as OT
Left join [dbo].[CustomerTable$] as CT
on OT.[customer id] = CT.[customer id]

--This is for the right join, the table at the join function is the right table
select *
from [dbo].[Sheet1$] as OT
right join [dbo].[CustomerTable$] as CT
on OT.[customer id] = CT.[customer id]

--Instead of using select* to show all the columns, you can select the column you want to appear with the name of the table using the alias
select OT.[order_id], CT.[customer id], OT.[price unit], CT.name
from [dbo].[Sheet1$] as OT
right join [dbo].[CustomerTable$] as CT
on OT.[customer id] = CT.[customer id]


--This is to show the duplicates by using the count function
select CT.[customer id], count(*) as Duplicates
from [dbo].[Sheet1$] as OT
inner join [dbo].[CustomerTable$] as CT
on OT.[customer id] = CT.[customer id]
group by CT.[customer id]
having count(*)>1

--Assignment STUDY DAVID STUDY and spend more time on medium andn try other calculations on what we did today with the joins






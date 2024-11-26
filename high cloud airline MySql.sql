-- KPI 1 calcuate the following fields from the Year	Month (#)	Day  fields ( First Create a Date Field from Year , Month , Day fields)

-- Date
ALTER TABLE `maindata`
ADD `Date` int;


UPDATE `maindata`
SET `Date` = STR_TO_DATE(CONCAT(`Year`,'-',`Month`,'-',`Day`), '%Y-%m-%d');

SELECT * FROM `maindata`;

alter table maindata
drop column month;

alter table maindata
rename column `Month (#)` to `month`;

-- year
alter table maindata
drop column years;

update maindata 
set date = concat(`day`, '-',`month`,'-',`year`);
select * from maindata;


-- Month No

Alter table maindata
add column MonthNo int;

update maindata set MonthNo = month(Date);
select monthno from maindata;

-- month full name

alter table maindata
add column monthfullname varchar(20);

update maindata set monthfullname = monthname(date);

-- Quater

alter table maindata
add column Quarter char(30);

update maindata set Quarter =
case
when Quarter(Date) = 1 then 'Q1'
when Quarter(Date) = 2 then 'Q2'
when Quarter(Date) = 3 then 'Q3'
else 'Q4'
end;
select quarter, monthfullname  from maindata order by quarter;

-- year month

alter table maindata
Add column YearMonth varchar(25);

update maindata
set YearMonth = date_format(date,'%Y-%M');
select * from maindata;

-- WeekDay Number

alter table maindata
Add column WeekdayNo int;

update maindata
set WeekdayNo = weekday(Date);
select weekdayno from maindata;

-- weekdayname
Alter table maindata
add column weekdayname varchar(20);

update maindata
set weekdayname = dayname(date);
select weekdayname from maindata;

-- Financial Month 
-- Financial quarter

alter table maindata
add column FinancialMonth varchar(20);


select year as years, month as monthno,
monthname(date) as monthfullname,
case
when month(date) between 1 and 3 then 'Q1'
when month(date) between 4 and 6 then 'Q2'
when month(date) between 7 and 8 then 'Q3'
else 'Q4'
end as financialmonth,
concat(Year,'-Q', quarter(Date)) as FinancialQuarter
from
maindata;

-- KPI 2 Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)
-- yearly
select year,
round(avg(`Transported_Passengers`) / avg(`Available_Seats`)*100,2) as Load_Factor_Percentage
from maindata 
group by Year;

-- Quaterly

select quarter,
round(avg(`Transported_Passengers`) / avg(`Available_Seats`)*100,2) as Load_Factor_Percentage
from(select ceiling(month/3) as Quarter,`Transported_Passengers`,`Available_Seats`
from maindata) as Quaterly
group by quarter
order by quarter asc;

-- Monthly

select month,
round(avg(`Transported_Passengers`) / avg(`Available_Seats`)*100,2) as Load_Factor_Percentage
from maindata 
group by month
order by month asc;

-- KPI 3-- Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)

select `Carrier_Name`,ifnull((sum(`Transported_Passengers`) / ifnull(sum(`Available_Seats`),0))*100,0) as load_factor_percentage
from maindata
group by `Carrier_Name`
order by `Load_factor_Percentage` desc;

-- KPI 4 Identify Top 10 Carrier Names based passengers preference 

select `Carrier_Name`, sum(`Transported_Passengers`) As Total_Passengers
from maindata
group by `Carrier_Name`
order by `Total_Passengers` desc
limit 10;

-- KPI 5 Display top Routes ( from-to City) based on Number of Flights 

select `From_To_City` as Route,
count(*) Number_of_Flights
from maindata 
group by route
order by Number_of_Flights DESC
limit 10;

-- KPI 6 Identify the how much load factor is occupied on Weekend vs Weekdays.

select
case when dayname(date) in ('saturday' , 'sunday') then 'weekend' else 'weekday'
end as week_type,
round(avg(`Transported_Passengers`/`Available_Seats`)*100,2) as Load_Factor
-- avg(`Transported_Passengers`)  as lf
from maindata
group by week_type;


-- KPI 7 Identify number of flights based on Distance group

select `Distance_Group_ID` , count(*) as number_of_flights
from maindata
group by `Distance_Group_ID`;

-- KPI 8 Use the filter to provide a search capability to find the flights between Source Country, Source State, Source City to Destination Country , Destination State, Destination City

select `Carrier_Name`,`Origin State`,`Origin Country`,`Destination Country`,`Destination State`
from maindata
where `Origin Country` = 'United States'
and`Origin State` = 'Alaska'
and `Destination Country`= 'United States'
and `Destination State` = 'Texas';









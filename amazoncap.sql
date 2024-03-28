create database capproj;
use capproj;
Create table if not exists amazon ( 
Invoice_ID varchar(30) not null primary key,
Branch varchar(30) not null,
City varchar(5) not null,
Customer_type varchar(30) not null,
Gender varchar(10) not null,
Product_line varchar(100) not null,
Unit_price decimal(10,2) not null,
Quantity int not null,
VAT float(6,4) not null,
Total decimal(10,2) not null,
Date date not null,
Time timestamp not null,
Payment_method varchar(20) not null,
cogs decimal(10,2) not null,
gross_margin_percentage float(11,9) not null,
gross_income decimal(10,2) not null,
Rating float(2,1) not null
);
    select * from amazon; 
    ----- Feature Engineering
    select 
 Time,
    (case 
  when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else  "Evening" 
    end 
    ) As time_of_day
from amazon; 
alter table amazon add column time_of_day  varchar(30);
SET SQL_SAFE_UPDATES =0 ;
update amazon
set time_of_day= (
 case 
  when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else  "Evening" 
    end
);   
SET SQL_SAFE_UPDATES =1;  
  select
 Date,
    dayname(date)
from amazon;
alter table amazon add column day_name varchar(10);
update  amazon
set day_name= dayname(date);  
select 
 Date,
    monthname(date)
from amazon;
alter table amazon add column month_name varchar(15);
update  amazon
set month_name= monthname(date);  
select * from amazon;  

----- What is the count of distinct cities in the dataset? 
select count(distinct City) as distict_cities from amazon; 
-------- For each branch, what is the corresponding city? 
select distinct City ,Branch from amazon;  
-------- What is the count of distinct product lines in the dataset? 
select count(distinct Product_line) as distinct_productline from amazon; 
-------- Which payment method occurs most frequently? 
select 
 Payment_method,
 count( Payment_method) as cnt_pay
from amazon
group by Payment_method
order by  cnt_pay desc;  
-------- Which product line has the highest sales? 
select Product_line , 
count(Product_line) as cnt_prod 
from amazon 
group by Product_line 
order by cnt_prod desc;  
-------- How much revenue is generated each month? 
Select 
 month_name as Month,
    sum(Total) as Total_Revenue 
from amazon
group by month_name
order by Total_Revenue Desc ; 
-------- In which month did the cost of goods sold reach its peak? 
select month_name as Month , 
sum(cogs) as Total_cogs
from amazon 
group by month_name 
order by Total_cogs desc;  
-------- Which product line generated the highest revenue? 
select Product_line,
round(sum(Total),2) as Total_Prodline 
from amazon 
group by Product_line 
order by Total_Prodline desc; 
-------- In which city was the highest revenue recorded? 
select City ,
round(sum(Total),2) as City_Revenue 
from amazon 
group by City 
order by City_Revenue desc;  
-------- Which product line incurred the highest Value Added Tax? 
select Product_line, 
round(sum(VAT),2) as Total_Vat 
from amazon
group by Product_line 
order by Total_Vat desc; 
-------- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
use capproj;
SELECT
    Product_line,
    CASE
        WHEN Total_Sales > avg_total THEN 'Good'
        ELSE 'Bad'
    END AS Status
FROM
    (
        SELECT
            Product_line,
            SUM(Total) AS Total_sales,
            AVG(SUM(Total)) OVER () AS avg_total
        FROM
            `amazon`
        GROUP BY
            Product_line
    ) AS SalesSummary;  
   ----- Identify the branch that exceeded the average number of products sold.
   
	select Branch, 
    SUM(quantity) AS qnty
from amazon
group by Branch
having  SUM(quantity) > (select avg(quantity) from amazon);
----- -Which product line is most frequently associated with each gender?
select Gender, Product_line ,count(Product_line) as cnt  
from amazon 
group by Gender ,Product_line
order by cnt desc; 
-------- Calculate the average rating for each product line.
select Product_line,round(avg(rating),2) as avg_rating 
from amazon 
group by Product_line; 
-------- Count the sales occurrences for each time of day on every weekday 
select  time_of_day, count(*) as Total_sales 
from amazon 
where day_name in ('Monday','Tuesday','Wednesday','Thursday','Friday') 
group by time_of_day 
order by Total_sales desc;


select * from amazon;
-----------  Identify the customer type contributing the highest revenue.
select Customer_type , round(sum(Total),2) as High_Revenue 
from amazon 
group by Customer_type 
order by High_Revenue desc;
-----  Determine the city with the highest VAT percentage. 
select City , round(sum(VAT),2) as high_VAT 
from amazon 
group by City 
order by high_VAT desc; 
-------- Identify the customer type with the highest VAT payments. 
select Customer_type , round(avg(VAT),2) as high_VAT
from amazon 
group by Customer_type 
order by high_VAT desc; 
-------- What is the count of distinct customer types in the dataset? 
select  count(distinct Customer_type) from amazon; 
-------- What is the count of distinct payment methods in the dataset? 
select count(distinct Payment_method) from amazon; 
-------- Which customer type occurs most frequently? 
select Customer_type ,count(*) as cnt 
from amazon 
group by Customer_type 
order by cnt desc; 
----- identify the customer type with the highest purchase frequency.
select Customer_type ,count(*) as cnt 
from amazon 
group by Customer_type 
order by cnt desc; 
----- Determine the predominant gender among customers. 
select Gender , count(*) as Gender_count 
from amazon 
group by Gender 
order by Gender_count desc; 
--------  Examine the distribution of genders within each branch.
select Gender ,count(*) as gen_cnt , Branch 
from amazon 
where Branch in ("A","B","C")
group by Gender , Branch 
order by  Branch asc,gen_cnt desc;

----- Identify the time of day when customers provide the most ratings.
select * from amazon; 
select Time,time_of_day , avg(Rating) as avg_rating 
from amazon 
group by Time,time_of_day 
order by avg_rating desc; 
-------- Determine the time of day with the highest customer ratings for each branch 
select time_of_day , round(avg(rating),2) as avg_rating ,branch
from amazon 
group by time_of_day , Branch 
order by branch asc, avg_rating desc ;
-------- Identify the time of the day of where customer provide most rating 
select *  from amazon;
select time_of_day,round(sum(Rating),2) as total_rating 
from amazon 
group by time_of_day 
order by total_rating desc;
-------- Determine the day of the week with the highest average ratings for each branch. 
select day_name,avg(Rating) as avg_rating ,Branch 
from amazon 
group by day_name , Branch 
order by branch asc,avg_rating desc; 
-------- Determine the time of day with the highest customer ratings for each branch.
select time_of_day,round(sum(Rating),2) as total_rating ,Branch 
from amazon 
group by time_of_day , Branch 
order by branch asc,total_rating desc; 



    
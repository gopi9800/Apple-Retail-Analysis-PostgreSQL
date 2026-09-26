-- Apple Analysis

select * from category;
select * from products;
select * from sales;
select * from store;
select * from warranty;

-- Business Problems

-- 1.Find the number of stores in each country

select country,count(store_id) as no_of_stores from store
group by country order by no_of_stores desc;

-- 2.caliculate the total no of units sold by each store

select s.store_id,st.store_name,count(s.quantity) as no_of_units from sales as s 
join store as st on s.store_id = st.store_id group by 1,2 order by 3 desc;

-- 3.Identify how many sales occured in December 2023

select extract(month from sale_date) as month,extract(year from sale_date) as year,
sum(quantity) as total_sales from sales where extract(year from sale_date) = 2023
and extract(month from sale_date) = 12 group by month, year order by 3 desc;

-- 4.Determine how many stores have never had a warranty claim filed

select count(*) from store where store_id not in (
select distinct store_id from sales as s right join warranty as w
on s.sale_id = w.sale_id
)

-- 5.caliculate the percentage of warranty claims marked as "In Progress"

select round(count(claim_id)/(select count(*) from warranty)::numeric * 100,2) as
In_progress_percentage from warranty where repair_status = 'In Progress'

-- 6.Identify which store had the highest total units sold in last 10 years

select store_id,sum(quantity) as total_quantity from sales where
sale_date >= current_date - interval '10 year'
group by store_id order by total_quantity desc

-- 7.count the total no of unique products sold in last 10  years

select count(distinct product_id) from sales where
sale_date >= current_date - interval '10 year'

-- 8.Find the average price of products in each category

select category_id,avg(price) as avg_price_per_category from products group by category_id order by 2 desc

-- 9.How many warrantly claims were filed in 2020?

select count(claim_id) from warranty where extract(year from claim_date) = 2020

-- 10.For each store,identify the best selling day by day based on highest quantity sold

select * from
(
select store_id,to_char(sale_date,'Day') as day_name,sum(quantity) as quantity,
dense_rank () over(partition by store_id order by sum(quantity) desc ) as rank
from sales group by 1,2 order by 1,3 desc) as t1 where rank = 1;


-- 11.Identify the least selling product in each country for each year based on total units sold

with cte as (
select st.country,p.product_name,sum(s.quantity) as total_units_sold,
rank() over(partition by st.country order by sum(s.quantity)) as rank from sales as s
join store as st on s.store_id = st.store_id
join products as p on p.product_id = s.product_id
group by 1,2)

select * from cte where rank = 1


-- 12.caliculate how many waranty claims were filled with 180 days of product sale

select w.*,s.sale_date,w.claim_date - s.sale_date as dif from warranty as w
left join sales as s on s.sale_id = w.sale_id
where w.claim_date >= s.sale_date and (w.claim_date - s.sale_date) <= 180


-- 13.Determine how many warranty claims were filled for products launched in last two years

select p.product_name,count(w.claim_id) as no_of_claims,count(s.sale_id) from warranty as w
join sales as s on s.sale_id = w.sale_id
join products as p on p.product_id = s.product_id
where launch_date >= current_date - interval '2 year'
group by 1


-- 14.List the months in the last five years where sales exceeded 5,000 units in the usa

select to_char(s.sale_date,'MM-YYYY') as month,sum(s.quantity) as total_units_sold
from sales as s join store as st on s.store_id = st.store_id
where s.sale_date >= current_date - interval'5 year' and st.country = 'USA'
group by month having sum(s.quantity) > 5000

-- 15.Identify the product category with the most warranty claims filled in the last two years

select c.category_name,count(w.claim_id) as total_claims from warranty as w
left join sales as s on s.sale_id = w.sale_id
join products as p on p.product_id = s.product_id
join category as c on c.category_id = p.category_id
where w.claim_date >= current_date - interval'2 year'
group by 1

-- 16.Determine the percentage chance of receiving warranty claims after each purpose for each country

select country,total_units_sold,total_claims,
round(coalesce(total_claims::numeric / total_units_sold::numeric * 100,0),2) from
(
select st.country,sum(s.quantity) as total_units_sold,count(w.claim_id) as total_claims
from sales as s join store as st on s.store_id = st.store_id
left join warranty as w on w.sale_id = s.sale_id group by 1) as t1
order by 4 desc

-- 17.Analyze the growth ratio for each store

with cte as (
select s.store_id,st.store_name,extract(year from sale_date) as year,
round(sum(s.quantity::numeric * p.price::numeric), 2) as total_sale from sales as s
join store as st on s.store_id = st.store_id
join products as p on p.product_id = s.product_id
group by 1,2,3 order by 2,3),

cte2 as (
select store_name,year,lag(total_sale,1) over(partition by store_name order by year) as last_year_sale,
total_sale as current_year_sale from cte)

select store_name,year,last_year_sale,current_year_sale,
round((current_year_sale - last_year_sale)::numeric / last_year_sale::numeric * 100,2) as trend from cte2
where last_year_sale is not null


-- 18.caliculate the correlation between product price and warranty claims for products sold in last five years,segmented by price range

select
case
when price < 500 then 'Less Expensive'
when price between 500 and 1000 then 'Mid product'
else 'Expensive product' end as price_segment,
count(w.claim_id) as total_claim from sales as  s 
join warranty as w on w.sale_id = s.sale_id
join products as p on p.product_id = s.product_id
where s.sale_date >= current_date - interval '5 year'
group by 1

-- 19.write a query to caliculate the monthly running total of sales for each store over the past four years and compare trends during this period

with cte as(
select store_id,extract(year from sale_date) as year,
extract(month from sale_date) as month,sum(p.price*s.quantity) as total_sale from sales as s
join products as p on s.product_id = p.product_id
group by 1,2,3 order by 1,2,3)

select store_id,month,year,total_sale,sum(total_sale) over (partition by store_id order by year,month)
as running_total from cte














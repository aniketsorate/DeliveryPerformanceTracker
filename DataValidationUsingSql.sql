-- Total  Revenue
select sum(order_item_total) as Reveune from fact_sales;

-- Profit
select sum(benefit_per_order) as Profit from fact_sales;

-- Profit Margin
select sum(benefit_per_order)/sum(order_item_total) as ProfitMargin from fact_sales;

-- Ontime Delivery Percentage
select (
	select count(*) from fact_sales
	where late_delivery_risk = 0
)/count(*) as ontiemper
from fact_sales;

-- Average Delay
select round(avg(days_for_shipping_real-days_for_shipping_scheduled)) as  AvgDelay
from fact_sales
where late_delivery_risk=1;

-- profit margin by customer segment
select round(sum(fs.benefit_per_order)/sum(fs.order_item_total)* 100, 2) as ProfitMargin
from fact_sales fs
join dim_customer dc on fs.customer_id = dc.customer_id
group by dc.customer_segment;

-- top 10 products by late%
SELECT 
    dp.product_id,
    ROUND(sum(case when fs.late_delivery_risk then 1 else 0 end )* 100/ 
    (select count(*) from fact_sales where late_delivery_risk = 1),
            2) AS lateper
FROM
    fact_sales fs
        JOIN
    dim_product dp ON dp.product_id = fs.product_id
GROUP BY dp.product_id
ORDER BY lateper DESC
LIMIT 10;


-- average delay by shipping mode
select do.shipping_mode, round(avg(fs.days_for_shipping_real-fs.days_for_shipping_scheduled)) as  AvgDelay
from fact_sales fs
join dim_order do on fs.order_id = do.order_id
where fs.late_delivery_risk=1
group by do.shipping_mode;


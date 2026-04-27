select * from customer limit 20

Select Gender,SUM(purchase_amount) 
FROM customer
Group by Gender

select customer_id,purchase_amount
from customer
where discount_applied='Yes' and purchase_amount>(Select avg(purchase_amount) From customer)

Select item_purchased,
       ROUND(AVG(review_rating)::numeric, 2) AS average_review_rating
From customer
group by item_purchased 
order by 2 desc
limit 5


Select item_purchased , 
ROUND(100*SUM(CASE When discount_applied='Yes' Then 1 Else 0 END)/Count(*),2) as discount_rate
From customer
group by item_purchased
order by discount_rate desc
limit 5;

Select count(customer_id) as Total_customer,subscription_status,ROUND(AVG(purchase_amount),2) as Avg_revenue ,ROUND(SUM(purchase_amount),2) as Total_revenue
From customer
group by subscription_status
order by avg_revenue,total_revenue DESC;

Select shipping_type,
ROUND(AVG(purchase_amount),2) 
from customer
where shipping_type IN ('Standard','Express')
group by shipping_type

--Q7:- Segment customers into New, Returning and Loyal based on their
--previous number of total purchases and show the count of each segment
With customer_type as(
Select customer_id,previous_purchases,
Case 
	When previous_purchases=1 Then 'New'
	When previous_purchases Between 2 and 10 Then 'Returning'
	Else 'Loyal'
	End as customer_segment
From customer
)

Select customer_segment , count(*) as number_of_customers
From customer_type
Group by customer_segment

--Q8:- What are the top 3 most purchased Products within each category?
With item_counts as(
Select category,item_purchased,
count(customer_id) as total_orders,
Row_Number() Over(Partition by category order by count(customer_id) DESC) as item_rank
from customer 
group by category, item_Purchased
)
Select item_rank ,category,item_purchased,total_orders
from item_counts
where item_rank<=3
 
--Q9 Are customers who are repeat buyers are more likey to subscibe?
Select subscription_status, count(customer_id) as repeat_buyers from customer
where previous_purchases>5
Group by subscription_status

--Q10:- Find the revenue by age group
Select age_group,Sum(purchase_amount) as revenue FROM customer
Group by age_group
order by revenue DESC
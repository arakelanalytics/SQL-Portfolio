/*Arakel Aristakessian Final Project
MBA 6527 Spring 2023

Option #4 Code*/

/*PROMPT: 
You are an analyst at XZY Grocery Stores, and your boss has asked you to look at some inventory
and recent transaction data and find the top 5 items where the current inventory is at risk of being depleted.  
Look at the purchase history of each item and compare the number that have been purchased to the number remaining 
in the current inventory and report the 5 items that you think have the greatest risk of running out before the 
next inventory shipment.*/

#VIEW AND JOIN DATA
#view inventory data
Select *
From excel_sql_inventory_data

#view transaction data
Select *
From excel_sql_transaction

#join data on product_id
Select *
From excel_sql_inventory_data
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id


#EXPLORE DATA
#how many distinct products
Select distinct product_name
From excel_sql_inventory_data
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
--there are 84 distinct products

#Look at total number sold by item type for this past week
Select excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name,
count(excel_sql_inventory_data.product_id) as num_sold
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
GROUP BY excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name
#All 84 items sold last week. The highest amount of times an item sold was 14 and the lowest was 2.



#Look at current inventory by product
Select  excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name, count(excel_sql_inventory_data.product_id) as num_sold,
current_inventory
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
GROUP BY excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name, current_inventory
#2 items are out of stock (rice_crackers & rooibos_tea)

#Look at items with current inventory under 5
Select  excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name, count(excel_sql_inventory_data.product_id) as num_sold,
current_inventory
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
where current_inventory < 5
GROUP BY excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name, current_inventory
#there are 12 products that are under 5 remaining in current inventory

/*Calculate current ratio for all products. (current inventory - number sold this past week).
Negative current ratio means current inventory is less than the amount sold in previous week*/
Select  excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name,
current_inventory, count(excel_sql_inventory_data.product_id) as num_sold, 
current_inventory - count(excel_sql_inventory_data.product_id) as current_ratio
From excel_sql_inventory_data
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
GROUP BY excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name, current_inventory


#Filter items with current ratio less than 0. 
SELECT product_id, product_name,current_inventory, num_sold, current_ratio
FROM
(
   Select  excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name,
current_inventory, count(excel_sql_inventory_data.product_id) as num_sold, 
current_inventory - count(excel_sql_inventory_data.product_id) as current_ratio
From excel_sql_inventory_data
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
GROUP BY excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name, current_inventory
) 
WHERE current_ratio < 0
#14 such items. (64,70,84,14,75,80,46,3,28,27,33,45,22,2)


#number of items sold by day 
Select substring(time, 9,2) as day,
count(excel_sql_inventory_data.product_id) as num_sold
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
GROUP BY  substring(time, 9,2)



#number sold by item by day 
Select substring(time, 9,2) as day, excel_sql_inventory_data.product_id,
excel_sql_inventory_data.product_name,
 count(excel_sql_inventory_data.product_id) as num_sold
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
where excel_sql_inventory_data.product_id in (64,70,84,14,75,80,46,3,28,27,33,45,22,2)
GROUP BY excel_sql_inventory_data.product_id, substring(time, 9,2), excel_sql_inventory_data.product_name
order by product_name, num_sold


#avg, min and max amount sold per day by item
Select product_id, product_name, sum(num_sold)/ count(day) as avg_num_sold_per_day,
 max(num_sold) as max_sold, min(num_sold) as min_sold
From
(
    Select substring(time, 9,2) as day, excel_sql_inventory_data.product_id,
excel_sql_inventory_data.product_name,
 count(excel_sql_inventory_data.product_id) as num_sold
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
where excel_sql_inventory_data.product_id in (64,70,84,14,75,80,46,3,28,27,33,45,22,2)
GROUP BY excel_sql_inventory_data.product_id, substring(time, 9,2), excel_sql_inventory_data.product_name)
group by product_id, product_name

#numbers sold by product by day in past 3 days (negative current ratio)
Select substring(time, 9,2) as day, excel_sql_inventory_data.product_id,
excel_sql_inventory_data.product_name,
 count(excel_sql_inventory_data.product_id) as num_sold
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
where excel_sql_inventory_data.product_id in (64,70,84,14,75,80,46,3,28,27,33,45,22,2) and substring(time, 9,2) in ("06", "07", "08")
GROUP BY excel_sql_inventory_data.product_id, substring(time, 9,2), excel_sql_inventory_data.product_name

#numbers sold by product in past 3 days (wed-fri) (negative current ratio)
Select excel_sql_inventory_data.product_id,
excel_sql_inventory_data.product_name,
 count(excel_sql_inventory_data.product_id) as num_sold
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
where excel_sql_inventory_data.product_id in (64,70,84,14,75,80,46,3,28,27,33,45,22,2) and substring(time, 9,2) in ("06", "07", "08")
GROUP BY excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name








--numbers sold by product (sun-tues) vs current inventory (items with overall negative current ratio)
Select excel_sql_inventory_data.product_id,
excel_sql_inventory_data.product_name,
 count(excel_sql_inventory_data.product_id) as num_sold,
 current_inventory, current_inventory - count(excel_sql_inventory_data.product_id) as current_ratio
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
where excel_sql_inventory_data.product_id in (64,70,84,14,75,80,46,3,28,27,33,45,22,2) and substring(time, 9,2) in ("03", "04", "05")
GROUP BY excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name, current_inventory
--buckwheat flour and fuji apples are the items whos current inventory is less than last Sunday's Sales. 

--numbers sold by product last sunday (negative current ratio)
Select excel_sql_inventory_data.product_id,
excel_sql_inventory_data.product_name,
 count(excel_sql_inventory_data.product_id) as num_sold
From excel_sql_inventory_data 
join excel_sql_transaction on excel_sql_inventory_data.product_id = excel_sql_transaction.product_id
where excel_sql_inventory_data.product_id in (64,70,84,14,75,80,46,3,28,27,33,45,22,2) and substring(time, 9,2) in ("03")
GROUP BY excel_sql_inventory_data.product_id, excel_sql_inventory_data.product_name
--last sunday we had 4 buckwheat_flour sold and 3 orzo


--Sales Forecasting & Product Association Analysis of Superstore


--Monthly Sales Trend Analysis
--Visualize monthly sales trends to identify periods of high and low sales.

SELECT 
    FORMAT([Order Date], 'yyyy-MM') as MonthYear, 
    SUM(Sales) as MonthlySales
FROM sales
GROUP BY FORMAT([Order Date], 'yyyy-MM')
ORDER BY MonthYear;

--Category-wise Sales Analysis
--Determine which product categories are the most and least profitable.

Select 
Category,
Sum(Sales) as TotalSales
From sales
Group By Category
Order By TotalSales Desc;

--Customer Insights
-- Identify the top 10 customers in terms of purchase frequency and total spend.

With CustomerInsights As(
Select 
[Customer Name],
Count(Distinct [Order ID]) as TotalOrders,
Sum(sales) as TotalSpend
From sales
Group By [Customer Name]
)
Select Top 10 [Customer Name]
[Customer Name],
TotalOrders,
TotalSpend
From CustomerInsights
Order by TotalSpend DESC

--Market Basket Analysis (Association Rule Mining)
--Identify which products are frequently bought together to inform cross-selling strategies.

Select
    a.[Sub-Category] as Product1,
	b.[Sub-Category] as Product2,
	Count(Distinct a.[Order ID]) as FrequencyTogether
From sales a
Join sales b on a.[Order ID] = b.[Order ID] And a.[Sub-Category] < b.[Sub-Category]
GROUP BY a.[Sub-Category], b.[Sub-Category]
HAVING Count(Distinct a.[Order ID]) > 50
ORDER BY FrequencyTogether DESC; 

--Customer Lifetime Value Prediction
--Estimate how much revenue a customer will generate for the company over their lifetime.

With CustomerValue As(
Select 
[Customer Name],
DATEDIFF(DAY, Min([Order Date]), Max([Order Date])) +1 as CustomerDurationDays,
Sum([sales]) as TotalSpend
From sales
Group by [Customer Name]
)

Select
[Customer Name],
TotalSpend / CustomerDurationDays as DailySpend,
TotalSpend / CustomerDurationDays *365 * 5 as Predicted5yearSpend
From CustomerValue
Order By Predicted5yearSpend Desc;
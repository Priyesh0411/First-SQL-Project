/***********************************************************************************************************************************************************************
                    								 CHECKING ALL THE TABLES OF CHINOOK MUSIC DATABASE
***********************************************************************************************************************************************************************/

SELECT * FROM "Album";
SELECT * FROM "Artist";
SELECT * FROM "Customer";
SELECT * FROM "Employee";
SELECT * FROM "Genre";
SELECT * FROM "Invoice";
SELECT * FROM "InvoiceLine";
SELECT * FROM "MediaType";
SELECT * FROM "Playlist";
SELECT * FROM "PlaylistTrack";
SELECT * FROM "Track";

/***********************************************************************************************************************************************************************
                    		 						In this Chinook Database, we are finding about the following:
***********************************************************************************************************************************************************************/

/***********************************************************************************************************************************************************************
                    		 							Who Are The Top 5 Artists Who Produce More Album?
***********************************************************************************************************************************************************************/

SELECT "Artist"."Name" AS Artist_Name, COUNT("Album"."AlbumId") AS Album_Count
FROM "Artist"
JOIN "Album" ON "Artist"."ArtistId" = "Album"."ArtistId"
GROUP BY "Artist"."Name"
ORDER BY Album_Count DESC
LIMIT 5;

/***********************************************************************************************************************************************************************
                    		 									Number Of Tracks Sold Per Genre
***********************************************************************************************************************************************************************/

-- To know the number of tracks sold per genre. We will have to use 3 tables. To get the tracks we have to use InvoiceLine Quantity column 
-- for quantity of Track & TrackId column to get the track Id. Then After multiplying both we will get Number of Tracks. 

-- 2nd table will be Track Table & 3rd will be Genere table. Track table is needed to join the TrackId of InvoiceLine TrackId and Track table
-- TrackId column so that it will allow the Query to link InvoiceLine Info with Track Info. And Track Table has relation with Genere so Only
-- then it will be able to link track Info with Genere Info. Thus it will give the result we want.

SELECT ("InvoiceLine"."TrackId" * "InvoiceLine"."Quantity") AS Number_of_Tracks, "Genre"."Name"
FROM "InvoiceLine"
JOIN "Track"
ON "InvoiceLine"."TrackId" = "Track"."TrackId"
JOIN "Genre"
ON "Genre"."GenreId" = "Track"."GenreId"
GROUP BY "Genre"."Name",Number_of_Tracks
ORDER BY Number_of_Tracks DESC;

/***********************************************************************************************************************************************************************
                    		  											Rock Sales Per Year
***********************************************************************************************************************************************************************/

/***********************************************************************************************************************************************************************
 Here, in this code, SUM function is used to calculate the total sales amount for each 'Rock' track per year by multiplying the "Quantity" of
 tracks sold in each invoice line with the "UnitPrice" of the track. 
 
 The EXTRACT function is used to extract specific parts (like year, month, day, etc.) from a date or timestamp.
 
 The JOIN clauses are used to connect the Invoice, InvoiceLine, Track, and Genre tables to get the necessary information for the calculation
 
 The WHERE clause filters the results to consider only tracks that belong to the 'Rock' genre.
 
 The GROUP BY clause groups the results by genre name and year, allowing us to get one row for each combination of genre and year.                   		 
***********************************************************************************************************************************************************************/

SELECT 
    "Genre"."Name" AS Genre_Name,
    EXTRACT(YEAR FROM "InvoiceDate") AS Year,
    SUM(("InvoiceLine"."Quantity" * "InvoiceLine"."UnitPrice")) AS Total_Sales_Amount
FROM 
    "Invoice"
JOIN 
    "InvoiceLine" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
JOIN 
    "Track" ON "Track"."TrackId" = "InvoiceLine"."TrackId"
JOIN 
    "Genre" ON "Track"."GenreId" = "Genre"."GenreId"
WHERE 
    "Genre"."Name" = 'Rock'
GROUP BY 
    "Genre"."Name", Year;

/***********************************************************************************************************************************************************************
                    		 							Top 10 Cities With The Highest Number Of Total Invoices
***********************************************************************************************************************************************************************/	

/***********************************************************************************************************************************************************************
To find the Top 10 cities with the highest number of total invoices, We can perform a "Join" Between the "Custmer" & "Invoice" tables based
on the "CustomerId" column. By doing this, We can access both the city info and the invoice data.

Then we have to use "GROUP BY" clause to group the data of "city" and "sum" function will calculates the highest number of total invoices
for each "city".

"ORDER BY" can sorts the results. And to get highest total invoices we can use "DESC" and put "LIMIT" to get the desired numbers of cities.                    		 
***********************************************************************************************************************************************************************/

SELECT "City", SUM("Total") AS Total_Invoices
FROM "Customer"
JOIN "Invoice" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
GROUP BY "City"
ORDER BY Total_Invoices DESC
LIMIT 10;

/***********************************************************************************************************************************************************************
                    		 							Top 3 Cities Based On The Highest Total "UnitPrice"
***********************************************************************************************************************************************************************/

/***********************************************************************************************************************************************************************
To find the top 3 cities based on the highest total "UnitPrice", First We have to use "InvoiceLine" table to get the "unitPrice" for cities 
Second, We have to use "Customer" table to get the "Cities" info which is available there.
Third, We have to use "Invoice" table to allow the table to link with one another and have information connectd to each other.                    		 
***********************************************************************************************************************************************************************/

SELECT "Customer"."City", SUM("UnitPrice") AS Highest_Unit_Price
FROM "InvoiceLine"
JOIN "Invoice" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
JOIN "Customer" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
GROUP BY "City"
ORDER BY Highest_Unit_Price DESC
LIMIT 3;

/***********************************************************************************************************************************************************************
                    		  						Top 5 Billing Countries Based On The Highest Count Of "UnitPrice"
***********************************************************************************************************************************************************************/

/***********************************************************************************************************************************************************************
To Find the "Top 5 Billing Countries Based On The Highest Count Of UnitPrice" is as follows:
We have to use 2 tables which has the data required to find out the solution.

First, "Invoice" Table which has the data of the country and Second, We will use "InvoiceLine" table to get the count of UnitPrice which is 
available in that table.
Both can be Joined using "InvoiceId" column.                    		 
***********************************************************************************************************************************************************************/

SELECT "Invoice"."BillingCountry", COUNT("UnitPrice") AS Unit_Price_Count
FROM "InvoiceLine"
JOIN "Invoice" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
GROUP BY "BillingCountry"
ORDER BY Unit_Price_Count DESC
LIMIT 5;

/***********************************************************************************************************************************************************************
                    							 Top 10 Customers Based On The Highest Total Column Of Invoice Table
***********************************************************************************************************************************************************************/

SELECT "FirstName", "LastName", SUM("Total") AS Top_Customers
FROM "Customer"
JOIN "Invoice" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
GROUP BY "FirstName", "LastName"
ORDER BY Top_Customers DESC
LIMIT 10;

/***********************************************************************************************************************************************************************
                    		 					Which City Has The Best Customers Based On The Highest Total Sum Of UnitPrice? 
***********************************************************************************************************************************************************************/

SELECT "BillingCity", SUM("UnitPrice") AS Customer_Total_Revenue
FROM "Invoice"
JOIN "InvoiceLine" ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
GROUP BY "BillingCity"
ORDER BY Customer_Total_Revenue DESC;

/***********************************************************************************************************************************************************************
                    		 		 Use your query to return the email, first name, last name, and Genre of all Rock Music listeners.
							 					 Return your list ordered alphabetically by email address starting with A.
***********************************************************************************************************************************************************************/

-- This is Solution 1 (Using Sub-Query)

SELECT DISTINCT "Email" AS Customer_Email,"FirstName", "LastName"
FROM "Customer"
JOIN "Invoice" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
JOIN "InvoiceLine" ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
WHERE "TrackId" IN
(SELECT "TrackId" FROM "Track"
 JOIN "Genre" ON "Track"."GenreId" = "Genre"."GenreId"
 WHERE "Genre"."Name" LIKE 'Rock')
 ORDER BY "Email";

-- It Can Be Solved Without Sub-Query Too But By using subqueries, you can break down complex problems into smaller, more manageable parts, making it easier
-- to write and understand the SQL queries. . Let See In Solution 2

SELECT DISTINCT "Email" AS Customer_Email, "FirstName", "LastName"
FROM "Customer"
JOIN "Invoice" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
JOIN "InvoiceLine" ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
JOIN "Track" ON "InvoiceLine"."TrackId" = "Track"."TrackId"
JOIN "Genre" ON "Track"."GenreId" = "Genre"."GenreId"
WHERE "Genre"."Name" LIKE 'Rock'
ORDER BY Customer_Email;
/***********************************************************************************************************************************************************************
                    		 										Which Artist Is Singing Rock Music? 
***********************************************************************************************************************************************************************/

SELECT "Artist"."ArtistId" AS ArtistId_Number, "Artist"."Name" AS Artist_Name, COUNT ("Artist"."ArtistId") AS Song_Counts
FROM "Track"
JOIN "Album" ON "Album"."AlbumId" = "Track"."AlbumId"
JOIN "Artist" ON "Artist"."ArtistId" = "Album"."ArtistId"
JOIN "Genre" ON "Genre"."GenreId" = "Track"."GenreId"
WHERE "Genre"."Name" LIKE 'Rock'
GROUP BY "Artist"."ArtistId"
ORDER BY Song_Counts DESC
LIMIT 10;

/***********************************************************************************************************************************************************************
 						  Find the best-selling artist and then identify the customer who spent the most on that best-selling artist's tracks?
***********************************************************************************************************************************************************************/

/***********************************************************************************************************************************************************************
Explanation:
 It involves two main steps:
1. Finding the best selling-artist by calculating the total sales of each artist from the "InvoiceLine" table Using "CTE", and
2. Linking the customer's purchase data with the best selling artist's data to determine the top spender.						
***********************************************************************************************************************************************************************/

WITH CTE_Best_Selling_Artist AS
(SELECT "Artist"."ArtistId" AS Artist_Id, "Artist"."Name" AS Artist_Name, SUM("InvoiceLine"."UnitPrice" * "InvoiceLine"."Quantity") AS Total_Sales
 FROM "InvoiceLine"
 JOIN "Track" ON "Track"."TrackId" = "InvoiceLine"."TrackId"
 JOIN "Album" ON "Album"."AlbumId" = "Track"."AlbumId"
 JOIN "Artist" ON "Artist"."ArtistId" = "Album"."ArtistId"
 GROUP BY Artist_Id
 ORDER BY Total_Sales DESC
 LIMIT 1)
 
 SELECT CTE_Best_Selling_Artist.Artist_Name, SUM("InvoiceLine"."UnitPrice" * "InvoiceLine"."Quantity") AS Amount_Spent, "Customer"."CustomerId" AS Customer_Id, 
 "Customer"."FirstName" AS First_Name, "Customer"."LastName" AS Last_Name
 FROM "Invoice"
 JOIN "Customer" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
 JOIN "InvoiceLine" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
 JOIN "Track" ON "Track"."TrackId" = "InvoiceLine"."TrackId"
 JOIN "Album" ON "Album"."AlbumId" = "Track"."AlbumId"
 JOIN CTE_Best_Selling_Artist ON CTE_Best_Selling_Artist.Artist_Id = "Album"."ArtistId"
 GROUP BY Artist_Name, Customer_Id, First_Name, Last_Name
 ORDER BY Amount_Spent DESC;


/***********************************************************************************************************************************************************************
                    		 						(Advanced Query) Find out the most popular music Genre for each country
***********************************************************************************************************************************************************************/

--Solution 1
/***********************************************************************************************************************************************************************
- CTE named GenreSales that calculates the total sales for each music genre in each country and assigns a rank to each genre based on its total sales within its country
- UsingWindow function, It will assigns a rank to each genre within its country based on the total sales in descending order 
- In the CTE groups, the results by Country and Genre_Name will aggregate the data based on each unique combination of country and genre 
- The final Query gives us the most popular music genre for each country based on total sales 
***********************************************************************************************************************************************************************/

WITH GenreSales AS (
  SELECT "Customer"."Country" AS Country, "Genre"."Name" AS Genre_Name, SUM("InvoiceLine"."Quantity") AS Total_Sales,
         ROW_NUMBER() OVER (PARTITION BY "Customer"."Country" ORDER BY SUM("InvoiceLine"."Quantity") DESC) AS rank
  FROM "InvoiceLine"
  JOIN "Track" ON "Track"."TrackId" = "InvoiceLine"."TrackId"
  JOIN "Genre" ON "Genre"."GenreId" = "Track"."GenreId"
  JOIN "Invoice" ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
  JOIN "Customer" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
  GROUP BY "Customer"."Country", "Genre"."Name"
)
SELECT Country, Genre_Name, Total_Sales
FROM GenreSales
WHERE rank = 1
ORDER BY Total_Sales DESC;

/***********************************************************************************************************************************************************************
                    		 				Return all the track names that have a song length longer than the average song length.										
***********************************************************************************************************************************************************************/
--Solution 1
-- Here Using Window Function, OVER() can give AVG of average song length of all the songs in the table.

SELECT "Name", "Milliseconds"
FROM (
    SELECT "Name", "Milliseconds", AVG("Milliseconds") OVER () AS avg_song_length
    FROM "Track"
) AS subquery
WHERE "Milliseconds" > avg_song_length
ORDER BY "Milliseconds" DESC;

-- Solution 2
-- Sub-Query is used here to give the result with Where for conditions to get longer song length than the average.

SELECT "Name", "Milliseconds"
FROM "Track"
WHERE "Milliseconds" > (
    SELECT AVG("Milliseconds") FROM "Track"
)
ORDER BY "Milliseconds" DESC;

/***********************************************************************************************************************************************************************
                							Write a query that determines the customer that has spent the most on music for each country? 											 							         											  
***********************************************************************************************************************************************************************/

-- Here CTE is Used to calculate the total spending for each customer in each country.
-- Where Ranking 1 condition is used to filter the results and include top customer for each country.

WITH Customer_Spending_on_Music AS
(SELECT "Customer"."Country", "Invoice"."CustomerId", "Customer"."FirstName", "Customer"."LastName",
 SUM("Invoice"."Total") AS Total_Money_Spent,
 RANK() OVER (PARTITION BY "Customer"."Country" 
			  ORDER BY SUM ("Invoice"."Total") DESC) AS Ranking
 FROM "Invoice"
 JOIN "Customer" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
 GROUP BY "Customer"."Country", "Invoice"."CustomerId", "Customer"."FirstName", "Customer"."LastName")
 
 SELECT "Country", "FirstName" || ' ' || "LastName" AS Customer_Name, Total_Money_Spent
 FROM Customer_Spending_on_Music
 WHERE Ranking = 1
 ORDER BY "Country";
 
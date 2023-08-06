/********************************************************************************************************************************************
                      				CHECKING ALL THE TABLES OF CHINOOK MUSIC DATABASE
********************************************************************************************************************************************/
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

/********************************************************************************************************************************************
                    			 In this Chinook Database, we are finding about the following:
********************************************************************************************************************************************/

/********************************************************************************************************************************************
                    			 	  Who Are The Top 5 Artists Who Produce More Album?
********************************************************************************************************************************************/
SELECT "Artist"."Name" AS Artist_Name, COUNT("Album"."AlbumId") AS Album_Count
FROM "Artist"
JOIN "Album" ON "Artist"."ArtistId" = "Album"."ArtistId"
GROUP BY "Artist"."Name"
ORDER BY Album_Count DESC
LIMIT 5;

/********************************************************************************************************************************************
                    							 Number Of Tracks Sold Per Genre
********************************************************************************************************************************************/
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

/********************************************************************************************************************************************
                    								 Rock Sales Per Year
********************************************************************************************************************************************/

/********************************************************************************************************************************************
 Here, in this code, SUM function is used to calculate the total sales amount for each 'Rock' track per year by multiplying the "Quantity" of
 tracks sold in each invoice line with the "UnitPrice" of the track. 
 
 The EXTRACT function is used to extract specific parts (like year, month, day, etc.) from a date or timestamp.
 
 The JOIN clauses are used to connect the Invoice, InvoiceLine, Track, and Genre tables to get the necessary information for the calculation
 
 The WHERE clause filters the results to consider only tracks that belong to the 'Rock' genre.
 
 The GROUP BY clause groups the results by genre name and year, allowing us to get one row for each combination of genre and year.
********************************************************************************************************************************************/
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
	
/********************************************************************************************************************************************
                    							Top 10 Cities With The Highest Number Of Total Invoices
********************************************************************************************************************************************/

/********************************************************************************************************************************************
To find the Top 10 cities with the highest number of total invoices, We can perform a "Join" Between the "Custmer" & "Invoice" tables based
on the "CustomerId" column. By doing this, We can access both the city info and the invoice data.

Then we have to use "GROUP BY" clause to group the data of "city" and "sum" function will calculates the highest number of total invoices
for each "city".

"ORDER BY" can sorts the results. And to get highest total invoices we can use "DESC" and put "LIMIT" to get the desired numbers of cities.
********************************************************************************************************************************************/

SELECT "City", SUM("Total") AS Total_Invoices
FROM "Customer"
JOIN "Invoice" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
GROUP BY "City"
ORDER BY Total_Invoices DESC
LIMIT 10;

/********************************************************************************************************************************************
                    						Top 3 Cities Based On The Highest Total "UnitPrice"
********************************************************************************************************************************************/

/********************************************************************************************************************************************
To find the top 3 cities based on the highest total "UnitPrice", First We have to use "InvoiceLine" table to get the "unitPrice" for cities 
Second, We have to use "Customer" table to get the "Cities" info which is available there.
Third, We have to use "Invoice" table to allow the table to link with one another and have information connectd to each other.
********************************************************************************************************************************************/
SELECT "Customer"."City", SUM("UnitPrice") AS Highest_Unit_Price
FROM "InvoiceLine"
JOIN "Invoice" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
JOIN "Customer" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
GROUP BY "City"
ORDER BY Highest_Unit_Price DESC
LIMIT 3;

/********************************************************************************************************************************************
                    				  Top 5 Billing Countries Based On The Highest Count Of "UnitPrice"
********************************************************************************************************************************************/

/********************************************************************************************************************************************
To Find the "Top 5 Billing Countries Based On The Highest Count Of UnitPrice" is as follows:
We have to use 2 tables which has the data required to find out the solution.

First, "Invoice" Table which has the data of the country and Second, We will use "InvoiceLine" table to get the count of UnitPrice which is 
available in that table.
Both can be Joined using "InvoiceId" column.
********************************************************************************************************************************************/
SELECT "Invoice"."BillingCountry", COUNT("UnitPrice") AS Unit_Price_Count
FROM "InvoiceLine"
JOIN "Invoice" ON "InvoiceLine"."InvoiceId" = "Invoice"."InvoiceId"
GROUP BY "BillingCountry"
ORDER BY Unit_Price_Count DESC
LIMIT 5;

/********************************************************************************************************************************************
                    				  Top 10 Customers Based On The Highest Total Column Of Invoice Table
********************************************************************************************************************************************/
SELECT "FirstName", "LastName", SUM("Total") AS Top_Customers
FROM "Customer"
JOIN "Invoice" ON "Customer"."CustomerId" = "Invoice"."CustomerId"
GROUP BY "FirstName", "LastName"
ORDER BY Top_Customers DESC
LIMIT 10;

/********************************************************************************************************************************************
                    			   Which City Has The Best Customers Based On The Highest Total Sum Of UnitPrice? 
********************************************************************************************************************************************/
SELECT "BillingCity", SUM("UnitPrice") AS Customer_Total_Revenue
FROM "Invoice"
JOIN "InvoiceLine" ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
GROUP BY "BillingCity"
ORDER BY Customer_Total_Revenue DESC;


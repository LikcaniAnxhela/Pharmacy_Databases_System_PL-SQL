--A. BASIC QUERIES--
--1. How would you retrieve all the customer names along with their problems from the Customers table?--
SELECT NAME, PROBLEM FROM CUSTOMERS;

--2  Write a query to display the list of all medicines, including their Product Name, MRP, and Expiry Date.--
SELECT PRODUCT_NAME, MRP, EXPIRY_DATE FROM MEDICINES;

--3 How can you find all managers' names and their authentication numbers from the Users table? --
SELECT NAME, USER_ID FROM USERS WHERE ROLE = 'MANAGER';

--4. Write a query to fetch the details of customers who bought a specific medicine (e.g., "Paracetamol").--
SELECT DISTINCT C.*
FROM CUSTOMERS C
JOIN SALES S ON C.CUSTOMER_ID = S.CUSTOMER_ID
JOIN MEDICINES M ON S.PRODUCT_CODE =
M.PRODUCT_CODE
WHERE M.PRODUCT_NAME = 'PARACETAMOL';

--5.Retrieve the email addresses of all users who are not managers. --
SELECT EMAIL FROM USERS WHERE ROLE <> 
'MANAGER';

--B. INTERMEDIATE QUERIES--
--6. How would you display all medicines that are set to expire in the next 60 days?--
SELECT * FROM MEDICINES 
WHERE EXPIRY_DATE <= SYSDATE + 60;

--7.Write a query to fetch a list of medicines that have a Quantity less than 10. --
SELECT * FROM MEDICINES
WHERE QUANTITY < 10;

--8. Find all customers who are male (Sex = 'M') and bought medicines with an MRP greater than $50.--
SELECT DISTINCT C.NAME
FROM CUSTOMERS C
JOIN SALES S ON C.CUSTOMER_ID = S.CUSTOMER_ID
JOIN MEDICINES M ON S.PRODUCT_CODE =
M.PRODUCT_CODE
WHERE C.SEX = 'M' AND M.MRP > 50;

--9. Write a query to calculate the total quantity of a particular medicine (e.g., "Ibuprofen") sold.--
SELECT SUM (QUANTITY)
FROM SALES S 
JOIN MEDICINES M ON S.PRODUCT_CODE=M.PRODUCT_CODE
WHERE M.PRODUCT_NAME='IBUPROFEN';

--10. How can you list the names of customers along with the Product Name of the medicines they purchased?--
SELECT C.NAME, M.PRODUCT_NAME
FROM CUSTOMERS C
JOIN SALES S ON C.CUSTOMER_ID = S.CUSTOMER_ID
JOIN MEDICINES M ON S.PRODUCT_CODE =
M.PRODUCT_CODE;

--C. JOIN & AGGREGATION--
--11.Write a query to fetch the sales report showing each customer’s name, the medicines they purchased, and the quantity sold--
SELECT C.NAME, M.PRODUCT_NAME, S.QUANTITY_SOLD
FROM SALES S
JOIN CUSTOMERS C ON S.CUSTOMER_ID =
C.CUSTOMER_ID
JOIN MEDICINES M ON S.PRODUCT_CODE =
M.PRODUCT_CODE;

--12.How would you calculate the total sales amount (sum of MRP × Quantity) for all medicines? --
SELECT SUM (M.MRP * S.QUANTITY_SOLD) AS
TOTAL_SALES_AMOUNT
FROM SALES S
JOIN MEDICINES M ON S.PRODUCT_CODE =
M.PRODUCT_CODE;

--13.Create a query to find which medicine has the highest stock (Quantity). --
SELECT PRODUCT_NAME
FROM MEDICINES
WHERE QUANTITY = (SELECT MAX(QUANTITY) FROM
MEDICINES);

--14.Write a query to display the total number of customers served by the system. --
SELECT COUNT(*) AS TOTAL_CUSTOMERS FROM 
CUSTOMERS;

--15.Generate a report showing the total number of medicines sold, grouped by their Product Name.--
SELECT M.PRODUCT_NAME, SUM(S.QUANTITY_SOLD)
AS TOTAL_SOLD
FROM SALES S
JOIN MEDICINES M ON S.PRODUCT_CODE =
M.PRODUCT_CODE
GROUP BY M.PRODUCT_NAME;

--D. COMPLEX QUERIES--
--16.How would you find customers who have bought more than 5 medicines in total? --
SELECT CUSTOMER_ID 
FROM SALES
GROUP BY CUSTOMER_ID
HAVING SUM(QUANTITY_SOLD)>5;

--17. Write a query to fetch the top 3 medicines with the highest sales (MRP × Quantity).--
SELECT PRODUCT_NAME
FROM (
SELECT M.PRODUCT_NAME, SUM(M.MRP*S.QUANTITY_SOLD) AS
TOTAL_SALES
FROM SALES S
JOIN MEDICINES M ON S.PRODUCT_CODE =M.PRODUCT_CODE
GROUP BY M.PRODUCT_NAME
ORDER BY TOTAL_SALES DESC)
WHERE ROWNUM <=3;

--18.How can you generate a report that lists medicines that have been sold but are now out of stock (Quantity = 0)? --
SELECT DISTINCT M.PRODUCT_NAME
FROM MEDICINES M 
JOIN SALES S ON M.PRODUCT_CODE = S.PRODUCT_CODE
WHERE M.QUANTITY =0;

--19.Find all customers who have purchased at least one expired medicine. --
SELECT DISTINCT C.NAME
FROM CUSTOMERS C
JOIN SALES S ON C.CUSTOMER_ID = S.CUSTOMER_ID
JOIN MEDICINES M ON S.PRODUCT_CODE = M.PRODUCT_CODE
WHERE M.EXPIRY_DATE < S.SALE_DATE;

--20.Write a query to display a summary report showing each manager’s name and the total number of reports they have viewed. --
SELECT U.NAME, COUNT(R.VIEWED_BY) AS REPORTS_VIEWED
FROM USERS U
LEFT JOIN REPORTS R ON U.USER_ID = R.VIEWED_BY
GROUP BY U.NAME;

--E.SUBQUERIES--
--21. Find all medicines that have a higher MRP than the average price of all medicines. --
SELECT *FROM USERS WHERE USER_ID NOT IN (SELECT VIEWED_BY FROM REPORTS);

--22. Retrieve the details of the customer(s) who bought the most expensive medicine.--
SELECT C.*
FROM CUSTOMERS C
JOIN SALES S ON C.CUSTOMER_ID = S.CUSTOMER_ID
JOIN MEDICINES M ON S.PRODUCT_CODE =
M.PRODUCT_CODE
WHERE M.MRP = (SELECT MAX(MRP) FROM MEDICINES);

--23. Write a query to list all users who have not yet viewed any reports. --
SELECT *FROM USERS
WHERE USER_ID NOT IN (SELECT VIEWED_BY 
FROM REPORTS);

--24.Find customers who are older than the average age of all customers in the system. --
SELECT * FROM CUSTOMERS 
WHERE AGE > (SELECT AVG(AGE)FROM CUSTOMERS);

--25. How would you display all medicines purchased by customers with names starting with the letter 'A'? --
SELECT DISTINCT M.PRODUCT_NAME
FROM MEDICINES M
JOIN SALES S ON M.PRODUCT_CODE =
S.PRODUCT_CODE
JOIN CUSTOMERS C ON S.CUSTOMER_ID =
C.CUSTOMER_ID
WHERE C.NAME LIKE 'A%';

--F.PRACTICAL SCENARIOS--
--26.A customer complains about receiving expired medicines. Write a query to find all expired medicines purchased by that customer. --
SELECT M.*
FROM MEDICINES M
JOIN SALES S ON M.PRODUCT_CODE =
S.PRODUCT_CODE
JOIN CUSTOMERS C ON S.CUSTOMER_ID =
C.CUSTOMER_ID
WHERE C.NAME = 'ALI'
AND M.EXPIRY_DATE < SYSDATE;

--27. The manager wants to check inventory levels. Write a query to list all medicines with their stock levels in descending order.--
SELECT PRODUCT_NAME, QUANTITY
FROM MEDICINES
ORDER BY QUANTITY DESC;

--28. Generate a query to find which customers have purchased more than one type of medicine. --
SELECT CUSTOMER_ID
FROM SALES
GROUP BY CUSTOMER_ID
HAVING COUNT(DISTINCT PRODUCT_CODE) > 1;

--29. If a new shipment of a medicine arrives, write an UPDATE query to add 100 units to its stock.--
UPDATE MEDICINES
SET QUANTITY = QUANTITY + 100
WHERE PRODUCT_NAME = 'PARACETAMOL';

--30.The manager needs a monthly sales report. Write a query to calculate the total sales for the past month, grouped by medicine. --
SELECT M.PRODUCT_NAME,
SUM(M.MRP * S.QUANTITY_SOLD) AS
MONTHLY_SALES
FROM SALES S
JOIN MEDICINES M ON S.PRODUCT_CODE =
M.PRODUCT_CODE
WHERE S.SALE_DATE >=
ADD_MONTHS(TRUNC(SYSDATE), -1)
GROUP BY M.PRODUCT_NAME;

--G. ADVANCED--
--31.Write a query to identify duplicate records in the Medicines table (if any) based on Product Code and Product Name. --
SELECT PRODUCT_CODE, PRODUCT_NAME, COUNT(*)
FROM MEDICINES
GROUP BY PRODUCT_CODE, PRODUCT_NAME
HAVING COUNT(*)> 1;

--32.Create a query to calculate the profit margin on each medicine (if an additional Cost Price column is added). --
ALTER TABLE MEDICINES ADD COST_PRICE NUMBER(8,2);


SELECT PRODUCT_NAME,
MRP,
COST_PRICE,
(MRP - COST_PRICE) AS PROFIT
FROM MEDICINES;

--33.How would you design a query to delete all records of medicines that expired more than a year ago? --
DELETE FROM MEDICINES WHERE EXPIRY_DATE < ADD_MONTHS(SYSDATE, -12);

--34. Write a query to show the sales trend of a specific medicine over the last six months.--
SELECT TO_CHAR(S.SALE_DATE, 'YYYY-MM') AS MONTH,
SUM (S.QUANTITY_SOLD) AS TOTAL_SOLD
FROM SALES S
JOIN MEDICINES M ON S.PRODUCT_CODE =
M.PRODUCT_CODE
WHERE M.PRODUCT_NAME = 'PARACETAMOL'
AND S.SALE_DATE >= ADD_MONTHS(SYSDATE, -6)
GROUP BY TO_CHAR(S.SALE_DATE,'YYYY-MM')
ORDER BY MONTH;

--35. How would you fetch the details of the 5 most active customers based on the total quantity of medicines purchased?--
SELECT C.NAME, SUM(S.QUANTITY_SOLD) AS
TOTAL_PURCHASED
FROM CUSTOMERS C
JOIN SALES S ON C.CUSTOMER_ID = S.CUSTOMER_ID
GROUP BY C.NAME
ORDER BY TOTAL_PURCHASED DESC
FETCH FIRST 5 ROWS ONLY;

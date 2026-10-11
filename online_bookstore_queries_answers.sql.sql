CREATE DATABASE IF NOT EXISTS OnlineBookstore;

USE OnlineBookstore;

DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10,2),
    Stock INT
);


DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);


DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT COUNT(*) 
FROM ORDERS;


-- QUESTIONS

-- 1) Retrieve all books in the "Fiction" genre:

SELECT * 
FROM BOOKS
WHERE GENRE = 'FICTION';

-- 2) Find books published after the year 1950:

SELECT * 
FROM BOOKS 
WHERE PUBLISHED_YEAR > '1950'
ORDER BY published_year ASC;


-- 3) List all customers from the Canada:

SELECT * 
FROM CUSTOMERS
WHERE COUNTRY = 'CANADA';


-- 4) Show orders placed in November 2023:

SELECT * 
FROM ORDERS
WHERE ORDER_DATE BETWEEN '2023-11-01' AND  '2023-11-30';


-- 5) Retrieve the total stock of books available:

SELECT SUM(STOCK) AS TOTAL_STOCK
FROM BOOKS;

-- 6) Find the details of the most expensive book:

SELECT * 
FROM BOOKS
ORDER BY PRICE DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT * 
FROM ORDERS
WHERE QUANTITY > '1'
ORDER BY QUANTITY;


-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * 
FROM ORDERS
WHERE TOTAL_AMOUNT > '20'
ORDER BY TOTAL_AMOUNT;

-- 9) List all genres available in the Books table:

SELECT DISTINCT GENRE 
FROM BOOKS;


-- 10) Find the book with the lowest stock:

SELECT * 
FROM BOOKS 
ORDER BY STOCK ;

-- 11) Calculate the total revenue generated from all orders:

SELECT SUM(TOTAL_AMOUNT) AS REVENUE
FROM ORDERS;


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;


-- 2) Find the average price of books in the "Fantasy" genre:

SELECT  AVG(PRICE) AS AVG_PRICE
FROM BOOKS
WHERE GENRE = "Fantasy";


-- 3) List customers who have placed at least 2 orders:

SELECT CUSTOMERS.CUSTOMER_ID, CUSTOMERS.NAME, ORDERS.QUANTITY
FROM CUSTOMERS
JOIN ORDERS
ON CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID
WHERE QUANTITY >='2'
ORDER BY QUANTITY;


-- 4) Find the most frequently ordered book:

SELECT BOOK_ID, COUNT(*) AS ORDER_COUNT
FROM ORDERS
GROUP BY BOOK_ID
ORDER BY ORDER_COUNT DESC
LIMIT 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT  GENRE, PRICE
FROM BOOKS
WHERE GENRE = 'FANTASY'
ORDER BY PRICE DESC
LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:

SELECT  BOOKS.AUTHOR, SUM(ORDERS.QUANTITY) AS BOOK_QUANTITY
FROM ORDERS 
JOIN BOOKS
ON BOOKS.BOOK_ID = ORDERS.BOOK_ID
GROUP BY AUTHOR;

-- 7) List the cities where customers who spent over $30 are located:


SELECT  CUSTOMERS.CITY, ORDERS.TOTAL_AMOUNT AS SPENT_AM
FROM CUSTOMERS
JOIN ORDERS
ON CUSTOMERS.Customer_ID = ORDERS.Customer_ID
WHERE TOTAL_AMOUNT > '30'
ORDER BY SPENT_AM;


-- 8) Find the customer who spent the most on orders:


SELECT C.NAME, C.CUSTOMER_ID, SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM ORDERS O
JOIN CUSTOMERS C
ON O.Customer_ID = C.Customer_ID
GROUP BY C.NAME, C.CUSTOMER_ID
ORDER BY TOTAL_SPENT DESC
LIMIT 1;



-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT 
    b.book_id,
    b.title,
    b.stock,
    COALESCE(SUM(o.quantity), 0) AS Order_quantity,
    b.stock - COALESCE(SUM(o.quantity), 0) AS Remaining_Quantity
FROM
    books b
        LEFT JOIN
    orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;








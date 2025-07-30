-- Q0: the name of the database on the class server in which I can find your schema
-- database: jesssjw_db

-- Q1: a list of CREATE TABLE statements implementing your schema
CREATE TABLE Movies (
    movie_id INT,
    title VARCHAR(255),
    year INT,
    genre VARCHAR(100),
    actor_name VARCHAR(255),
    director_name VARCHAR(255), 
	PRIMARY KEY (movie_id)
);

CREATE TABLE Movie_customers (
	customer_id INT,
	customer_dob VARCHAR(255),
	customer_name VARCHAR(255), 
	PRIMARY KEY (customer_id)
);

CREATE TABLE Rating (
	movie_id INT, 
	customer_id INT,
	score INT,
	num_ratings INT,
	genre VARCHAR(255),
	year INT, 
	FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
	FOREIGN KEY (customer_id) REFERENCES Movie_customers(customer_id)
);

CREATE TABLE Directors (
	director_name VARCHAR(255),
	director_dob VARCHAR(255),
	PRIMARY KEY (director_name)
);

CREATE TABLE Ticket_sales (
	ticket_id VARCHAR(255),
	price FLOAT,
	year INT,
	num_sold INT,
	customer_id INT,
	PRIMARY KEY (ticket_id),
	FOREIGN KEY (customer_id) REFERENCES Movie_customers(customer_id)
);

-- Q2: a list of 10 SQL statements using your schema, along with the English question it 
-- implements.
-- 1. What are the top 3 top-rating movies in the last year? (Customer)
SELECT m.title, AVG(r.score) as average_score
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
WHERE m.year = 2023
GROUP BY m.title
ORDER BY average_score DESC
LIMIT 3;

-- 2. Which director has the highest average ratings? (Movie Administrator)
SELECT m.director_name, AVG(r.score) AS ave_rating
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
GROUP BY m.director_name
ORDER BY ave_rating DESC
LIMIT 1;

-- 3. How many ratings do each movie have? (Movie Administrator)
SELECT m.movie_id, m.title, COUNT(r.movie_id) AS total_ratings
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY total_ratings DESC;

-- 4. Which genre has the lowest score in the past year? (Analyst)
SELECT r.genre, r.score
FROM rating r
JOIN movies m ON r.genre = m.genre
WHERE r.year = 2023
ORDER BY r.score DESC
LIMIT 1;

-- 5. Which customers bought multiple tickets for the same movie? (Movie Administrator)
SELECT c.customer_id, t.num_sold
FROM movie_customers c
JOIN ticket_sales t ON t.customer_id = c.customer_id
WHERE num_sold > 1;

-- 6. Which tickets had the highest prices? (Movie Administrator)
SELECT max(price) AS price, ticket_id
FROM ticket_sales
GROUP BY ticket_id
LIMIT 3;

-- 7. Which movie genre has the most ratings in 2020? (Movie administrator)
SELECT genre, SUM(num_ratings) as total_ratings
FROM Rating
WHERE year = 2020
GROUP BY genre
ORDER BY total_ratings DESC
LIMIT 1;

-- 8. What is the average rating for each genre, the total number of ratings received 
-- by movies in each genre, and the average number of ratings per movie, for movies 
-- released after 2000? (Data Analyst)
SELECT 
    m.genre,
    AVG(r.score) AS average_rating,
    COUNT(r.movie_id) AS total_ratings,
    COUNT(r.movie_id) / COUNT(DISTINCT m.movie_id) AS average_ratings_per_movie
FROM 
    Movies m
JOIN 
    Rating r ON m.movie_id = r.movie_id
WHERE 
    m.year > 2000
GROUP BY 
    m.genre
ORDER BY 
    average_rating DESC, total_ratings DESC;

-- 9. What is the average ticket price in 2019? (customer)
SELECT 
    AVG(price) AS average_ticket_price
FROM 
    Ticket_sales
WHERE 
    year = 2019;

-- 10. What is the average rating of movies directed by a specific director 
-- (e.g., 'Steven Spielberg')?(customer)
SELECT AVG(r.score) AS average_rating
FROM Mov-- Q0: the name of the database on the class server in which I can find your schema
-- database: jesssjw_db

-- Q1: a list of CREATE TABLE statements implementing your schema
CREATE TABLE Movies (
    movie_id INT,
    title VARCHAR(255),
    year INT,
    genre VARCHAR(100),
    actor_name VARCHAR(255),
    director_name VARCHAR(255), 
	PRIMARY KEY (movie_id)
);

CREATE TABLE Movie_customers (
	customer_id INT,
	customer_dob VARCHAR(255),
	customer_name VARCHAR(255), 
	PRIMARY KEY (customer_id)
);

CREATE TABLE Rating (
	movie_id INT, 
	customer_id INT,
	score INT,
	num_ratings INT,
	genre VARCHAR(255),
	year INT, 
	FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
	FOREIGN KEY (customer_id) REFERENCES Movie_customers(customer_id)
);

CREATE TABLE Directors (
	director_name VARCHAR(255),
	director_dob VARCHAR(255),
	PRIMARY KEY (director_name)
);

CREATE TABLE Ticket_sales (
	ticket_id VARCHAR(255),
	price FLOAT,
	year INT,
	num_sold INT,
	customer_id INT,
	PRIMARY KEY (ticket_id),
	FOREIGN KEY (customer_id) REFERENCES Movie_customers(customer_id)
);

-- Q2: a list of 10 SQL statements using your schema, along with the English question it 
-- implements.
-- 1. What are the top 3 top-rating movies in the last year? (Customer)
SELECT m.title, AVG(r.score) as average_score
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
WHERE m.year = 2023
GROUP BY m.title
ORDER BY average_score DESC
LIMIT 3;

-- 2. Which director has the highest average ratings? (Movie Administrator)
SELECT m.director_name, AVG(r.score) AS ave_rating
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
GROUP BY m.director_name
ORDER BY ave_rating DESC
LIMIT 1;

-- 3. How many ratings do each movie have? (Movie Administrator)
SELECT m.movie_id, m.title, COUNT(r.movie_id) AS total_ratings
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY total_ratings DESC;

-- 4. Which genre has the lowest score in the past year? (Analyst)
SELECT r.genre, r.score
FROM rating r
JOIN movies m ON r.genre = m.genre
WHERE r.year = 2023
ORDER BY r.score DESC
LIMIT 1;

-- 5. Which customers bought multiple tickets for the same movie? (Movie Administrator)
SELECT c.customer_id, t.num_sold
FROM movie_customers c
JOIN ticket_sales t ON t.customer_id = c.customer_id
WHERE num_sold > 1;

-- 6. Which tickets had the highest prices? (Movie Administrator)
SELECT max(price) AS price, ticket_id
FROM ticket_sales
GROUP BY ticket_id
LIMIT 3;

-- 7. Which movie genre has the most ratings in 2020? (Movie administrator)
SELECT genre, SUM(num_ratings) as total_ratings
FROM Rating
WHERE year = 2020
GROUP BY genre
ORDER BY total_ratings DESC
LIMIT 1;

-- 8. What is the average rating for each genre, the total number of ratings received 
-- by movies in each genre, and the average number of ratings per movie, for movies 
-- released after 2000? (Data Analyst)
SELECT 
    m.genre,
    AVG(r.score) AS average_rating,
    COUNT(r.movie_id) AS total_ratings,
    COUNT(r.movie_id) / COUNT(DISTINCT m.movie_id) AS average_ratings_per_movie
FROM 
    Movies m
JOIN 
    Rating r ON m.movie_id = r.movie_id
WHERE 
    m.year > 2000
GROUP BY 
    m.genre
ORDER BY 
    average_rating DESC, total_ratings DESC;

-- 9. What is the average ticket price in 2019? (customer)
SELECT 
    AVG(price) AS average_ticket_price
FROM 
    Ticket_sales
WHERE 
    year = 2019;

-- 10. What is the average rating of movies directed by a specific director 
-- (e.g., 'Steven Spielberg')?(customer)
SELECT AVG(r.score) AS average_rating
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
WHERE m.director_name = 'Steven Spielberg';


-- Q3: a list of 3-5 demo queries that return (minimal) sensible results. 
-- Please specify the team member responsible for each. These can be a subset of the 
-- 10 queries implemented for Q2, in which case it's okay to list them twice.
-- 1. Jessica: How many ratings do each movie have? (Movie Administrator)
-- Query:
SELECT m.movie_id, m.title, COUNT(r.movie_id) AS total_ratings
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY total_ratings DESC;

-- Insert statements:
INSERT INTO Movies (movie_id, title, year, genre, actor_name, director_name) VALUES
(1, 'Doctor Strange in the Multiverse of Madness', 2022, 'Action', 
 	'Benedict Cumberbatch', 'Sam Raimi'),
(2, 'Spider-Man: No Way Home', 2021, 'Action', 'Tom Holland', 'Jon Watts'),
(3, 'Barbie', 2023, 'Comedy', 'Margot Robbie', 'Greta Gerwig'),
(4, 'Anyone But You', 2023, 'Romance', 'Actor Name', 'Director Name');

INSERT INTO Movie_customers (customer_id, customer_dob, customer_name) VALUES 
(10, '1990-01-01', 'Jane Doe'),
(11, '2000-04-28', 'John Baker'),
(12, '2002-06-17', 'Bill Gates'),
(13, '1999-07-08', 'Oprah Winfrey'),
(14, '2001-08-21', 'Jennifer Lawrence'),
(15, '2000-11-14', 'Zendaya');

INSERT INTO Rating (movie_id, customer_id, score, num_ratings, genre, year) VALUES
(1, 10, 5, 1, 'Action', 2022),
(1, 11, 4, 1, 'Action', 2022),
(2, 12, 5, 1, 'Action', 2021),
(2, 13, 5, 1, 'Action', 2021),
(3, 14, 5, 1, 'Comedy', 2023),
(4, 15, 0, 0, 'Romance', 2021);

-- 2. Stephanie: Out of all of the movies that a certain actor has acted in, which one had the highest ratings?
-- Query:
SELECT m.actor_name, m.title, MAX(r.score) as score
FROM movies m
JOIN rating r on r.movie_id = m.movie_id
WHERE m.actor_name = 'Margot Robbie'
GROUP BY m.actor_name, m.title;

-- 3. Brian: What is the average rating of movies directed by a specific director 
-- (e.g., 'Steven Spielberg')?(customer)
SELECT AVG(r.score) AS average_rating
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
WHERE m.director_name = 'Steven Spielberg';

-- Insert statements:
INSERT INTO Directors (director_name, director_dob) VALUES
('Steven Spielberg', '1946-12-18');

INSERT INTO Movies (movie_id, title, year, genre, actor_name, director_name) VALUES
(5, 'Jaws', 1975, 'Thriller', 'Roy Scheider', 'Steven Spielberg'),
(6, 'E.T. the Extra-Terrestrial', 1982, 'Sci-Fi', 'Henry Thomas', 'Steven Spielberg'),
(7, 'Jurassic Park', 1993, 'Adventure', 'Sam Neill', 'Steven Spielberg');

INSERT INTO Movie_customers (customer_id, customer_dob, customer_name) VALUES
(16, '1980-05-21', 'Alice Johnson'),
(17, '1992-11-30', 'Bob Smith'),
(18, '1985-07-16', 'Carol Williams'),
(19, '1979-02-24', 'David Jones'),
(20, '1995-08-19', 'Eva Brown');

INSERT INTO Rating (movie_id, customer_id, score, num_ratings, genre, year) VALUES
(5, 16, 5, 1, 'Thriller', 1975),
(5, 17, 4, 1, 'Thriller', 1975),
(5, 18, 4, 1, 'Thriller', 1975),
(6, 19, 5, 1, 'Sci-Fi', 1982),
(6, 20, 5, 1, 'Sci-Fi', 1982),
(7, 16, 5, 1, 'Adventure', 1993),
(7, 17, 4, 1, 'Adventure', 1993),
(7, 18, 5, 1, 'Adventure', 1993),
(7, 19, 5, 1, 'Adventure', 1993),
(7, 20, 5, 1, 'Adventure', 1993);

-- Q4: reflection on what you learned and challenges.
-- This project has allowed us to gain a deeper understanding about database relationships 
-- through the process of using CREATE TABLE statements to create these tables and identifying
-- PRIMARY and FOREIGN keys. We also gained a better understanding on how to create ERDs and 
-- what the various relationship links mean. Another technical skill we learned and practiced 
-- more was SQL queries as P4 has allowed us to use critical thinking skills when it came to 
-- the demo queries as we had to analyze what data we had to use for INSERT INTO statements to
-- satisfy our query output. Some challeges we faced include schema constraints as our initial
-- ERD could have had more attributes that could help us link all the entities better as we had 
-- to really analyze what queries we could output with the tables we created. It was also 
-- challenging to make sure our own queries had the same format throughout for the assignment 
-- to look more cohesive. Overall, this project allowed us to apply the database and SQL
-- knowledge we've learned in this course.ies m
JOIN Rating r ON m.movie_id = r.movie_id
WHERE m.director_name = 'Steven Spielberg';


-- Q3: a list of 3-5 demo queries that return (minimal) sensible results. 
-- Please specify the team member responsible for each. These can be a subset of the 
-- 10 queries implemented for Q2, in which case it's okay to list them twice.
-- 1. Jessica: How many ratings do each movie have? (Movie Administrator)
-- Query:
SELECT m.movie_id, m.title, COUNT(r.movie_id) AS total_ratings
FROM Movies m
JOIN Rating r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY total_ratings DESC;

-- Insert statements:
INSERT INTO Movies (movie_id, title, year, genre, actor_name, director_name) VALUES
(1, 'Doctor Strange in the Multiverse of Madness', 2022, 'Action', 
 	'Benedict Cumberbatch', 'Sam Raimi'),
(2, 'Spider-Man: No Way Home', 2021, 'Action', 'Tom Holland', 'Jon Watts'),
(3, 'Barbie', 2023, 'Comedy', 'Margot Robbie', 'Greta Gerwig'),
(4, 'Anyone But You', 2023, 'Romance', 'Actor Name', 'Director Name');

INSERT INTO Movie_customers (customer_id, customer_dob, customer_name) VALUES 
(10, '1990-01-01', 'Jane Doe'),
(11, '2000-04-28', 'John Baker'),
(12, '2002-06-17', 'Bill Gates'),
(13, '1999-07-08', 'Oprah Winfrey'),
(14, '2001-08-21', 'Jennifer Lawrence'),
(15, '2000-11-14', 'Zendaya');

INSERT INTO Rating (movie_id, customer_id, score, num_ratings, genre, year) VALUES
(1, 10, 5, 1, 'Action', 2022),
(1, 11, 4, 1, 'Action', 2022),
(2, 12, 5, 1, 'Action', 2021),
(2, 13, 5, 1, 'Action', 2021),
(3, 14, 5, 1, 'Comedy', 2023),
(4, 15, 0, 0, 'Romance', 2021);

-- 2. Stephanie: Out of all of the movies that a certain actor has acted in, which one had the highest ratings?
-- Query:
SELECT m.actor_name, m.title, MAX(r.score) as score
FROM movies m
JOIN rating r on r.movie_id = m.movie_id
WHERE m.actor_name = 'Margot Robbie'
GROUP BY m.actor_name, m.title;

-- 3. Brian: What is the average rating for each genre, the total number of ratings received 
-- by movies in each genre, and the average number of ratings per movie, for movies 
-- released after 2000? (Data Analyst)
-- Query:
SELECT 
    m.genre,
    AVG(r.score) AS average_rating,
    COUNT(r.movie_id) AS total_ratings,
    COUNT(r.movie_id) / COUNT(DISTINCT m.movie_id) AS average_ratings_per_movie
FROM 
    Movies m
JOIN 
    Rating r ON m.movie_id = r.movie_id
WHERE 
    m.year > 2000
GROUP BY 
    m.genre
ORDER BY 
    average_rating DESC, total_ratings DESC;

-- Insert statements:
INSERT INTO Directors (director_name, director_dob) VALUES
('Steven Spielberg', '1946-12-18');

INSERT INTO Movies (movie_id, title, year, genre, actor_name, director_name) VALUES
(5, 'Jaws', 1975, 'Thriller', 'Roy Scheider', 'Steven Spielberg'),
(6, 'E.T. the Extra-Terrestrial', 1982, 'Sci-Fi', 'Henry Thomas', 'Steven Spielberg'),
(7, 'Jurassic Park', 1993, 'Adventure', 'Sam Neill', 'Steven Spielberg');

INSERT INTO Movie_customers (customer_id, customer_dob, customer_name) VALUES
(16, '1980-05-21', 'Alice Johnson'),
(17, '1992-11-30', 'Bob Smith'),
(18, '1985-07-16', 'Carol Williams'),
(19, '1979-02-24', 'David Jones'),
(20, '1995-08-19', 'Eva Brown');

INSERT INTO Rating (movie_id, customer_id, score, num_ratings, genre, year) VALUES
(5, 16, 5, 1, 'Thriller', 1975),
(5, 17, 4, 1, 'Thriller', 1975),
(5, 18, 4, 1, 'Thriller', 1975),
(6, 19, 5, 1, 'Sci-Fi', 1982),
(6, 20, 5, 1, 'Sci-Fi', 1982),
(7, 16, 5, 1, 'Adventure', 1993),
(7, 17, 4, 1, 'Adventure', 1993),
(7, 18, 5, 1, 'Adventure', 1993),
(7, 19, 5, 1, 'Adventure', 1993),
(7, 20, 5, 1, 'Adventure', 1993);

-- Q4: reflection on what you learned and challenges.
-- This project has allowed us to gain a deeper understanding about database relationships 
-- through the process of using CREATE TABLE statements to create these tables and identifying
-- PRIMARY and FOREIGN keys. We also gained a better understanding on how to create ERDs and 
-- what the various relationship links mean. Another technical skill we learned and practiced 
-- more was SQL queries as P4 has allowed us to use critical thinking skills when it came to 
-- the demo queries as we had to analyze what data we had to use for INSERT INTO statements to
-- satisfy our query output. Some challeges we faced include schema constraints as our initial
-- ERD could have had more attributes that could help us link all the entities better as we had 
-- to really analyze what queries we could output with the tables we created. It was also 
-- challenging to make sure our own queries had the same format throughout for the assignment 
-- to look more cohesive. Overall, this project allowed us to apply the database and SQL
-- knowledge we've learned in this course.
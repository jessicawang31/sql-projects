-- 1.
SELECT title, author
FROM books
WHERE year_published = 2010
ORDER BY author, title;

-- 2. 
SELECT COUNT(*) AS num
FROM books
WHERE pages > 300 AND goodreads_rating >= 4;
-- num = 13467

-- 3a.
SELECT DISTINCT year_published, COUNT(*) AS count
FROM books
GROUP BY year_published
ORDER BY year_published;
-- 3b.
-- Based on the distribution, there seems to be an increase in books published
-- starting in the mid 20th century, and with a spike in 2007 and 2008. After 2008,
-- the number of books published per year started to slowly decrease.

-- 4.
SELECT b.title, b.goodreads_rating, COUNT(b.num_ratings) AS num_ratings_books, AVG(r.rating) AS average_rating, COUNT(r.rating) AS num_ratings_ratings
FROM books b
JOIN ratings r ON b.id = r.book_id
GROUP BY b.title, b.goodreads_rating;

-- 5.
SELECT COUNT(u.id) AS user_id, u.username, AVG(r.rating) AS mean_rating, AVG(r.rating - b.goodreads_rating) AS crankiness
FROM users u
JOIN ratings r ON r.user_id = u.id
JOIN books b ON b.id = r.book_id
GROUP BY user_id, u.username
ORDER BY crankiness DESC
LIMIT 10;

-- 6a.
SELECT b.author, COUNT(DISTINCT r.book_id) AS num_rated, ARRAY_AGG(DISTINCT b.title) AS rated_books
FROM users u
JOIN ratings r ON r.user_id = u.id
JOIN books b ON b.id = r.book_id
WHERE u.username = 'austenfan'
GROUP BY b.author
ORDER BY num_rated DESC;
-- 6b.
-- No, 'austenfan' is not a Jane Austen fan becasue they've only rated and read 1 book by Jane
-- and read and rated more books by P.G. Wodehouse.

-- Bonus.
SELECT u.username, COUNT(DISTINCT r.book_id) AS num_read
FROM users u
JOIN ratings r ON r.user_id = u.id
JOIN books b ON b.id = r.book_id
WHERE b.author = 'Jane Austen'
GROUP BY u.username
ORDER BY num_read DESC;
-- The biggest Jane Austen fans are users xtorres, yritter, stephanie29, and simpsonchristopher
-- who have all read and rated 7 books.
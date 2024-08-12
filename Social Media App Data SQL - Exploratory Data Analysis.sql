/*SOCIAL MEDIA APP EXPLORATORY DATA ANALYSIS USING SQL*/

/*SQL SKILLS: joins, date manipulation,group by,subquery,regular expression, aggregate functions*/
 
-- --------------------------------------------------------------------------------------------------------------
USE ig_clone;
 
/*Ques.1 The first 10 users on the platform*/

SELECT *
FROM users
ORDER BY created_at ASC
LIMIT 10;

-- --------------------------------------------------------------------------------------------------------------

/*Ques.2 Total number of registrations*/

SELECT COUNT(*) AS 'Registered Users'
FROM users;

-- --------------------------------------------------------------------------------------------------------------

/*Ques.3 The day of the week most users register on*/
SELECT DAYOFWEEK(created_at) AS 'Day of Week', COUNT(*) AS 'No of Users Registered'
FROM users
GROUP BY 1
ORDER BY 2 DESC;


-- --------------------------------------------------------------------------------------------------------------

/*Ques.4 The users who have never posted a photo*/

SELECT id,username
FROM users
WHERE id NOT IN (SELECT DISTINCT user_id
				FROM photos);
                
/*Version 2*/

SELECT u.id,u.username
FROM users u
LEFT JOIN photos p
ON u.id  = p.user_id
WHERE p.user_id IS NULL;


-- --------------------------------------------------------------------------------------------------------------

/*Ques.5 The most likes on a single photo*/
	
SELECT l.photo_id,u.username,p.image_url,COUNT(photo_id) AS noOfLikes
FROM likes l
JOIN photos p ON l.photo_id = p.id
JOIN users u ON u.id = p.user_id
GROUP BY l.photo_id 
ORDER BY COUNT(photo_id) DESC
LIMIT 1;


-- --------------------------------------------------------------------------------------------------------------

/*Ques.6 The number of photos posted by most active users*/

SELECT p.user_id,u.username,COUNT(p.user_id) AS noOfPosts
FROM photos p
JOIN users u
ON p.user_id = u.id
GROUP BY p.user_id
ORDER BY COUNT(p.user_id) DESC
LIMIT 5;

-- --------------------------------------------------------------------------------------------------------------

/*Ques.7 The total number of posts*/
SELECT COUNT(id) AS totalNoOfPosts
FROM photos;

-- --------------------------------------------------------------------------------------------------------------

/*Ques.8 The total number of users with posts*/

SELECT COUNT(DISTINCT(user_id)) AS usersWithPosts
FROM photos;

-- --------------------------------------------------------------------------------------------------------------

/*Ques.9 The usernames with numbers as ending*/

SELECT id,username
FROM users
WHERE username REGEXP '[$0-9]';
-- --------------------------------------------------------------------------------------------------------------

/*Ques.10 The usernames with charachter as ending*/

SELECT id,username
FROM users
WHERE username NOT REGEXP '[$0-9]';
-- --------------------------------------------------------------------------------------------------------------

/*Ques.11 The number of usernames that start with A*/

SELECT id,username
FROM users
WHERE lower(username) LIKE 'A%';

-- --------------------------------------------------------------------------------------------------------------

/*Ques.12 The most popular tag names by usage*/
SELECT pt.tag_id,t.tag_name,COUNT(*) AS noOfTimesUsed
FROM photo_tags pt
JOIN tags t 
ON pt.tag_id = t.id
GROUP BY pt.tag_id
ORDER BY 2 DESC
LIMIT 1;

-- --------------------------------------------------------------------------------------------------------------

/*Ques.13 The most popular tag names by likes*/

SELECT t.tag_name,COUNT(*)AS noOfLikes
FROM photo_tags pt
JOIN likes l ON pt.photo_id = l.photo_id
JOIN tags t ON t.id = pt.tag_id
GROUP BY pt.tag_id
ORDER BY 2 DESC
LIMIT 5;

-- --------------------------------------------------------------------------------------------------------------

/*Ques.14 The users who have liked every single photo on the site*/
SELECT u.id,username,COUNT(photo_id) AS No_of_likes
FROM users u
JOIN likes l
ON u.id = l.user_id
GROUP BY u.id
HAVING No_of_likes IN (SELECT COUNT(*) FROM photos);


-- --------------------------------------------------------------------------------------------------------------

/*Ques.15 Total number of users without comments*/

SELECT COUNT(*) NoOfUsersWithoutComment
FROM users
WHERE id NOT IN (
		SELECT DISTINCT user_id
		FROM comments);


-- --------------------------------------------------------------------------------------------------------------


/*Ques.16 The average time on the platform */

SELECT ROUND(AVG(datediff(NOW(),created_at)),2)
FROM users;

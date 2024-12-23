-- Most Used hashtag
SELECT hashtag_name, COUNT(h.hashtag_id) as frequency from hashtags h
JOIN post_tags p
ON h.hashtag_id=p.hashtag_id
GROUP BY hashtag_name
ORDER BY frequency DESC;

-- User With Most Follower
SELECT user_name,followee_id,COUNT(follower_id) AS number_of_followers FROM follows f
JOIN users u  ON f.followee_id = u.user_id
GROUP BY followee_id;

-- Post with highest engagement
SELECT pl.post_id,p.caption,COUNT(DISTINCT(pl.user_id)) AS number_of_likes,
COUNT(DISTINCT(c.comment_id)) AS number_of_comments,
COUNT(DISTINCT(pl.user_id))+COUNT(DISTINCT(c.comment_id)) AS total_engagement
FROM posts p
JOIN post_likes pl ON p.post_id=pl.post_id
JOIN comments c ON p.post_id=c.post_id
GROUP BY p.caption,pl.post_id
ORDER BY total_engagement DESC;

-- Most active users in terms of posting
SELECT u.user_name, COUNT(post_id) AS number_of_posts FROM posts p
JOIN users u
ON u.user_id = p.user_id
GROUP BY u.user_name 
ORDER BY number_of_posts DESC;

-- Most bookmarked posts
SELECT post_id,COUNT(user_id) AS times_bookmarked FROM bookmarks
GROUP BY post_id ORDER BY times_bookmarked DESC;   

-- Users with the highest comment engagement
SELECT u.user_name,cl.user_id, COUNT(cl.comment_id) AS number_of_comments 
FROM comment_likes cl
JOIN users u ON cl.user_id=u.user_id
GROUP BY u.user_name,cl.user_id 
ORDER BY number_of_comments DESC LIMIT 10;

-- Hashtag follow trends
SELECT h.hashtag_name,hf.hashtag_id, COUNT(hf.user_id) as frequency 
FROM hashtag_follow hf
JOIN hashtags h ON hf.hashtag_id = h.hashtag_id
GROUP BY h.hashtag_name,hf.hashtag_id 
ORDER BY frequency DESC;

-- Users with the highest ratio of received likes to posts
SELECT user_name,u.user_id,COUNT(DISTINCT(p.post_id)) as number_of_posts,
COUNT(pl.user_id) AS number_of_likes,
CAST(COUNT(pl.user_id) AS FLOAT) / COUNT(DISTINCT p.post_id) AS likes_per_post
FROM users u
JOIN posts p ON u.user_id=p.user_id
JOIN post_likes pl ON p.post_id=pl.post_id
GROUP BY u.user_id,user_name
ORDER BY likes_per_post DESC;

-- Most active locations
SELECT location, 
COUNT(post_id) as frequency FROM posts
GROUP BY location ORDER BY frequency DESC 
LIMIT 10;

-- Users with the most diverse hashtag usage
WITH hashtag_count_by_user AS(
SELECT u.user_name,hf.user_id, 
COUNT(hf.hashtag_id) AS frequency,
RANK() OVER(ORDER BY COUNT(hf.hashtag_id) DESC) AS user_rank
FROM hashtag_follow hf
JOIN users u ON hf.user_id=u.user_id
GROUP BY u.user_name,hf.user_id ORDER BY frequency DESC)
SELECT * FROM hashtag_count_by_user WHERE user_rank=1;

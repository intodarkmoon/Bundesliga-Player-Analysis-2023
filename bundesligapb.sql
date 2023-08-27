SELECT *
FROM PUBLIC.BUNDESLIGAPLAYER B ;

/*
 * Doing some data cleaning and transformation
 * */

-- Update height column to an integer
UPDATE PUBLIC.BUNDESLIGAPD  
SET PLAYER_HEIGHT = ROUND(PLAYER_HEIGHT * 100); 

-- Change the value price to million 
UPDATE PUBLIC.BUNDESLIGAPD  
SET PRICE = ROUND(PRICE * 1000000); 

-- Change the value max_price to million
UPDATE PUBLIC.BUNDESLIGAPD  
SET MAX_PRICE  = ROUND(MAX_PRICE  * 1000000); 

-- Change contract expire and joined club column data type from varchar to a date 
ALTER TABLE PUBLIC.BUNDESLIGAPD 
ADD column expire_contract_date date, 
ADD column joined_club_date date;

UPDATE PUBLIC.BUNDESLIGAPD 
SET expire_contract_date = TO_DATE(CONTRACT_EXPIRES, 'YYYY-MM-DD'),
joined_club_date = TO_DATE(JOINED_CLUB, 'YYYY-MM-DD');

ALTER TABLE PUBLIC.BUNDESLIGAPD 
DROP column contract_expires,
DROP column joined_club;

--ALTER TABLE PUBLIC.BUNDESLIGAPD 
--RENAME column 

/*
 * Insight
 * */

-- Average age of players
SELECT AVG(B.AGE) AS average_age 
FROM PUBLIC.BUNDESLIGAPD B ;

-- Average age of players by nationality
SELECT b.NATIONALITY , AVG(b.AGE) AS average_age 
FROM PUBLIC.BUNDESLIGAPD B
GROUP BY b.NATIONALITY 
ORDER BY average_age DESC ;

-- Tallest Players
SELECT b."name" , b.FULL_NAME , b.PLAYER_HEIGHT 
FROM PUBLIC.BUNDESLIGAPD B 
ORDER BY b.PLAYER_HEIGHT DESC 
FETCH FIRST 10 ROW ONLY ;
--LIMIT 10

-- Most Common Nationality
SELECT b.NATIONALITY , COUNT(*) AS num_player 
FROM PUBLIC.BUNDESLIGAPD B 
GROUP BY b.NATIONALITY 
ORDER BY num_player DESC 
LIMIT 10;

-- Average Current Price
SELECT AVG(b.PRICE) AS average_currentprice 
FROM PUBLIC.BUNDESLIGAPD B ;

-- Top Players by Current Price
SELECT b."name" , b.PRICE 
FROM PUBLIC.BUNDESLIGAPD B
WHERE b.PRICE IS NOT NULL 
ORDER BY b.PRICE DESC 
LIMIT 10;

-- Player Position Distribution
SELECT b."position" , COUNT(*) AS num_player  
FROM PUBLIC.BUNDESLIGAPD B 
GROUP BY b."position"  
ORDER BY num_player DESC ;

-- Players with Highest Price Increase
SELECT b."name" , b.MAX_PRICE - b.PRICE AS increase_price
FROM PUBLIC.BUNDESLIGAPD B 
WHERE b.MAX_PRICE > b.PRICE 
ORDER BY increase_price DESC 
LIMIT 10;

-- Player Distribution by Foot
SELECT b.FOOT , COUNT(*) AS num_player  
FROM PUBLIC.BUNDESLIGAPD B 
WHERE b.FOOT != ''
GROUP BY b.FOOT 
ORDER BY num_player DESC ;

-- Top Clubs by Number of Players
SELECT b.CLUB , COUNT(*) AS num_player  
FROM  PUBLIC.BUNDESLIGAPD B 
GROUP BY b.CLUB 
ORDER BY num_player DESC ;

-- Players with Expired Contracts
SELECT b."name" , b.EXPIRE_CONTRACT_DATE  
FROM PUBLIC.BUNDESLIGAPD B 
WHERE b.EXPIRE_CONTRACT_DATE < CURRENT_DATE ;

-- Top Players whose Contracts are Still long overdue by Day
SELECT b."name" , b.EXPIRE_CONTRACT_DATE - b.JOINED_CLUB_DATE AS days
FROM PUBLIC.BUNDESLIGAPD B
ORDER BY days DESC 
LIMIT 10;
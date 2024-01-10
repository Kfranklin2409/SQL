-- Create table for users data

CREATE table users 
    (id INTEGER PRIMARY KEY, username TEXT, password INTEGER);

-- Inserting data in the table
INSERT INTO users 
    ("id", "username", "password") VALUES (1, "albert",     "11");

INSERT INTO users 
    ("id", "username", "password") VALUES (2, "Bert", 12);

INSERT INTO users 
    ("id", "username", "password") VALUES (3, "Cris", 13);

INSERT INTO users 
    ("id", "username", "password") VALUES (4, "Dilbert", 14);

INSERT INTO users 
    ("id", "username", "password") VALUES (5, "Egglet", 15);

-- Create a table for user scores and their games
CREATE table user_scores 
    (id INTEGER PRIMARY KEY, user_id INTEGER, date TEXT, score INTEGER, game TEXT); 

-- Insert data in the table that includes dates
INSERT INTO user_scores 
    ("id", "user_id", "date", "score", "game") VALUES (1, 1, 2019-07-13, 2500, "Chain Gang");

INSERT INTO user_scores 
    ("id", "user_id", "date", "score", "game") VALUES (2, 2, 2019-07-15, 50000, "DashNDo");

INSERT INTO user_scores 
    ("id", "user_id", "date", "score", "game") VALUES (3, 3, 2020-11-23, 275000, "POF"); 

INSERT INTO user_scores 
    ("id", "user_id", "date", "score", "game") VALUES (4, 4, 2021-03-24, 37500, "Step Up");
    
INSERT INTO user_scores 
    ("id", "user_id", "date", "score", "game") VALUES (5, 5, 2022-10-16, 36780, "BDExtravaganza");

-- Create table for games
CREATE table Games 
    (id INTEGER PRIMARY KEY, Game_id INTEGER, Game_Name TEXT); 
    
-- Insert data into games    
INSERT INTO Games
    ("id", "Game_id", "Game_Name") VALUES (1, 1, "Chain Gang");
    
INSERT INTO Games
    ("id", "Game_id", "Game_Name") VALUES (2, 2, "DashNDo");
    
INSERT INTO Games
    ("id", "Game_id", "Game_Name") VALUES (3, 3, "POF");
    
INSERT INTO Games
    ("id", "Game_id", "Game_Name") VALUES (4, 4, "Step Up");
    
INSERT INTO Games
    ("id", "Game_id", "Game_Name") VALUES (5, 5, "BDExtravaganza");
    
INSERT INTO Games
    ("id", "Game_id", "Game_Name") VALUES (6, 6, "Checkers");
    
-- Update the score of a user
UPDATE user_scores SET score = "5000000" WHERE id = 3;

SELECT *
FROM
    user_scores;

-- Delete a game from the games table
DELETE FROM Games Where Game_id = 6;

-- Selecting the updated table 
SELECT * FROM Games;

-- Create a T-Shirt Store Database

CREATE TABLE Pailee_Rose (
    id INTEGER PRIMARY KEY,
    shirt_name TEXT,
    color TEXT,
    price INTEGER,
    quantity INTEGER
); 

Insert INTO Pailee_Rose VALUES (1, "Paily", "White", 17, 10); 
Insert INTO Pailee_Rose VALUES (2, "Paily", "Black", 16.25, 25);
INSERT INTO Pailee_Rose VALUES (3, "Paily", "RED", 16.50, 6);
INSERT INTO Pailee_Rose VALUES (4, "Livey", "White", 16.5, 9);
INSERT INTO Pailee_Rose VALUES (5, "Livey", "Black", 17.25, 29);
INSERT INTO Pailee_Rose VALUES (6, "Livey", "Blue", 18.99, 13); 
INSERT INTO Pailee_Rose VALUES (7, "Olivie", "White", 17.75, 11);
INSERT INTO Pailee_Rose VALUES (8, "Olivie", "Black", 18.75, 15);
INSERT INTO Pailee_Rose VALUES (9, "Olivie", "Green", 17.99, 5);
INSERT INTO Pailee_Rose VALUES (10, "Chelsi", "Yellow", 18.99, 18);
INSERT INTO Pailee_Rose VALUES (11, "Chelsi", "Purple", 23.99, 14);
INSERT INTO Pailee_Rose VALUES (12, "Chelsi", "Gray", 29.99, 33);
INSERT INTO Pailee_Rose VALUES (13, "Trellie", "Black", 18.50, 19);
INSERT INTO Pailee_Rose VALUES (14, "Trellie", "Gold", 24.08, 50);
INSERT INTO Pailee_Rose VALUES (15, "Trellie", "Purple", 24.58, 32);

-- Select all the data from the database and order by price
SELECT * 
FROM Pailee_Rose ORDER BY price;

-- Add all the quantities from the database
SELECT SUM(quantity) 
FROM Pailee_Rose; 

-- Select the product of the quantities and their prices
SELECT SUM(Price*quantity) 
FROM Pailee_Rose;
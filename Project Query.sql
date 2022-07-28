CREATE TABLE IF NOT EXISTS team (
team_id INT auto_increment PRIMARY KEY,
team_name varchar(255)
);

CREATE TABLE IF NOT EXISTS season (
season_id INT auto_increment PRIMARY KEY,
season_name varchar(255)
);


CREATE TABLE IF NOT EXISTS positions (
position_id INT auto_increment PRIMARY KEY,
position_name CHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS playtype (
play_type_id INT auto_increment PRIMARY KEY,
play_type_name CHAR(50) NOT NULL
);


CREATE TABLE IF NOT EXISTS game (
game_id INT auto_increment PRIMARY KEY,
home_team_id INT NOT NULL,
away_team_id INT NOT NULL,
season_id INT,
game_date DATE,
CONSTRAINT FK_game1 FOREIGN KEY (home_team_id) REFERENCES  team(team_id),
CONSTRAINT FK_game2 FOREIGN KEY (away_team_id) REFERENCES  team(team_id),
CONSTRAINT FK_game3 FOREIGN KEY (season_id) REFERENCES  season(season_id)
);


CREATE TABLE IF NOT EXISTS player (
player_id INT auto_increment PRIMARY KEY,
firstname CHAR(50) NOT NULL,
lastname CHAR(50) NOT NULL,
team_id INT,
position_id INT,
CONSTRAINT FK_player1 FOREIGN KEY (team_id) REFERENCES  team(team_id),
CONSTRAINT FK_player2 FOREIGN KEY (position_id) REFERENCES positions(position_id)
);

CREATE TABLE IF NOT EXISTS plays (
play_id INT auto_increment PRIMARY KEY,
play_type_id INT NOT NULL,
game_id INT NOT NULL,
yards_gained INT,
down INT,
qtr INT,
TimeSecs INT,
ydstogo INT,
posteam_id INT,
CONSTRAINT FK_play1 FOREIGN KEY (play_type_id) REFERENCES  playtype(play_type_id),
CONSTRAINT FK_play2 FOREIGN KEY (game_id) REFERENCES  game(game_id),
CONSTRAINT FK_play3 FOREIGN KEY (posteam_id) REFERENCES  team(team_id)
);

INSERT INTO 
	team (team_name)
    VALUES ('ARI'), ('ATL'), ('BAL'), ('BUF'), ('CAR'), ('CHI'), ('CIN'), ('CLE'),
    ('DAL'), ('DEN'), ('DET'), ('GB'),('HOU'),('IND'),('JAC'),('JAX'),('KC'),('LA'),
    ('MIA'),('MIN'),('NE'),('NO'),('NYG'),('NYJ'),('OAK'),('PHI'),
    ('PIT'),('SD'),('SEA'),('SF'),('STL'),('TB'),('TEN'),('WAS');

INSERT INTO 
	season (season_name)
    VALUES ('2009'), ('2010'), ('2011'), ('2012'), ('2013'),('2014'), ('2015')
    , ('2016');
    
INSERT INTO 
	positions (position_name)
    VALUES ('C'), ('LG'), ('RG'), ('LT'), ('RT'), ('QB'), ('HB'), ('FB'),
    ('TE'), ('WR'), ('DT'), ('DE'),('MLB'),('ROLB'),('LOLB'),('CB'),('FS'),('SS'),
    ('K'),('P'),('KR'),('PR'),('LS'),('KOS'),('H');
    
INSERT INTO 
	playtype (play_type_name)
    VALUES ('Kickoff'), ('Pass'), ('Run'), ('Punt'), ('Sack'), ('Field Goal'), ('No Play')
    , ('Quarter End'), ('Two Minute Warning'), ('Timeout'), ('Extra Point'),
    ('QB Kneel'),('End of Game'),('Spike'),('Half End');

    
LOAD DATA LOCAL INFILE 'C:/Users/nmper/OneDrive/Documents/DSCI-D532/game.csv'
INTO TABLE game 
FIELDS TERMINATED BY ',' ;

LOAD DATA LOCAL INFILE 'C:/Users/nmper/OneDrive/Documents/DSCI-D532/plays.csv'
INTO TABLE plays
FIELDS TERMINATED BY ',' ;

#Count of games to make sure it matches the csv file
SELECT COUNT(game_id)
FROM game;

#Most yards gained on a play
SELECT MAX(yards_gained)
FROM plays;

#Most yards gained in the 4th quarter
SELECT MAX(yards_gained)
FROM plays
WHERE TimeSecs <= 900;

#Most Yards Lost on any play
SELECT MIN(yards_gained)
FROM plays;

#Most yards to gain for a first down
SELECT MAX(ydstogo)
FROM plays;

#Count of each downs for all seasons
SELECT down, count(down)
FROM plays
GROUP BY down;

#Team that had the longest yards to gain
SELECT team.team_name, plays.ydstogo
FROM plays
INNER JOIN team ON team.team_id=plays.posteam_id
WHERE ydstogo = (
	SELECT
		MAX(ydstogo)
        FROM plays)
;









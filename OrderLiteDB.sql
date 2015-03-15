DROP DATABASE IF EXISTS OrderLite;
CREATE DATABASE OrderLite;
USE OrderLite;

# Dump of table Recipe
# ------------------------------------------------------------

DROP TABLE IF EXISTS Recipe;

CREATE TABLE Recipe (
  recipeID int(11) unsigned NOT NULL AUTO_INCREMENT,
  recipeName varchar(100) DEFAULT NULL,
  rating float DEFAULT NULL,
  Ingredient varchar(50000) DEFAULT NULL,
  picture varchar(10000) DEFAULT NULL,
  timesClicked int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (recipeID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES Recipe WRITE;
/*!40000 ALTER TABLE Recipe DISABLE KEYS */;

INSERT INTO Recipe (recipeID, recipeName, rating, Ingredient, picture, timesClicked)
VALUE
	(1, "classic burger", 5, "original bun, beef patty, lettuce, tomato, onion, pickle, ketchup", "" , 0),
	(2, "veggie burger", 4.5, "lettuce bun, bean patty, tomato, onion, pickle, honey mustard", "", 2);

/*!40000 ALTER TABLE Recipe ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table filter
# ------------------------------------------------------------

DROP TABLE IF EXISTS Filter;

CREATE TABLE Filter (
  recipeID int(11) unsigned NOT NULL,
  glutenFree tinyint(1) DEFAULT NULL,
  vegetarian tinyint(1) DEFAULT NULL,
  vegan tinyint(1) DEFAULT NULL,
  noNuts tinyint(1) DEFAULT NULL,
  lactoseFree tinyint(1) DEFAULT NULL,
  calories int(11) DEFAULT NULL,
  PRIMARY KEY (recipeID),
  CONSTRAINT RecipeID_FK FOREIGN KEY (recipeID) REFERENCES Recipe (recipeID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES Filter WRITE;
/*!40000 ALTER TABLE Filter DISABLE KEYS */;


INSERT INTO Filter (recipeID, glutenFree, vegetarian, vegan, noNuts, lactoseFree, calories)
VALUES
	(1,0,0,0,1,1,400),
	(2,1,1,1,1,1,350);


/*!40000 ALTER TABLE Filter ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table ingredient
# ------------------------------------------------------------

DROP TABLE IF EXISTS Ingredient;

CREATE TABLE Ingredient (
  foodName varchar(50) DEFAULT NULL,
  timesAdded int(11) NOT NULL DEFAULT 0,
  categoryID int(11) NOT NULL DEFAULT 0,
  KEY foodName (foodName)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES Ingredient WRITE;
/*!40000 ALTER TABLE Ingredient DISABLE KEYS */;

INSERT INTO Ingredient (foodName, timesAdded, categoryID)
VALUES
	("wheat bun", 0, 1),
	("original bun", 0, 1),
	("lettuce bun", 0, 1),
	("beef patty", 0, 2),
	("turkey patty", 0, 2),
	("bean patty", 0, 2),
	("lettuce", 0, 3),
	("tomato", 0, 3),
	("onion", 0, 3),
	("pickle", 0, 3),
	("ketchup", 0, 4),
	("mustard", 0, 4),
	("barbecue", 0, 4),
	("honey mustard", 0, 4);	


/*!40000 ALTER TABLE Ingredient ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table Category
# ------------------------------------------------------------

DROP TABLE IF EXISTS Category;

CREATE TABLE Category (
	categoryID int(11) unsigned NOT NULL,
	categoryName varchar(50) DEFAULT NULL,
	KEY categoryID (categoryID)
)	ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES Category WRITE;
/*!40000 ALTER TABLE Category DISABLE KEYS */;

INSERT INTO Category (categoryID, categoryName)
VALUES
	(1, "buns"),
	(2, "patties"),
	(3, "toppings"),
	(4, "condiments");

/*!40000 ALTER TABLE Category ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table results
# ------------------------------------------------------------

DROP TABLE IF EXISTS Results;

CREATE TABLE Results (
  recipeID int(11) unsigned NOT NULL AUTO_INCREMENT,
  rankingPoints double DEFAULT NULL,
  PRIMARY KEY (recipeID),
  CONSTRAINT recipeIDFKCon FOREIGN KEY (recipeID) REFERENCES Recipe (recipeID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES Results WRITE;
/*!40000 ALTER TABLE Results DISABLE KEYS */;


INSERT INTO Results (recipeID, rankingPoints)
VALUES
	(1,0.3125),
	(2,0.30303030303030304);

/*!40000 ALTER TABLE Results ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Users
# ------------------------------------------------------------

DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  username varchar(30) DEFAULT NULL,
  pw varchar(100) DEFAULT NULL,
  firstname varchar(30) DEFAULT NULL,
  timeForEmail timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  notSentEmail tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (id),
  KEY Username (username)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

LOCK TABLES Users WRITE;
/*!40000 ALTER TABLE Users DISABLE KEYS */;

INSERT INTO Users (id, username, pw, firstname, timeForEmail, notSentEmail)
VALUES
	(11,'user@me.com','MTIzNDU=','user','2014-12-08 20:11:57',1),
	(12,'test@me.com','cGFzc3dvcmQ=','test','2014-12-08 20:11:58',1);

/*!40000 ALTER TABLE users ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table SearchHistory
# ------------------------------------------------------------

DROP TABLE IF EXISTS SearchHistory;

CREATE TABLE SearchHistory (
  id int(11) unsigned NOT NULL,
  username varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (id, username),
  KEY usernmFK (username),
  CONSTRAINT recipeIDFK FOREIGN KEY (id) REFERENCES Recipe (recipeID) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT usernmFK FOREIGN KEY (username) REFERENCES Users (username) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES SearchHistory WRITE;
/*!40000 ALTER TABLE SearchHistory DISABLE KEYS */;

INSERT INTO SearchHistory (id, username)
VALUES
    (1,'user@me.com');

/*!40000 ALTER TABLE SearchHistory ENABLE KEYS */;
UNLOCK TABLES;


#create logged in user 
drop user 'loggedIn'@'localhost';
FLUSH PRIVILEGES;

CREATE USER 'loggedIn'@'localhost' IDENTIFIED BY '123';

grant select, insert, delete, update, drop on OrderLite.Results to 'loggedIn'@'localhost';
grant select, insert, delete on OrderLite.SearchHistory to 'loggedIn'@'localhost';
grant select (foodName, timesAdded), update (timesAdded) on OrderLite.Ingredient to 'loggedIn'@'localhost';
grant select on OrderLite.Filter to 'loggedIn'@'localhost';
grant update, select, insert on OrderLite.Recipe to 'loggedIn'@'localhost';


#Create unlogged in user
drop user 'unLoggedIn'@'localhost';
FLUSH PRIVILEGES;
CREATE USER 'unLoggedIn'@'localhost' IDENTIFIED BY '123';

grant select, insert, delete, update, drop on OrderLite.Results to 'unLoggedIn'@'localhost';
grant select on OrderLite.SearchHistory to 'unLoggedIn'@'localhost';
grant select (foodName, timesAdded), update (timesAdded) on OrderLite.Ingredient to 'unLoggedIn'@'localhost';
grant select on OrderLite.Filter to 'unLoggedIn'@'localhost';
grant update, select, insert on OrderLite.Recipe to 'unLoggedIn'@'localhost';


FLUSH PRIVILEGES;
/*EN CREATE USER SYNTAX*/
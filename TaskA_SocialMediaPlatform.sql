-- Create the database --
CREATE DATABASE SocialMediaPlatform;
GO

-- Use the database --
USE SocialMediaPlatform;
GO

-- User table --
CREATE TABLE Users (
   UserID INT IDENTITY(1,1) PRIMARY KEY,   
   UserName NVARCHAR(50) NOT NULL,         
   DOB DATE NOT NULL,                      
   Email VARCHAR(100) NOT NULL UNIQUE,    
   Gender VARCHAR(6) NOT NULL CHECK (Gender IN ('Male', 'Female')), -- Restricted values
   JoinDate DATETIME DEFAULT GETUTCDATE() NOT NULL 
);
GO

-- Insert 2 Users --
INSERT INTO Users (UserName, DOB, Email, Gender) VALUES
('Diana White', '2000-01-10', 'diana@mail.com', 'Female'),
('Ethan Brown', '1993-07-25', 'ethan@mail.com', 'Male');
GO

-- Post table --
CREATE TABLE Posts (
   PostID INT IDENTITY(1,1) PRIMARY KEY,      
   Content NVARCHAR(500) NOT NULL,            
   PostDate DATETIME DEFAULT GETUTCDATE() NOT NULL, 
   Visibility VARCHAR(10) NOT NULL CHECK (Visibility IN ('Public', 'Private', 'Friends')), 
   UserID INT NOT NULL,                       -- Foreign key to Users
   FOREIGN KEY (UserID) REFERENCES Users(UserID) 
);
GO

-- Insert 2 Posts --
INSERT INTO Posts (Content, Visibility, UserID) VALUES
('Enjoying the sunshine today!', 'Public', 1),
('Just finished a great book!', 'Friends', 2);
GO

-- Comment table --
CREATE TABLE Comments (
   CommentID INT IDENTITY(1,1) PRIMARY KEY,    
   Content NVARCHAR(100) NOT NULL,            
   CommentDate DATETIME DEFAULT GETUTCDATE() NOT NULL, 
   UserID INT NOT NULL,                        -- Foreign key to Users
   PostID INT NOT NULL,                        -- Foreign key to Posts
   FOREIGN KEY (UserID) REFERENCES Users(UserID),
   FOREIGN KEY (PostID) REFERENCES Posts(PostID) 
);
GO

-- Insert 2 Comments --
INSERT INTO Comments (Content, UserID, PostID) VALUES
('Looks like fun!', 2, 1),
('I love reading too!', 1, 2);
GO

-- Interaction table  --
CREATE TABLE Interactions (
   InteractionID INT IDENTITY(1,1) PRIMARY KEY,  
   Type VARCHAR(10)  NOT NULL CHECK(Type IN ('Like', 'Share', 'Comment')) , 
   InteractionDate DATETIME DEFAULT GETUTCDATE() NOT NULL 
);
GO

-- Insert 2 Interactions --
INSERT INTO Interactions (Type) VALUES
('Like'),
('Comment');
GO

CREATE TABLE UserInteraction (
   InteractionID INT NOT NULL,  -- Foreign key to Interactions
   UserID INT NOT NULL,         -- Foreign key to Users
   PostID INT NOT NULL,         -- Foreign key to Posts
   PRIMARY KEY (InteractionID, UserID, PostID), -- Composite primary key
   FOREIGN KEY (InteractionID) REFERENCES Interactions(InteractionID) ,
   FOREIGN KEY (UserID) REFERENCES Users(UserID) ,
   FOREIGN KEY (PostID) REFERENCES Posts(PostID) 
);
GO

-- Insert 2 User Interactions --
INSERT INTO UserInteraction (InteractionID, UserID, PostID) VALUES
(1, 1, 2),
(2, 2, 1);
GO

/*------------------------------------------------------------ DDL Operations ----------------------------------------------------------*/

-- 1) Drop the 'Users' table from the SocialMediaPlatform database
USE [SocialMediaPlatform];
DROP TABLE Users;

-- 2) Drop the entire 'SocialMediaPlatform' database
DROP DATABASE [SocialMediaPlatform];

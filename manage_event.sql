CREATE TABLE Organizer(
Organizer_ID INT PRIMARY KEY,
UserName TEXT NOT NULL,
Password TEXT NOT NULL
);

CREATE TABLE Scheduled_Events(
event_ID INT PRIMARY KEY,
Category TEXT NOT NULL,
Name TEXT NOT NULL,
Address TEXT NOT NULL,
Country TEXT NOT NULL,
City TEXT NOT NULL,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
Price INT NOT NULL,
Quota INT NOT NULL,
Description TEXT NULL,
Organizer_Name TEXT NOT NULL,
Organizer_ID INT,
FOREIGN KEY (Organizer_ID) REFERENCES Organizer (Organizer_ID)
);

CREATE TABLE Members(
MembersID INT NOT NULL,
Name TEXT NOT NULL,
SurName TEXT NOT NULL,
UserName TEXT NOT NULL,
Mem_Password TEXT NOT NULL,
BirthDate DATE NOT NULL,
Email TEXT NOT NULL,
EventID INT NULL,
FOREIGN KEY(EventID) REFERENCES Scheduled_Events(event_ID),
Type TEXT NOT NULL
);

INSERT INTO Organizer(Organizer_ID,UserName,Password) VALUES
(1,'Nestle','pass1'),
(2,'Roshen','pass2'),
(3,'Procter','pass3'),
(4,'Gazprom','pass4'),
(5,'Ubisoft','pass5'),
(6,'Twitch','pass6'),
(7,'Google','pass7'),
(8,'OpenAI','pass8'),
(9,'Delta','pass9'),
(10,'Pfizer','pass10');

INSERT INTO Scheduled_Events(event_ID,Category,Name,Address,Country,City,StartDate,EndDate,Price,Quota,Description,Organizer_Name,Organizer_ID) VALUES
(1,'Health','First_Event','NTU KhPI','Ukraine','Kharkiv','2019-05-19','2019-05-19',100,5,NULL,'Nestle',1),
(2,'Academic','Second_Event','NTU KhPI','Ukraine','Kharkiv','2019-05-20','2019-05-25',300,10,NULL,'Google',2),
(3,'Food','Third_Event','Gorky Park','Ukraine','Kharkiv','2019-06-11','2019-06-21',500,15,NULL,'Roshen',3),
(4,'Music','Fourth_Event','Metallist Stadium','Ukraine','Kharkiv','2017-05-19','2017-05-25',250,8,NULL,'Twitch',4),
(5,'Health','Fifth_Event','Freedom Square','Ukraine','Kyiv','2018-05-19','2018-05-28',600,50,NULL,'Pfizer',5),
(6,'Math','Sixth_Event','City Centre','Poland','Warsaw','2020-01-12','2020-01-19',350,30,NULL,'OpenAI',6),
(7,'Theater','Seventh_Event','The Hague','Netherlands','Hague','2019-08-10','2019-09-10',950,40,NULL,'Twitch',7),
(8,'Geography','Eighth_Event','Istanbul University','Turkey','Istanbul','2019-05-19','2019-05-30',400,64,NULL,'Delta',8),
(9,'Internship','Ninth_Event','Silicon Valley','USA','Los Angeles','2006-05-19','2006-06-30',1500,50,NULL,'Ubisoft',9),
(10,'Summer Camp','Tenth_Event','Menlo Park','USA','Los Angeles','2019-05-19','2019-05-29',450,42,NULL,'Google',10);

INSERT INTO Members(MembersID,Name,SurName,MembersUserName,MembersPassword,BirthDate,Email,EventID,Type)VALUES
(1,'Andrew','Eyo','FirstMember','mem1','2000-01-20','andrew@gmail.com',2,'Standard'),
(2,'Irele','Omike','SecondMember','mem2','1980-01-20','irele@gmail.com',2,'Standard'),
(3,'Oussama','Berkan','ThirdMember','mem3','2004-01-20','oussama@gmail.com',3,'Standard'),
(3,'Cenk','Firtina','ThirdMember','mem31','2004-01-20','cenk@gmail.com',4,'Standard'),
(3,'Dmitriy','Tiutiunyk','ThirdMember','mem32','2004-01-20','dmitry@gmail.com',5,'Standard'),
(3,'Jeff','Bezos','ThirdMember','mem33','2004-01-20','jeff@gmail.com',6,'Standard'),
(4,'Hasan','Piker','FourthMember','mem4','1985-01-20','hasan@gmail.com',6,'Standard'),
(5,'Nick','Polom','FifthMember','mem5','1997-01-20','nick@gmail.com',NULL,'Standard'),
(6,'Andrea','Botez','SixthMember','mem6','1977-01-20','andrea@gmail.com',7,'Standard'),
(7,'Bill','Gates','SeventhMember','mem7','1994-01-20','bill@gmail.com',8,'Standard'),
(8,'Elon','Musk','EighthMember','mem8','2000-01-20','elon@gmail.com',9,'Standard'),
(9,'Eren','Yaeger','NinthMember','mem9','2005-01-20','eren@gmail.com',10,'Standard'),
(10,'Uzui','Tengen','TenthMember','mem10','2008-01-20','uzui@gmail.com',NULL,'Standard'),
(11,'Levi','Ackerman','EleventhMember','mem11','1999-01-20','levi@gmail.com',10,'Standard');

/*1) the events which will be hosted in Kharkiv */
SELECT *FROM Scheduled_Events WHERE City = 'Kharkiv';

/*2) Find the event which was held 
with the highest attendance
and the total obtained revenue. */
SELECT DISTINCT Scheduled_Events.Name,Scheduled_Events.Category,
Scheduled_Events.Organizer_Name,Scheduled_Events.Price
FROM Scheduled_Events,Members WHERE Members.EventID
IN(SELECT COUNT(EventID) AS SAYI FROM Members
 GROUP BY EventID) AND
 Scheduled_Events.event_ID=Members.EventID;

/*3) Find the total number of events for each category in a descending order. */
SELECT Category,COUNT(*) AS SAYI FROM Scheduled_Events
GROUP BY Category ORDER BY SAYI DESC;

/*4) Find the past events in which 
the members (whose age is between 18-25) 
participated. */
SELECT Scheduled_Events.Name,Members.Name,Members.SurName
FROM Scheduled_Events,Members WHERE 
Scheduled_Events.event_ID=Members.EventID AND
Scheduled_Events.EndDate<'2019-05-26' AND 
('now'-Members.BirthDate)/365 BETWEEN 18 AND 25; 

/*5) Find the past events in which the total number of participated members is less than
(not equal) 3. */
SELECT *FROM Scheduled_Events,Members WHERE 
Members.EventID IN(SELECT EventID FROM Members
GROUP BY EventID HAVING COUNT(*)<3) AND
EndDate<'2019-05-26' AND 
Scheduled_Events.event_ID=Members.EventID;

/*6) List the members who attended at least 
3 events and update these members’
membership type to gold. */
SELECT *FROM Members WHERE MembersID IN
(SELECT MembersID FROM Members GROUP BY MembersID
 HAVING COUNT(*)>2);
 UPDATE Members SET Type='gold' WHERE MembersID IN
(SELECT MembersID FROM Members GROUP BY MembersID
 HAVING COUNT(*)>2);
SELECT *FROM Members WHERE MembersID IN
(SELECT MembersID FROM Members GROUP BY MembersID
 HAVING COUNT(*)>2);

/*7) Return the member’s email 
address who paid at most. */
SELECT Email FROM Members,Scheduled_Events WHERE  
Price IN(SELECT MAX(Scheduled_Events.Price) 
FROM Scheduled_Events)
AND Members.EventID=Scheduled_Events.event_ID;

/*8)Update the discount rate of events which will be
organized at cities whose name starts with"i" as 25*/
SELECT *FROM Scheduled_Events;
UPDATE Scheduled_Events SET Description='discount %25',
Price = Price - Price/4 WHERE City LIKE 'k%';
SELECT *FROM Scheduled_Events;


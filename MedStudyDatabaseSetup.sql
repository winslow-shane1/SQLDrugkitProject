-- ---------------------
-- Name: Shane Winslow
-- Class: IT-112
-- Abstract: Final Project
-- ---------------------

-- ---------------------
-- Options
-- ---------------------
USE dbSQL1; -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- ---------------------
-- Drop Tables
-- ---------------------
IF OBJECT_ID('TDrugKits')			IS NOT NULL DROP TABLE	TDrugKits
IF OBJECT_ID('TVisits')				IS NOT NULL DROP TABLE	TVisits
IF OBJECT_ID('TPatients')			IS NOT NULL DROP TABLE	TPatients
IF OBJECT_ID('TSites')				IS NOT NULL DROP TABLE	TSites
IF OBJECT_ID('TRandomCodes')		IS NOT NULL DROP TABLE	TRandomCodes
IF OBJECT_ID('TStudies')			IS NOT NULL DROP TABLE	TStudies
IF OBJECT_ID('TStates')				IS NOT NULL DROP TABLE	TStates
IF OBJECT_ID('TGenders')			IS NOT NULL DROP TABLE	TGenders
IF OBJECT_ID('TVisitTypes')			IS NOT NULL DROP TABLE	TVisitTypes
IF OBJECT_ID('TWithdrawReasons')	IS NOT NULL DROP TABLE	TWithdrawReasons

-- ---------------------
-- Drop Procedures
-- ---------------------
IF OBJECT_ID ('uspFindPatientID')			IS NOT NULL DROP PROCEDURE uspFindPatientID
IF OBJECT_ID ('uspScreenNewPatient')		IS NOT NULL DROP PROCEDURE uspScreenNewPatient
IF OBJECT_ID ('uspMakePatientNumber')		IS NOT NULL DROP PROCEDURE uspMakePatientNumber
IF OBJECT_ID ('uspNewVisit')				IS NOT NULL DROP PROCEDURE uspNewVisit
IF OBJECT_ID ('uspCheckDate')				IS NOT NULL DROP PROCEDURE uspCheckDate
IF OBJECT_ID ('uspAddVisit')				IS NOT NULL DROP PROCEDURE uspAddVisit
IF OBJECT_ID ('uspWithdrawPatient')			IS NOT NULL DROP PROCEDURE uspWithdrawPatient
IF OBJECT_ID ('uspRandomizePatient')		IS NOT NULL DROP PROCEDURE uspRandomizePatient
IF OBJECT_ID ('uspStudy12345Randomization')	IS NOT NULL DROP PROCEDURE uspStudy12345Randomization
IF OBJECT_ID ('uspStudy54321Randomization')	IS NOT NULL DROP PROCEDURE uspStudy54321Randomization

-- ---------------------
-- Drop Functions
-- ---------------------
IF OBJECT_ID('fn_GetPatientID')		IS NOT NULL DROP FUNCTION fn_GetPatientID
IF OBJECT_ID('fn_GetSiteID')		IS NOT NULL DROP FUNCTION fn_GetSiteID
IF OBJECT_ID('fn_GetStudyID')		IS NOT NULL DROP FUNCTION fn_GetStudyID

-- ---------------------
-- Drop View
-- ---------------------
IF OBJECT_ID('vAllPatientAllSites')				IS NOT NULL DROP VIEW vAllPatientAllSites
IF OBJECT_ID('vAllRandomizedPatients')			IS NOT NULL DROP VIEW vAllRandomizedPatients
IF OBJECT_ID('vNextMinRandomCode12345')			IS NOT NULL DROP VIEW vNextMinRandomCode12345
IF OBJECT_ID('vNextMinRandomCode54321Placebo')	IS NOT NULL DROP VIEW vNextMinRandomCode54321Placebo
IF OBJECT_ID('vNextMinRandomCode54321Active')	IS NOT NULL DROP VIEW vNextMinRandomCode54321Active
IF OBJECT_ID('vNextMinRandomCode54321All')		IS NOT NULL DROP VIEW vNextMinRandomCode54321All
IF OBJECT_ID('vAllAvailableDrugAllSites')		IS NOT NULL DROP VIEW vAllAvailableDrugAllSites
IF OBJECT_ID('vAllWithdrawnPatients')			IS NOT NULL DROP VIEW vAllWithdrawnPatients

-- ---------------------
-- Create Tables
-- ---------------------
CREATE TABLE TStudies
(      
	intStudyID			INTEGER			NOT NULL
	,strStudyDesc		VARCHAR(255)	NOT NULL
	,CONSTRAINT TStudies_PK PRIMARY KEY (intStudyID)
)

CREATE TABLE TSites
(
	intSiteID			INTEGER			NOT NULL
	,intSiteNumber		INTEGER			NOT NULL
	,intStudyID			INTEGER			NOT NULL
	,strName			VARCHAR(255)	NOT NULL
	,strAddress			VARCHAR(255)	NOT NULL
	,strCity			VARCHAR(255)	NOT NULL
	,intStateID			INTEGER			NOT NULL
	,strZip				VARCHAR(255)	NOT NULL
	,strPhone			VARCHAR(255)	NOT NULL
	,CONSTRAINT TSites_PK PRIMARY KEY (intSiteID)
)

CREATE TABLE TPatients
(
	intPatientID		INTEGER	IDENTITY(1,1)	NOT NULL
	,intPatientNumber	INTEGER					NOT NULL
	,intSiteID			INTEGER					NOT NULL
	,dtDOB				DATE					NOT NULL
	,intGenderID		INTEGER					NOT NULL
	,intWeight			INTEGER					NOT NULL
	,intRandomCodeID	INTEGER
	,CONSTRAINT TPatients_UQ UNIQUE (intSiteID, dtDOB, intGenderID, intWeight, intRandomCodeID)
	,CONSTRAINT TPatients_PK PRIMARY KEY (intPatientID)
)

CREATE TABLE TVisitTypes
(
	intVisitTypeID		INTEGER			NOT NULL
	,strVisitDesc		VARCHAR(255)	NOT NULL
	,CONSTRAINT TVisitTypes_PK PRIMARY KEY (intVisitTypeID)
)

CREATE TABLE TVisits
(
	intVisitID				INTEGER	IDENTITY(1,1)	NOT NULL
	,intPatientID			INTEGER					NOT NULL
	,dtVisit				DATE					NOT NULL
	,intVisitTypeID			INTEGER					NOT NULL
	,intWithdrawReasonID	INTEGER
	,CONSTRAINT TVisits_UQ UNIQUE (intPatientID, intVisitTypeID, intWithdrawReasonID)
	,CONSTRAINT TVisits_PK PRIMARY KEY (intVisitID)
)

CREATE TABLE TRandomCodes
(
	intRandomCodeID			INTEGER			NOT NULL
	,intRandomCode			INTEGER			NOT NULL
	,intStudyID				INTEGER			NOT NULL
	,strTreatment			VARCHAR(255)	NOT NULL
	,blnAvailable			BIT			NOT NULL
	,CONSTRAINT TRandomCodes_PK PRIMARY KEY (intRandomCodeID)
)

CREATE TABLE TDrugKits
(
	intDrugKitID			INTEGER			NOT NULL
	,intDrugKitNumber		INTEGER			NOT NULL
	,intSiteID				INTEGER			NOT NULL
	,strTreatment			VARCHAR(255)	NOT NULL
	,intVisitID				INTEGER			
	,CONSTRAINT TDrugKits_PK PRIMARY KEY (intDrugKitID)
)

CREATE TABLE TWithdrawReasons
(
	intWithdrawReasonID		INTEGER			NOT NULL
	,strWithdrawDesc		VARCHAR(255)	NOT NULL
	CONSTRAINT TWithdrawReasons_PK PRIMARY KEY (intWithdrawReasonID)
)

CREATE TABLE TGenders
(
	intGenderID				INTEGER			NOT NULL
	,strGender				VARCHAR(255)	NOT NULL
	CONSTRAINT TGenders_PK PRIMARY KEY (intGenderID)
)

CREATE TABLE TStates
(
	intStateID				INTEGER			NOT NULL
	,strStateDesc			VARCHAR(255)	NOT NULL
	,CONSTRAINT	TStates_PK	PRIMARY KEY (intStateID)
)

-- ------------------------------------
-- Identify and Create Foreign Keys
-- ------------------------------------
-- 
-- #	Child			Parent				Column(s)
-- -	-----			------				---------
-- 1	TSites			TStudies			intStudyID
-- 2	TSites			TStates				intStateID
-- 3	TRandomCodes	TStudies			intStudyID
-- 4	TDrugKits		TSites				intSiteID
-- 5	TDrugKits		TVisitTypes			intVisitID
-- 6	TPatients		TSites				intSiteID
-- 7	TPatients		TGenders			intGenderID
-- 8	TPatients		TRandomCodes		intRandomCodeID
-- 9	TVisits			TPatients			intPatientID
-- 10	TVisits			TVisitTypes			intVisitTypeID
-- 11	TVisits			TWithdrawReasons	intWithdrawReasonID	

-- 1
ALTER TABLE TSites ADD CONSTRAINT TSites_TStudies_FK
FOREIGN KEY (intStudyID) REFERENCES TStudies(intStudyID)

-- 2 
ALTER TABLE TSites ADD CONSTRAINT TSites_TStates_FK
FOREIGN KEY (intStateID) REFERENCES TStates(intStateID)

-- 3
ALTER TABLE TRandomCodes ADD CONSTRAINT TRandomCodes_TStudies_FK
FOREIGN KEY (intStudyID) REFERENCES TStudies(intStudyID)

-- 4
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TSites_FK
FOREIGN KEY (intSiteID) REFERENCES TSites(intSiteID)

-- 5
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TVisits_FK
FOREIGN KEY (intVisitID) REFERENCES TVisits(intVisitID)

-- 6
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TSites_FK
FOREIGN KEY (intSiteID) REFERENCES TSites(intSiteID)

-- 7
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TGenders_FK
FOREIGN KEY (intGenderID) REFERENCES TGenders(intGenderID)

-- 8
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TRandomCodes_FK
FOREIGN KEY (intRandomCodeID) REFERENCES TRandomCodes(intRandomCodeID)

-- 9
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TPatients_FK
FOREIGN KEY (intPatientID) REFERENCES TPatients(intPatientID)

-- 10
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TVisitTypes_FK
FOREIGN KEY (intVisitTypeID) REFERENCES TVisitTypes(intVisitTypeID)

-- 11
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TWithdrawReasons_FK
FOREIGN KEY (intWithdrawReasonID) REFERENCES TWithdrawReasons(intWithdrawReasonID)

-- ------------------------------------
-- Insert Data
-- ------------------------------------
INSERT INTO TStudies (intStudyID, strStudyDesc)
VALUES (1, 'Study 12345')
		,(2, 'Study 54321')

INSERT INTO TVisitTypes(intVisitTypeID, strVisitDesc)
VALUES (1, 'Screening')
		,(2, 'Randomization')
		,(3, 'Withdrawal')

INSERT INTO TStates (intStateID, strStateDesc)
VALUES (1, 'Ohio')
		,(2, 'Kentucky')
		,(3, 'Indiana')
		,(4, 'New Jersey')
		,(5, 'Viriginia')
		,(6, 'Georgia')
		,(7, 'Iowa')

INSERT INTO TSites (intSiteID, intSiteNumber, intStudyID, strName, strAddress, strCity, intStateID, strZip, strPhone)
VALUES (1, 101, 1, 'Dr. Stan Heinrich', '123 E. Main St', 'Atlanta', 6, '25869', '1234567890')
		,(2, 111, 1, 'Mercy Hospital', '3456 Elmhurst Rd.', 'Secaucus', 4, '32659', '5013689564')
		,(3, 121, 1, 'St. Elizabeth Hospital', '976 Jackson Way', 'Ft. Thomas', 2, '41258', '3026521478')
		,(4, 501, 2, 'Dr. Robert Adler', '9087 W. Maple Ave.', 'Cedar Rapids', 7, '42365', '6149652574')
		,(5, 511, 2, 'Dr. Tim Schmitz', '4539 Helena Run', 'Mason', 1, '45040', '5136987462')
		,(6, 521, 2, 'Dr. Lawrence Snell', '9201 NW. Washington Blvd.', 'Bristol', 5, '20163', '3876510249')

INSERT INTO TGenders (intGenderID, strGender)
VALUES (1, 'Female')
		,(2, 'Male')

INSERT INTO TWithdrawReasons (intWithdrawReasonID, strWithdrawDesc)
VALUES (1, 'Patient withdrew consent')
		,(2, 'Adverse event')
		,(3, 'Health issue-related to study')
		,(4, 'Health issue-unrelated to study')
		,(5, 'Personal reason')
		,(6, 'Completed the study')

INSERT INTO TRandomCodes (intRandomCodeID, intRandomCode, intStudyID, strTreatment, blnAvailable)
VALUES (1, 1000, 1, 'A', 1)
	,(2, 1001, 1, 'P', 1)
	,(3, 1002, 1, 'A', 1)
	,(4, 1003, 1, 'P', 1)
	,(5, 1004, 1, 'P', 1)
	,(6, 1005, 1, 'A', 1)
	,(7, 1006, 1, 'A', 1)
	,(8, 1007, 1, 'P', 1)
	,(9, 1008, 1, 'A', 1)
	,(10, 1009, 1, 'P', 1)
	,(11, 1010, 1, 'P', 1)
	,(12, 1011, 1, 'A', 1)
	,(13, 1012, 1, 'P', 1)
	,(14, 1013, 1, 'A', 1)
	,(15, 1014, 1, 'A', 1)
	,(16, 1015, 1, 'A', 1)
	,(17, 1016, 1, 'P', 1)
	,(18, 1017, 1, 'P', 1)
	,(19, 1018, 1, 'A', 1)
	,(20, 1019, 1, 'P', 1)				
	,(21, 5000, 2, 'A', 1)
	,(22, 5001, 2, 'A', 1)
	,(23, 5002, 2, 'A', 1)
	,(24, 5003, 2, 'A', 1)
	,(25, 5004, 2, 'A', 1)
	,(26, 5005, 2, 'A', 1)
	,(27, 5006, 2, 'A', 1)
	,(28, 5007, 2, 'A', 1)
	,(29, 5008, 2, 'A', 1)
	,(30, 5009, 2, 'A', 1)
	,(31, 5010, 2, 'P', 1)
	,(32, 5011, 2, 'P', 1)
	,(33, 5012, 2, 'P', 1)
	,(34, 5013, 2, 'P', 1)
	,(35, 5014, 2, 'P', 1)
	,(36, 5015, 2, 'P', 1)
	,(37, 5016, 2, 'P', 1)
	,(38, 5017, 2, 'P', 1)
	,(39, 5018, 2, 'P', 1)
	,(40, 5019, 2, 'P', 1)

INSERT INTO TDrugKits (intDrugKitID, intDrugKitNumber, intSiteID, strTreatment)
VALUES (1, 10000, 1, 'A' )
	,(2,	10001,	1,	'A')
	,(3,	10002,	1,	'A')
	,(4,	10003,	1,	'P')
	,(5,	10004,	1,	'P')
	,(6,	10005,	1,	'P')
	,(7,	10006,	2,	'A')
	,(8,	10007,	2,	'A')
	,(9,	10008,	2,	'A')
	,(10,	10009,	2,	'P')
	,(11,	10010,	2,	'P')
	,(12,	10011,	2,	'P')
	,(13,	10012,	3,	'A')
	,(14,	10013,	3,	'A')
	,(15,	10014,	3,	'A')
	,(16,	10015,	3,	'P')
	,(17,	10016,	3,	'P')
	,(18,	10017,	3,	'P')
	,(19,	10018,	4,	'A')
	,(20,	10019,	4,	'A')
	,(21,	10020,	4,	'A')
	,(22,	10021,	4,	'P')
	,(23,	10022,	4,	'P')
	,(24,	10023,	4,	'P')
	,(25,	10024,	5,	'A')
	,(26,	10025,	5,	'A')
	,(27,	10026,	5,	'A')
	,(28,	10027,	5,	'P')
	,(29,	10028,	5,	'P')
	,(30,	10029,	5,	'P')
	,(31,	10030,	6,	'A')
	,(32,	10031,	6,	'A')
	,(33,	10032,	6,	'A')
	,(34,	10033,	6,	'P')
	,(35,	10034,	6,	'P')
	,(36,	10035,	6,	'P')
-- -----------------------
-- CREATE FUNCTIONS
-- -----------------------
-- -----------------------
-- Function:Get Patient ID
-- -----------------------
GO
CREATE FUNCTION fn_GetPatientID
				(@intPatientNumber int)
RETURNS INTEGER
AS
BEGIN
	DECLARE @intPatientID INTEGER
	SELECT @intPatientID = intPatientID FROM TPatients WHERE intPatientNumber = @intPatientNumber 
	RETURN @intPatientID
END

-- -----------------------
-- Function: Get Study ID
-- -----------------------
GO
CREATE FUNCTION fn_GetStudyID
				(@intSiteID int)
RETURNS INTEGER
AS
BEGIN
	DECLARE @intStudyID INTEGER
	SELECT @intStudyID = intStudyID FROM TSites WHERE intSiteID = @intSiteID
	RETURN @intStudyID
END

-- -----------------------
-- Function: Get Site ID
-- -----------------------
GO
CREATE FUNCTION fn_GetSiteID
				(@intPatientNumber int)
RETURNS INTEGER
AS
BEGIN
	DECLARE @intSiteID INTEGER
	SELECT @intSiteID = intSiteID FROM TPatients WHERE intPatientNumber = @intPatientNumber
	RETURN @intSiteID
END

-- -----------------------
-- Create Stored Procedures
-- -----------------------
-- --------------------------------
-- Make Patient Number Stored Proc
-- --------------------------------
GO
CREATE PROCEDURE uspMakePatientNumber
	@intPatientNumber	AS INTEGER OUTPUT
	,@intSiteID			AS INTEGER
	,@intSiteNumber		AS INTEGER
AS 
SET NOCOUNT ON
SET XACT_ABORT ON
BEGIN
	DECLARE GetSiteNumber CURSOR LOCAL FOR
	SELECT intSiteNumber FROM TSites
	WHERE intSiteID = @intSiteID

	OPEN GetSiteNumber

	FETCH FROM GetSiteNumber
	INTO @intSiteNumber

	CLOSE GetSiteNumber
END

BEGIN 
	DECLARE @intNumberofOccurences AS INTEGER
	DECLARE @intCounter AS INTEGER
	DECLARE @strSiteNumber AS VARCHAR(255)
	DECLARE @strPatientNumber AS VARCHAR(255)

	SET @intCounter = 0
	SET @strSiteNumber = CONVERT(varchar, @intSiteNumber)
	SET @strPatientNumber = (SELECT CONCAT(@strSiteNumber,'000'))
	SET @intPatientNumber = CONVERT(INTEGER, @strPatientNumber)

	SET @intNumberofOccurences = (SELECT COUNT(@intSiteID) FROM TPatients WHERE intSiteID = @intSiteID) + 1

	WHILE @intCounter < @intNumberofOccurences
	BEGIN
		SET @intCounter += 1
		SET @intPatientNumber += 1
	END
END

-- -------------------------------------
-- Create Check Date Stored Proc
-- -------------------------------------
GO
CREATE PROCEDURE uspCheckDate
	@blnDateCheck	AS BIT OUTPUT
	,@dtVisit		AS DATE
	,@intVisitType	AS INTEGER
	,@intPatientID	AS INTEGER
AS
SET NOCOUNT ON
SET XACT_ABORT ON
BEGIN 
	DECLARE @Date1 AS DATE, @Date2 AS DATE, @Date3 AS DATE
	SET @Date1 = (SELECT dtVisit FROM TVisits WHERE intPatientID = @intPatientID AND intVisitTypeID = 1)
	IF @intVisitType = 3
		SET @Date3 = @dtVisit
		SET @Date2 = (SELECT dtVisit FROM TVisits WHERE intPatientID = @intPatientID AND intVisitTypeID = 2)
		IF @Date1>@Date3
			BEGIN
				PRINT 'Error! Screening Date Cannot Have Occurred After Withdraw Date'
				SET @blnDateCheck = 1
			END
		ELSE IF @Date2 IS NOT NULL AND @Date2 > @Date3
			BEGIN 
				PRINT 'Error! Randomization Date Cannot Have Occurred After Withdraw Date'
				SET @blnDateCheck = 1
			END


	ELSE IF @intVisitType = 2
		-- SET VARIABLES FOR DATES AFTER SCREENING
		SET @Date2 = @dtVisit
		IF @Date1 > @Date2
			BEGIN
				PRINT 'Error! Screening Date Cannot Have Occurred After Randomization Date'
				SET @blnDateCheck = 1
			END
END

-- -------------------------------------
-- Create Patient ID Stored Proc
-- -------------------------------------
/*
GO 
CREATE PROCEDURE uspFindPatientID
	@intPatientID		AS INTEGER OUTPUT
AS
SET NOCOUNT ON
SET XACT_ABORT ON
BEGIN
	DECLARE @intCount AS INTEGER
	SELECT @intCount = MAX(intPatientID) + 1
	FROM TPatients (TABLOCKX)

	--Default to 1 if table is empty
	SELECT @intCount = COALESCE(@intCount, 1)

	SET @intPatientID = @intCount
END
*/

-- --------------------------------------
-- Add Visit Stored Proc
-- --------------------------------------
GO
CREATE PROCEDURE uspAddVisit
	@intPatientID		AS INTEGER
	,@dtVisit			AS DATE
	,@intVisitType		AS INTEGER
	,@intWithdrawReason	AS INTEGER
	,@blnDateCheck		AS INTEGER OUTPUT
AS
SET XACT_ABORT ON

BEGIN TRANSACTION
	SET @blnDateCheck = 0

	INSERT INTO TVisits WITH (TABLOCKX) (intPatientID, dtVisit, intVisitTypeID, intWithdrawReasonID)
	VALUES (@intPatientID, @dtVisit, @intVisitType, @intWithdrawReason)

	EXECUTE uspCheckDate @blnDateCheck OUTPUT, @dtVisit, @intVisitType, @intPatientID
	
	IF @blnDateCheck = 1
		BEGIN	
			ROLLBACK 
			PRINT 'Date Error - Rolling Back Transaction'
		END
	ELSE
		BEGIN
			COMMIT TRANSACTION 
		END

-- ---------------------------------------
-- Screen Patient Stored Proc
-- ---------------------------------------
GO
CREATE PROCEDURE uspScreenNewPatient
	@intSiteID		AS INTEGER
	,@dtDOB			AS DATE	
	,@intGenderID	AS INTEGER
	,@intWeight		AS INTEGER
	,@dtVisit		AS DATE
AS
SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN
	
	DECLARE @intPatientNumber AS INTEGER, @intSiteNumber AS INTEGER
	EXECUTE uspMakePatientNumber @intPatientNumber OUTPUT, @intSiteID, @intSiteNumber

END 

BEGIN TRANSACTION uspScreenNewPatient

	INSERT INTO TPatients WITH (TABLOCKX) (intPatientNumber, intSiteID, dtDOB, intGenderID, intWeight)
	VALUES (@intPatientNumber, @intSiteID, @dtDOB, @intGenderID, @intWeight)

COMMIT TRANSACTION

BEGIN
	
	DECLARE @intPatientID AS INTEGER, @intVisitType AS INTEGER, @intWithdrawReason AS INTEGER, @blnDateCheck AS BIT
	SET @intPatientID = dbo.fn_GetPatientID (@intPatientNumber)
	-- Set VisitValue equal to 1 for Screening
	SET @intVisitType = 1

	EXECUTE uspAddVisit @intPatientID, @dtVisit, @intVisitType, @intWithdrawReason, @blnDateCheck OUTPUT

END

-- ----------------------------------------
-- Withdraw Patient Stored Proc
-- ----------------------------------------
GO
CREATE PROCEDURE uspWithdrawPatient
	@intPatientNumber	AS INTEGER
	,@dtWithdrawDate	AS DATE
	,@intWithdrawReason	AS INTEGER
AS
SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN 
	DECLARE @intPatientID AS INTEGER
	SET @intPatientID = dbo.fn_GetPatientID (@intPatientNumber)
END

BEGIN
	DECLARE @intVisitTypeID INTEGER, @blnDateCheck AS BIT 
	-- Set VisitType to 3 for Withdraw
	SET @intVisitTypeID = 3

	EXECUTE uspAddVisit @intPatientID, @dtWithdrawDate, @intVisitTypeID, @intWithdrawReason, @blnDateCheck OUTPUT

	IF @blnDateCheck = 1
		BEGIN
			PRINT 'Withdraw Information Not Applied'
		END
END

-- ---------------------------------------
-- Study 12345 Randomization Stored Proc
-- ---------------------------------------
GO
CREATE PROCEDURE uspStudy12345Randomization
			@intStudyID		AS INTEGER
			,@intPatientID	AS INTEGER
			,@intSiteID		AS INTEGER
AS
SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN
	DECLARE @intRandomCodeID AS INTEGER
	SET @intRandomCodeID = (SELECT TOP 1 intRandomCodeID FROM TRandomCodes WHERE intStudyID = @intStudyID AND blnAvailable = 1)

	UPDATE TRandomCodes 
	SET blnAvailable = 0
	WHERE intRandomCodeID = @intRandomCodeID
END

BEGIN 
	UPDATE TPatients
	SET intRandomCodeID = @intRandomCodeID
	WHERE intPatientID = @intPatientID
END

BEGIN
	DECLARE @strTreatment AS VARCHAR(255)
	SET @strTreatment = (SELECT strTreatment FROM TRandomCodes WHERE intRandomCodeID = @intRandomCodeID)
END

BEGIN
	DECLARE @intVisitID AS INTEGER

	DECLARE GetVisitID CURSOR LOCAL FOR
	SELECT intVisitID FROM TVisits
	WHERE intPatientID = @intPatientID AND intVisitTypeID = 2

	OPEN GetVisitID

	FETCH FROM GetVisitID
	INTO @intVisitID

	CLOSE GetVisitID
END

BEGIN
	DECLARE @intDrugKitNumber AS INTEGER
	SET @intDrugKitNumber = (SELECT TOP 1 intDrugKitNumber From TDrugKits WHERE intSiteID = @intSiteID AND strTreatment = @strTreatment AND intVisitID IS NULL)

	UPDATE TDrugKits
	SET intVisitID = @intVisitID
	WHERE intDrugKitNumber = @intDrugKitNumber
END

-- -----------------------------
-- Study54321 Randomization Stored Proc
-- -----------------------------
GO 
CREATE PROCEDURE uspStudy54321Randomization
			@intStudyID		AS INTEGER
			,@intPatientID	AS INTEGER
			,@intSiteID		AS INTEGER
AS
SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN
	DECLARE @decRandomNumber AS DECIMAL(10, 4), @strTreatment AS VARCHAR(255)
	SET @decRandomNumber = RAND()

	IF @decRandomNumber <= .5
		SET @strTreatment = 'P';
	ELSE
		SET @strTreatment = 'A';
END

BEGIN
	DECLARE @intCount1 AS INTEGER, @intCount2 AS INTEGER

	-- Count Assigned Placebo
	SET @intCount2 = (SELECT COUNT(intRandomCodeID) FROM TRandomCodes WHERE strTreatment = 'P' AND intStudyID = @intStudyID AND blnAvailable = 0)

	-- Count Assigned Active
	SET @intCount1 = (SELECT COUNT(intRandomCodeID) FROM TRandomCodes WHERE strTreatment = 'A' AND intStudyID = @intStudyID AND blnAvailable = 0)

	--Calculate Differences
	DECLARE @intDifference1 AS INTEGER, @intDifference2 AS INTEGER
	SET @intDifference1 = @intCount1 - @intCount2
	SET @intDifference2 = @intCount2 - @intCount1
END

BEGIN 
	IF @intDifference1 >= 2
		BEGIN
			SET @strTreatment = 'P'
			PRINT 'TreatmentID changed to 2 for randomization'
		END
	ELSE IF @intDifference2 >= 2
		BEGIN
			SET @strTreatment = 'A'
			PRINT 'TreatmentID changed to 1 for randomization'
		END
END

BEGIN 
	DECLARE @intRandomCodeID AS INTEGER
	SET @intRandomCodeID = (SELECT TOP 1 intRandomCodeID FROM TRandomCodes WHERE intStudyID = @intStudyID AND strTreatment = @strTreatment AND blnAvailable = 1)

	UPDATE TRandomCodes
	SET blnAvailable = 0
	WHERE intRandomCodeID = @intRandomCodeID
END

BEGIN
	UPDATE TPatients
	SET intRandomCodeID = @intRandomCodeID
	WHERE intPatientID = @intPatientID
END

BEGIN
	DECLARE @intVisitID AS INTEGER

	DECLARE GetVisitID CURSOR LOCAL FOR
	SELECT intVisitID FROM TVisits
	WHERE intPatientID = @intPatientID AND intVisitTypeID = 2

	OPEN GetVisitID

	FETCH FROM GetVisitID
	INTO @intVisitID
	
	CLOSE GetVisitID
END

BEGIN
	DECLARE @intDrugKitNumber AS INTEGER
	SET @intDrugKitNumber = (SELECT TOP 1 intDrugKitNumber FROM TDrugKits WHERE intSiteID = @intSiteID AND strTreatment = @strTreatment AND intVisitID IS NULL)

	UPDATE TDrugKits
	SET intVisitID = @intVisitID
	WHERE intDrugKitNumber = @intDrugKitNumber
END

-- -----------------------------
-- Randomize Patient Stored Proc
-- -----------------------------
GO
CREATE PROCEDURE uspRandomizePatient
			@intPatientNumber AS INTEGER
AS 
SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN
	DECLARE @intPatientID AS INTEGER
	SET @intPatientID = dbo.fn_GetPatientID (@intPatientNumber)
END

BEGIN
	DECLARE @intSiteID AS INTEGER
	SET @intSiteID = dbo.fn_GetSiteID (@intPatientNumber)
END

BEGIN
	DECLARE @intStudyID AS INTEGER
	SET @intStudyID = dbo.fn_GetStudyID (@intSiteID) 
END

BEGIN 
	DECLARE @dtVisit AS DATE, @intVisitTypeID AS INTEGER, @intWithdrawReason AS INTEGER, @blnDateCheck AS BIT
	SET @dtVisit = GETDATE()
	SET @intVisitTypeID = 2
	SET @blnDateCheck = 0

	EXECUTE uspAddVisit @intPatientID, @dtVisit, @intVisitTypeID, @intWithdrawReason, @blnDateCheck
END

IF @intStudyID = 1
BEGIN
	EXECUTE uspStudy12345Randomization @intStudyID, @intPatientID, @intSiteID
END

IF @intStudyID = 2
BEGIN 
	EXECUTE uspStudy54321Randomization @intStudyID, @intPatientID, @intSiteID
END

-- ----------------------------
-- Create Views
-- ----------------------------
-- -------------------------------
-- 2.) All patients at all sites
-- -------------------------------
GO
CREATE VIEW vAllPatientAllSites
AS
SELECT 
TP.intPatientNumber AS 'Patient Number', TP.dtDOB AS 'Date of Birth', TG.strGender AS 'Gender', TP.intWeight AS 'Weight', TS.intSiteNumber AS 'Site Number', TS.strName AS 'Site Name', TS.strAddress+', '+TS.strCity+', '+TST.strStateDesc+' '+TS.strZip AS 'Site Address Information', TS.strPhone AS 'Site Phone'
FROM TPatients AS TP

JOIN TSites AS TS
ON TP.intSiteID = TS.intSiteID

JOIN TGenders AS TG
ON TG.intGenderID = TP.intGenderID

JOIN TStates AS TST
ON TST.intStateID = TS.intStateID

-- -----------------------------------------------------
-- 3.) All randomized patients with site and treatments
-- -----------------------------------------------------
GO
CREATE VIEW vAllRandomizedPatients
AS
SELECT TP.intPatientNumber AS 'Patient Number', TD.intDrugKitID 'Drug Kit ID', TD.strTreatment 'Treatment', TS.intSiteNumber AS 'Site Number', TS.strName AS 'Site Name', TS.strAddress+', '+TS.strCity+', '+TST.strStateDesc+' '+TS.strZip AS 'Site Address Information', TS.strPhone AS 'Site Phone'
FROM TPatients AS TP

JOIN TSites AS TS
ON TS.intSiteID = TP.intSiteID

JOIN TVisits AS TV
ON TV.intPatientID = TP.intPatientID

JOIN TStudies AS TSTU
ON TSTU.intStudyID = TS.intStudyID

JOIN TRandomCodes AS TR
ON TR.intRandomCodeID = TP.intRandomCodeID

JOIN TDrugKits AS TD
ON TD.intVisitID = TV.intVisitID

JOIN TStates AS TST
ON TST.intStateID = TS.intStateID

JOIN TGenders AS TG
ON TG.intGenderID = TP.intGenderID

WHERE TV.intVisitTypeID = 2

-- ------------------------------------------------
-- 4a.) Next minimum random codes for Study 12345
-- ------------------------------------------------
GO
CREATE VIEW vNextMinRandomCode12345
AS
SELECT TOP 1 TR.intRandomCode AS 'Study 12345 Random Codes', TR.strTreatment AS 'Treatment'
FROM TRandomCodes AS TR

WHERE intStudyID = 1 AND blnAvailable = 1
GO

---- -------------------------------------------------------
-- 4b p1.) Next minimum random codes for Study 54321 Placebo
---- --------------------------------------------------------
GO
CREATE VIEW vNextMinRandomCode54321Placebo
AS
SELECT TOP 1 intRandomCode
FROM TRandomCodes
WHERE intStudyID = 2 AND blnAvailable = 0 AND strTreatment = 'P'

-- --------------------------------------------------------
-- 4b pt2.) Next minimum random codes for Study 54321 Active
-- --------------------------------------------------------
GO
CREATE VIEW vNextMinRandomCode54321Active
AS
SELECT TOP 1 intRandomCode
FROM TRandomCodes
WHERE intStudyID = 2 AND blnAvailable = 0 AND strTreatment = 'A'

-- --------------------------------------------------------
-- 4b pt3.) Next minimum random codes for Study 54321 All
-- --------------------------------------------------------
GO 
CREATE VIEW vNextMinRandomCode54321All
AS
SELECT intRandomCode AS 'Study 54321 Random Codes', 'Active' As Treatment
FROM vNextMinRandomCode54321Active
UNION ALL
SELECT intRandomCode, 'Placebo'
FROM vNextMinRandomCode54321Placebo

-- ---------------------------------------------------------
-- 5.) All available drugs at all sites
-- ---------------------------------------------------------
GO
CREATE VIEW vAllAvailableDrugAllSites
AS
SELECT DISTINCT TS.strName AS 'Site Name', TS.intSiteNumber AS 'Site Number', TD.intDrugKitNumber AS 'Drug Kit Number'
FROM TSites AS TS

JOIN TPatients AS TP
ON TP.intSiteID = TS.intSiteID

JOIN TDrugKits AS TD
ON TD.intSiteID = TS.intSiteID

WHERE TD.intVisitID IS NULL

-- ---------------------------------
-- 6.) Show all withdrawn patients
-- ---------------------------------
GO
CREATE VIEW vAllWithdrawnPatients
AS
SELECT TP.intPatientNumber AS 'Patient Number', TS.strName AS 'Site Name', TS.intSiteNumber AS 'Site Number', TWR.strWithdrawDesc AS 'Withdraw Reason', TV.dtVisit AS 'Withdraw Date'
FROM TPatients AS TP

JOIN TSites AS TS
ON TS.intSiteID = TP.intSiteID

JOIN TVisits AS TV
ON TV.intPatientID = TP.intPatientID

JOIN TWithdrawReasons AS TWR
ON TWR.intWithdrawReasonID = TV.intWithdrawReasonID

WHERE TV.intVisitTypeID = 3
GO
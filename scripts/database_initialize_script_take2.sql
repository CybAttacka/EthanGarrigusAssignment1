USE library_assignment_1_take2;

#Allows importing local files
SET GLOBAL local_infile = 1;

#Deletes tables to re-create them later
DROP TABLE PATRONACTIVITY;
DROP TABLE PATRON;
DROP TABLE PATRONTYPE;
DROP TABLE HOMELIBRARY;
DROP TABLE NOTIFICATIONPREFERENCE;
DROP TABLE IMPORTTABLE;

#Defines the tables and their columns
CREATE TABLE PATRONTYPE(
PatronTypeCode	int  PRIMARY KEY	NOT NULL,
PatronTypeDefinition	char(20)	NOT NULL
);
CREATE TABLE HOMELIBRARY(
HomeLibraryCode	  char(5)  PRIMARY KEY	NOT NULL,
HomeLibraryDefinition	char(20)	NOT NULL
);
CREATE TABLE NOTIFICATIONPREFERENCE(
NotificationPreferenceCode	  char(1)  PRIMARY KEY	NOT NULL,
NotificationPreferenceDefinition	char(20)	NOT NULL
);
CREATE TABLE PATRON(
PatronID	BigInt	AUTO_INCREMENT	PRIMARY KEY	NOT NULL,
PatronTypeCode	int	NOT NULL,
FOREIGN KEY (PatronTypeCode) REFERENCES PATRONTYPE(PatronTypeCode),
HomeLibraryCode	  char(5)	NOT NULL,
FOREIGN KEY (HomeLibraryCode) REFERENCES HOMELIBRARY(HomeLibraryCode),
NotificationPreferenceCode	  char(1)	NOT NULL,
FOREIGN KEY (NotificationPreferenceCode) REFERENCES NOTIFICATIONPREFERENCE(NotificationPreferenceCode),
AgeRange	char(20)	NOT NULL,
ProvidedEmailAddress	bool	NOT NULL,
WithinSanFranciscoCounty	bool	NOT NULL
);
CREATE TABLE PATRONACTIVITY(
PatronID	BigInt	AUTO_INCREMENT	PRIMARY KEY	NOT NULL,
FOREIGN KEY (PatronID) REFERENCES PATRON(PatronID),
YearPatronRegistered	int	NOT NULL,
TotalCheckouts	int	NOT NULL,
TotalRenewals	int NOT NULL,
CirculationActiveYear	int	NULL,
CirculationActiveMonth	char(9)	NULL
);

#Defines an import table to import the excel datasheet as presented
CREATE TABLE IMPORTTABLE (
    PatronTypeCode INT,
    PatronTypeDefinition VARCHAR(100),
    TotalCheckouts INT,
    TotalRenewals INT,
    AgeRange VARCHAR(50),
    HomeLibraryCode VARCHAR(50),
    HomeLibraryDefinition VARCHAR(100),
    CirculationActiveYear INT,
    CirculationActiveMonth VARCHAR(20),
    NotificationPreferenceCode VARCHAR(50),
    NotificationPreferenceDefinition VARCHAR(100),
    ProvidedEmailAddress VARCHAR(10),
    WithinSanFranciscoCounty VARCHAR(10),
    YearPatronRegistered INT,
    PatronID BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL
);


#Processes and loads the excel datasheet into the import table, if given the right path
LOAD DATA LOCAL INFILE
'C:/Users/ethga/OneDrive/Desktop/Database Assignment 1/SFPL_DataSF_library-usage_Jan_2023 - COMMA SEP.csv'
INTO TABLE IMPORTTABLE
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


#Loads info from import table into PATRONTYPE
INSERT INTO PATRONTYPE (
    PatronTypeCode,
    PatronTypeDefinition
)
SELECT DISTINCT
    PatronTypeCode,
    PatronTypeDefinition
FROM IMPORTTABLE
WHERE PatronTypeCode IS NOT NULL
  AND PatronTypeDefinition IS NOT NULL;

#Loads info from import table into HOMELIBRARY
INSERT INTO HOMELIBRARY (
    HomeLibraryCode,
    HomeLibraryDefinition
)
SELECT DISTINCT
    TRIM(HomeLibraryCode),
    HomeLibraryDefinition
FROM IMPORTTABLE
WHERE HomeLibraryCode IS NOT NULL
  AND HomeLibraryDefinition IS NOT NULL;

#Loads info from import table into NOTIFICATIONPREFERENCE
INSERT INTO NOTIFICATIONPREFERENCE (
    NotificationPreferenceCode,
    NotificationPreferenceDefinition
)
SELECT DISTINCT
    TRIM(NotificationPreferenceCode),
    NotificationPreferenceDefinition
FROM IMPORTTABLE
WHERE NotificationPreferenceCode IS NOT NULL
  AND NotificationPreferenceDefinition IS NOT NULL;


#Loads info from import table into PATRON
INSERT INTO PATRON (
    PatronID,
    PatronTypeCode,
    HomeLibraryCode,
    NotificationPreferenceCode,
    AgeRange,
    ProvidedEmailAddress,
    WithinSanFranciscoCounty
)
SELECT
    i.PatronID,
    i.PatronTypeCode,
    TRIM(i.HomeLibraryCode),
    TRIM(i.NotificationPreferenceCode),
    i.AgeRange,

    CASE
        WHEN UPPER(TRIM(i.ProvidedEmailAddress))
             IN ('TRUE', '1', 'YES', 'Y')
        THEN TRUE
        ELSE FALSE
    END,

    CASE
        WHEN UPPER(TRIM(i.WithinSanFranciscoCounty))
             IN ('TRUE', '1', 'YES', 'Y')
        THEN TRUE
        ELSE FALSE
    END

FROM IMPORTTABLE AS i

JOIN PATRONTYPE AS pt
    ON i.PatronTypeCode = pt.PatronTypeCode

JOIN HOMELIBRARY AS hl
    ON TRIM(i.HomeLibraryCode) = hl.HomeLibraryCode

JOIN NOTIFICATIONPREFERENCE AS np
    ON TRIM(i.NotificationPreferenceCode)
       = np.NotificationPreferenceCode;



#Loads info from import table into PATRONACTIVITY
INSERT INTO PATRONACTIVITY (
    PatronID,
    YearPatronRegistered,
    TotalCheckouts,
    TotalRenewals,
    CirculationActiveYear,
    CirculationActiveMonth
)
SELECT
    i.PatronID,
    i.YearPatronRegistered,
    i.TotalCheckouts,
    i.TotalRenewals,
    i.CirculationActiveYear,
    i.CirculationActiveMonth

FROM IMPORTTABLE AS i

JOIN PATRON AS p
    ON p.PatronID = i.PatronID;


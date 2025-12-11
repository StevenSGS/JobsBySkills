USE jobsbyskills;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Skills' and xtype='U')
CREATE TABLE Skills (
    SkillID INT PRIMARY KEY IDENTITY(1,1),
    SkillName VARCHAR(100) NOT NULL UNIQUE
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' and xtype='U')
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Companies' and xtype='U')
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY IDENTITY(1,1),
    CompanyName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Logo VARCHAR(500),
    Location VARCHAR(200),
    Industry VARCHAR(200),
    CompanySize VARCHAR(100),
    Founded INT,
    Website VARCHAR(500),
    Description TEXT,
    CreatedAt DATETIME DEFAULT GETDATE()
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='CompanyValues' and xtype='U')
CREATE TABLE CompanyValues (
    ValueID INT PRIMARY KEY IDENTITY(1,1),
    CompanyID INT,
    ValueText VARCHAR(200),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID) ON DELETE CASCADE
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Jobs' and xtype='U')
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY IDENTITY(1,1),
    CompanyID INT,
    JobTitle VARCHAR(200) NOT NULL,
    JobDescription TEXT,
    Location VARCHAR(200),
    Status VARCHAR(50) DEFAULT 'Activa',
    PostedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID) ON DELETE CASCADE
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='JobRequirements' and xtype='U')
CREATE TABLE JobRequirements (
    RequirementID INT PRIMARY KEY IDENTITY(1,1),
    JobID INT,
    RequirementText TEXT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE CASCADE
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='JobSkills' and xtype='U')
CREATE TABLE JobSkills (
    JobSkillID INT PRIMARY KEY IDENTITY(1,1),
    JobID INT,
    SkillID INT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE CASCADE,
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID) ON DELETE CASCADE
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserSkills' and xtype='U')
CREATE TABLE UserSkills (
    UserSkillID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    SkillID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID) ON DELETE CASCADE
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Applications' and xtype='U')
CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    JobID INT,
    Status VARCHAR(50) DEFAULT 'Enviada',
    AppliedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE CASCADE
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='BlogPosts' and xtype='U')
CREATE TABLE BlogPosts (
    PostID INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(300) NOT NULL,
    Author VARCHAR(100),
    PublishedDate VARCHAR(50),
    Excerpt TEXT,
    Content TEXT,
    CreatedAt DATETIME DEFAULT GETDATE()
);

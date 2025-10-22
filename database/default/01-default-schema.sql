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
    CreatedAt DATETIME DEFAULT GETDATE()
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Jobs' and xtype='U')
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY IDENTITY(1,1),
    JobTitle VARCHAR(100) NOT NULL,
    JobDescription TEXT,
    Company VARCHAR(100),
    PostedAt DATETIME DEFAULT GETDATE()
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='JobSkills' and xtype='U')
CREATE TABLE JobSkills (
    JobSkillID INT PRIMARY KEY IDENTITY(1,1),
    JobID INT,
    SkillID INT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserSkills' and xtype='U')
CREATE TABLE UserSkills (
    UserSkillID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    SkillID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

IF (SELECT COUNT(*) FROM Skills) = 0
BEGIN
    INSERT INTO Skills (SkillName) VALUES ('JavaScript'), ('Node.js'), ('Vue'), ('SQL Server'), ('Docker');
END

IF (SELECT COUNT(*) FROM Users) = 0
BEGIN
    INSERT INTO Users (FirstName, LastName, Email) VALUES ('Steven', 'Garcia', 'Steven.Gacía@jobsbyskills.com'), ('Julio', 'Quirós', 'julio.quirós@jobsbyskills.com');
END

IF (SELECT COUNT(*) FROM Jobs) = 0
BEGIN
    INSERT INTO Jobs (JobTitle, JobDescription, Company) VALUES 
    ('Desarrollador Full-Stack', 'Se requiere desarrollador con experiencia en Node.js y Vue.', 'Universidad Fidélitas.'),
    ('Administrador de Base de Datos', 'Se busca DBA con experiencia en SQL Server y optimización de consultas.', 'Universidad Fidélitas.');
END

IF (SELECT COUNT(*) FROM JobSkills) = 0
BEGIN
    INSERT INTO JobSkills (JobID, SkillID) VALUES (1, 1), (1, 2), (1, 3);
    INSERT INTO JobSkills (JobID, SkillID) VALUES (2, 4);
END

IF (SELECT COUNT(*) FROM UserSkills) = 0
BEGIN
    INSERT INTO UserSkills (UserID, SkillID) VALUES (1, 1), (1, 2), (1, 3), (1, 5);
    INSERT INTO UserSkills (UserID, SkillID) VALUES (2, 4), (2, 5);
END

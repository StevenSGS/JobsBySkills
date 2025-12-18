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
    AuthorID INT,
    PublishedDate DATETIME DEFAULT GETDATE(),
    Excerpt TEXT,
    Content TEXT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AuthorID) REFERENCES Users(UserID) ON DELETE CASCADE
);

IF (SELECT COUNT(*) FROM Skills) = 0
BEGIN
    INSERT INTO Skills (SkillName) VALUES 
    ('JavaScript'), ('Python'), ('React'), ('Vue.js'), ('Node.js'), ('SQL'), ('Diseño UX/UI'), ('Marketing Digital'), ('Project Management'), ('HTML'), ('CSS'), ('API REST'), ('Express'), ('MongoDB'), ('Docker'), ('AWS'), ('Figma'), ('Sketch'), ('UX Research'), ('Prototipado'), ('Excel'), ('Power BI'), ('SEO'), ('SEM'), ('Redes Sociales'), ('Google Analytics'), ('Git'), ('Cypress'), ('Jest'), ('CI/CD'), ('Logística'), ('Gestión de Rutas'), ('Photoshop'), ('Illustrator'), ('Google Ads'), ('Analytics'), ('Microservicios'), ('Diseño de Interacción'), ('Diseño Web'), ('Angular'), ('TypeScript'), ('Java'), ('Spring Boot'), ('Kotlin'), ('Swift'), ('iOS Development'), ('Android Development'), ('C#'), ('.NET'), ('Ruby on Rails'), ('PHP'), ('Laravel'), ('Go'), ('Rust'), ('Scala'), ('Kubernetes'), ('Terraform'), ('Azure'), ('Google Cloud Platform'), ('DevOps'), ('Jenkins'), ('Ansible'), ('Puppet'), ('Chef'), ('Splunk'), ('Tableau'), ('Qlik Sense'), ('Looker'), ('Data Warehousing'), ('ETL'), ('Big Data'), ('Hadoop'), ('Spark'), ('Machine Learning'), ('Deep Learning'), ('Natural Language Processing'), ('Computer Vision'), ('TensorFlow'), ('PyTorch'), ('Keras'), ('Scikit-learn'), ('Cybersecurity'), ('Penetration Testing'), ('Ethical Hacking'), ('Network Security'), ('Cloud Security'), ('Blockchain'), ('Solidity'), ('Smart Contracts'), ('Cryptocurrency'), ('Game Development'), ('Unity'), ('Unreal Engine'), ('C++'), ('3D Modeling'), ('Blender'), ('Autodesk Maya'), ('Motion Graphics'), ('After Effects'), ('Premiere Pro'), ('Video Editing'), ('Copywriting'), ('Content Strategy'), ('Email Marketing'), ('Marketing Automation'), ('HubSpot'), ('Salesforce'), ('CRM Management'), ('Customer Service'), ('Zendesk'), ('Intercom'), ('Technical Support'), ('ITIL'), ('Agile Methodologies'), ('Scrum'), ('Kanban'), ('Jira'), ('Confluence'), ('Product Management'), ('Market Research'), ('Competitive Analysis'), ('A/B Testing'), ('Financial Analysis'), ('Accounting'), ('Bookkeeping'), ('QuickBooks'), ('SAP'), ('Oracle'), ('Human Resources'), ('Recruiting'), ('Talent Acquisition'), ('Employee Relations'), ('Performance Management'), ('Legal Research'), ('Contract Law'), ('Corporate Law'), ('Intellectual Property'), ('Healthcare Management'), ('Medical Billing'), ('Electronic Health Records (EHR)'), ('HIPAA'), ('Nursing'), ('Patient Care'), ('Pharmacology'), ('Biotechnology'), ('Genetics'), ('Bioinformatics'), ('Lab Research'), ('Quality Assurance'), ('Six Sigma'), ('Lean Manufacturing'), ('Supply Chain Management'), ('Inventory Management'), ('E-commerce'), ('Shopify'), ('Magento'), ('WooCommerce'), ('Sales'), ('Lead Generation'), ('Negotiation'), ('Public Speaking'), ('Data Entry'), ('Microsoft Office Suite'), ('Google Workspace'), ('Communication Skills'), ('Teamwork'), ('Problem Solving'), ('Critical Thinking'), ('Adaptability'), ('Time Management'), ('Leadership'), ('Emotional Intelligence'), ('Creativity'), ('Attention to Detail'), ('Mechanical Engineering'), ('CAD'), ('SolidWorks'), ('AutoCAD'), ('Electrical Engineering'), ('Circuit Design'), ('MATLAB'), ('Simulink'), ('Civil Engineering'), ('Structural Analysis'), ('Architecture'), ('Revit'), ('Industrial Design'), ('User-centered Design'), ('Writing'), ('Editing'), ('Translation'), ('Spanish'), ('French'), ('German'), ('Mandarin Chinese'), ('Japanese'), ('Customer Relationship Management'), ('Enterprise Resource Planning'), ('Business Intelligence'), ('Photography'), ('Art Direction'), ('Brand Strategy'), ('Public Relations'), ('Event Planning'), ('Social Media Management'), ('Content Marketing'), ('Webflow'), ('Wordpress'), ('Drupal'), ('Squarespace'), ('Wix'), ('Statistical Analysis'), ('R'), ('SPSS'), ('SAS'), ('Quantum Computing'), ('Robotics'), ('Automation'), ('Internet of Things (IoT)'), ('Embedded Systems'), ('Firmware'), ('VHDL'), ('Verilog'), ('System Administration'), ('Linux'), ('Windows Server'), ('Shell Scripting'), ('PowerShell'), ('Database Administration'), ('MySQL'), ('PostgreSQL'), ('Microsoft SQL Server'), ('Oracle DB'), ('GraphQL'), ('Apollo'), ('Relay'), ('WebSockets'), ('gRPC'), ('Digital Painting'), ('Concept Art'), ('Storyboarding'), ('Animation'), ('Sound Design'), ('Music Production'), ('Ableton Live'), ('Logic Pro X'), ('FL Studio'), ('Journalism'), ('Technical Writing'), ('Grant Writing'), ('Scientific Writing'), ('UX Writing'), ('Microcopy'), ('Chatbot Design'), ('Voice User Interface (VUI) Design'), ('Amazon Alexa Skills'), ('Google Assistant Actions'), ('Virtual Reality (VR)'), ('Augmented Reality (AR)'), ('Web3.js'), ('Ethers.js'), ('Data Visualization'), ('D3.js'), ('Three.js'), ('Babylon.js'), ('A-Frame'), ('Cloud Architecture');
END

IF (SELECT COUNT(*) FROM Users) = 0
BEGIN
    INSERT INTO Users (FirstName, LastName, Email, Password) VALUES 
    ('Admin', 'Root', 'admin', 'admin'), ('Bryan', 'Ramirez', 'bryan.ramirez@example.com', '12345678'), ('Juan', 'Perez', 'juan.perez@example.com', '12345678'), ('Javier', 'Martín', 'javier.martin@jobsbyskills.com', '12345678'), ('Sofía', 'López', 'sofia.lopez@jobsbyskills.com', '12345678'), ('Carlos', 'Ruiz', 'carlos.ruiz@jobsbyskills.com', '12345678'), ('Ana', 'García', 'ana.garcia@jobsbyskills.com', '12345678'), ('Elena', 'Gomez', 'elena.gomez@example.com', 'password123'), ('Mateo', 'Diaz', 'mateo.diaz@example.com', 'password123'), ('Valentina', 'Reyes', 'valentina.reyes@example.com', 'password123'), ('Sebastian', 'Castillo', 'sebastian.castillo@example.com', 'password123'), ('Isabella', 'Morales', 'isabella.morales@example.com', 'password123'), ('Lucas', 'Ortega', 'lucas.ortega@example.com', 'password123'), ('Camila', 'Gutierrez', 'camila.gutierrez@example.com', 'password123'), ('Daniel', 'Soto', 'daniel.soto@example.com', 'password123'), ('Gabriela', 'Navarro', 'gabriela.navarro@example.com', 'password123'), ('Martin', 'Castro', 'martin.castro@example.com', 'password123'), ('Lucia', 'Acosta', 'lucia.acosta@example.com', 'password123'), ('Diego', 'Rojas', 'diego.rojas@example.com', 'password123'), ('Valeria', 'Medina', 'valeria.medina@example.com', 'password123'), ('Nicolas', 'Paredes', 'nicolas.paredes@example.com', 'password123'), ('Julieta', 'Vargas', 'julieta.vargas@example.com', 'password123'), ('Matias', 'Flores', 'matias.flores@example.com', 'password123'), ('Renata', 'Campos', 'renata.campos@example.com', 'password123'), ('Emiliano', 'Vega', 'emiliano.vega@example.com', 'password123'), ('Antonella', 'Mendez', 'antonella.mendez@example.com', 'password123'), ('Leonardo', 'Juarez', 'leonardo.juarez@example.com', 'password123'), ('Adriana', 'Salazar', 'adriana.salazar@example.com', 'password123'), ('Ricardo', 'Cabrera', 'ricardo.cabrera@example.com', 'password123'), ('Paula', 'Herrera', 'paula.herrera@example.com', 'password123'), ('Felipe', 'Molina', 'felipe.molina@example.com', 'password123'), ('Daniela', 'Rios', 'daniela.rios@example.com', 'password123'), ('Andres', 'Silva', 'andres.silva@example.com', 'password123'), ('Catalina', 'Guerrero', 'catalina.guerrero@example.com', 'password123'), ('David', 'Pena', 'david.pena@example.com', 'password123'), ('Mariana', 'Leon', 'mariana.leon@example.com', 'password123'), ('Joaquin', 'Gallardo', 'joaquin.gallardo@example.com', 'password123'), ('Alejandro', 'Torres', 'alejandro.torres@example.com', 'password123'), ('Sofia', 'Vidal', 'sofia.vidal@example.com', 'password123'), ('Benjamin', 'Solis', 'benjamin.solis@example.com', 'password123'), ('Clara', 'Fuentes', 'clara.fuentes@example.com', 'password123'), ('Fabián', 'Garrido', 'fabian.garrido@example.com', 'password123'), ('Isidora', 'Bravo', 'isidora.bravo@example.com', 'password123'), ('Gustavo', 'Miranda', 'gustavo.miranda@example.com', 'password123'), ('Ximena', 'Pizarro', 'ximena.pizarro@example.com', 'password123'), ('Tomás', 'Araya', 'tomas.araya@example.com', 'password123'), ('Olivia', 'Figueroa', 'olivia.figueroa@example.com', 'password123'), ('Vicente', 'Tapia', 'vicente.tapia@example.com', 'password123'), ('Amelia', 'Espinoza', 'amelia.espinoza@example.com', 'password123'), ('Maximiliano', 'Sandoval', 'maximiliano.sandoval@example.com', 'password123'), ('Emilia', 'Carrasco', 'emilia.carrasco@example.com', 'password123'), ('Agustín', 'Jara', 'agustin.jara@example.com', 'password123'), ('Florencia', 'Valenzuela', 'florencia.valenzuela@example.com', 'password123'), ('Cristóbal', 'Riquelme', 'cristobal.riquelme@example.com', 'password123'), ('Antonia', 'Delgado', 'antonia.delgado@example.com', 'password123'), ('Gaspar', 'Salas', 'gaspar.salas@example.com', 'password123'), ('Amanda', 'Bustos', 'amanda.bustos@example.com', 'password123'), ('Laura', 'Jimenez', 'laura.jimenez@test.com', 'pass'), ('Pablo', 'Alvarez', 'pablo.alvarez@test.com', 'pass'), ('Carmen', 'Moreno', 'carmen.moreno@test.com', 'pass'), ('Adrian', 'Gil', 'adrian.gil@test.com', 'pass'), ('Raquel', 'Serrano', 'raquel.serrano@test.com', 'pass'), ('Ivan', 'Blanco', 'ivan.blanco@test.com', 'pass'), ('Beatriz', 'Suarez', 'beatriz.suarez@test.com', 'pass'), ('Jorge', 'Moya', 'jorge.moya@test.com', 'pass'), ('Alba', 'Pascual', 'alba.pascual@test.com', 'pass'), ('Sergio', 'Santos', 'sergio.santos@test.com', 'pass'), ('Irene', 'Calvo', 'irene.calvo@test.com', 'pass'), ('Manuel', 'Gallego', 'manuel.gallego@test.com', 'pass'), ('Natalia', 'Vazquez', 'natalia.vazquez@test.com', 'pass'), ('Francisco', 'Lorenzo', 'francisco.lorenzo@test.com', 'pass'), ('Eva', 'Montero', 'eva.montero@test.com', 'pass'), ('Miguel', 'Hidalgo', 'miguel.hidalgo@test.com', 'pass'), ('Silvia', 'Gimenez', 'silvia.gimenez@test.com', 'pass'), ('Alberto', 'Ferrer', 'alberto.ferrer@test.com', 'pass'), ('Lorena', 'Duran', 'lorena.duran@test.com', 'pass'), ('Raul', 'Vicente', 'raul.vicente@test.com', 'pass'), ('Marta', 'Benitez', 'marta.benitez@test.com', 'pass'), ('Javier', 'Arias', 'javier.arias@test.com', 'pass'), ('Cristina', 'Mora', 'cristina.mora@test.com', 'pass'), ('Daniel', 'Herrero', 'daniel.herrero@test.com', 'pass'), ('Nuria', 'Pardo', 'nuria.pardo@test.com', 'pass'), ('Ruben', 'Aguilar', 'ruben.aguilar@test.com', 'pass'), ('Pilar', 'Esteban', 'pilar.esteban@test.com', 'pass'), ('Angel', 'Cortes', 'angel.cortes@test.com', 'pass'), ('Sara', 'Peña', 'sara.pena@test.com', 'pass'), ('Victor', 'Roldan', 'victor.roldan@test.com', 'pass'), ('Rosa', 'Izquierdo', 'rosa.izquierdo@test.com', 'pass'), ('Jesus', 'Marin', 'jesus.marin@test.com', 'pass'), ('Esther', 'Blazquez', 'esther.blazquez@test.com', 'pass'), ('Oscar', 'Soriano', 'oscar.soriano@test.com', 'pass'), ('Veronica', 'Crespo', 'veronica.crespo@test.com', 'pass'), ('Guillermo', 'Roman', 'guillermo.roman@test.com', 'pass'), ('Teresa', 'Mas', 'teresa.mas@test.com', 'pass'), ('Antonio', 'Vila', 'antonio.vila@test.com', 'pass'), ('Monica', 'Escudero', 'monica.escudero@test.com', 'pass'), ('Fernando', 'Reyes', 'fernando.reyes@test.com', 'pass'), ('Rosario', 'Galvan', 'rosario.galvan@test.com', 'pass'), ('Jaime', 'Peralta', 'jaime.peralta@test.com', 'pass'), ('Manuela', 'Samper', 'manuela.samper@test.com', 'pass'), ('Ignacio', 'Requena', 'ignacio.requena@test.com', 'pass'), ('Lourdes', 'Menendez', 'lourdes.menendez@test.com', 'pass'), ('Hector', 'Cid', 'hector.cid@test.com', 'pass'), ('Consuelo', 'Belmonte', 'consuelo.belmonte@test.com', 'pass'), ('Joaquin', 'Roca', 'joaquin.roca@test.com', 'pass'), ('Inmaculada', 'Ballesteros', 'inmaculada.ballesteros@test.com', 'pass'), ('Alfredo', 'Ochoa', 'alfredo.ochoa@test.com', 'pass'), ('Mercedes', 'Aranda', 'mercedes.aranda@test.com', 'pass'), ('Felix', 'Valle', 'felix.valle@test.com', 'pass'), ('Yolanda', 'Gamez', 'yolanda.gamez@test.com', 'pass'), ('Marcos', 'Pla', 'marcos.pla@test.com', 'pass'), ('Rocio', 'Collado', 'rocio.collado@test.com', 'pass'), ('Santiago', 'Puig', 'santiago.puig@test.com', 'pass'), ('Amparo', 'Bueno', 'amparo.bueno@test.com', 'pass'), ('Julian', 'Guillen', 'julian.guillen@test.com', 'pass'), ('Gloria', 'Saez', 'gloria.saez@test.com', 'pass'), ('Cesar', 'Sola', 'cesar.sola@test.com', 'pass'), ('Noelia', 'Villa', 'noelia.villa@test.com', 'pass'), ('Emilio', 'Adan', 'emilio.adan@test.com', 'pass'), ('Alicia', 'Cases', 'alicia.cases@test.com', 'pass'), ('Julio', 'Prats', 'julio.prats@test.com', 'pass'), ('Asuncion', 'Camacho', 'asuncion.camacho@test.com', 'pass'), ('Gabriel', 'Saavedra', 'gabriel.saavedra@test.com', 'pass'), ('Elena', 'Montes', 'elena.montes@test.com', 'pass'), ('Enrique', 'Barros', 'enrique.barros@test.com', 'pass'), ('Angela', 'Godoy', 'angela.godoy@test.com', 'pass'), ('Ramon', 'Carrion', 'ramon.carrion@test.com', 'pass'), ('Isabel', 'Prado', 'isabel.prado@test.com', 'pass'), ('Vicente', 'Rico', 'vicente.rico@test.com', 'pass'), ('Josefina', 'Amador', 'josefina.amador@test.com', 'pass'), ('Luis', 'Soria', 'luis.soria@test.com', 'pass'), ('Catalina', 'Pons', 'catalina.pons@test.com', 'pass'), ('Domingo', 'Aragon', 'domingo.aragon@test.com', 'pass'), ('Dolores', 'Macias', 'dolores.macias@test.com', 'pass'), ('Aitor', 'Exposito', 'aitor.exposito@test.com', 'pass'), ('Lidia', 'Barba', 'lidia.barba@test.com', 'pass'), ('Juanjo', 'Mesa', 'juanjo.mesa@test.com', 'pass'), ('Felicidad', 'Barroso', 'felicidad.barroso@test.com', 'pass'), ('Borja', 'Reyes', 'borja.reyes@test.com', 'pass'), ('Milagros', 'Quintana', 'milagros.quintana@test.com', 'pass'), ('Eugenio', 'Montoya', 'eugenio.montoya@test.com', 'pass'), ('Nerea', 'Marrero', 'nerea.marrero@test.com', 'pass'), ('Sebastian', 'Acosta', 'sebastian.acosta@test.com', 'pass'), ('Marina', 'Soler', 'marina.soler@test.com', 'pass'), ('Ramiro', 'Campos', 'ramiro.campos@test.com', 'pass'), ('Ainhoa', 'Robles', 'ainhoa.robles@test.com', 'pass'), ('Mateo', 'Fuentes', 'mateo.fuentes@test.com', 'pass'), ('Elvira', 'Castillo', 'elvira.castillo@test.com', 'pass'), ('Arturo', 'Iglesias', 'arturo.iglesias@test.com', 'pass'), ('Blanca', 'Medina', 'blanca.medina@test.com', 'pass'), ('Moises', 'Corona', 'moises.corona@test.com', 'pass'), ('Caridad', 'Villanueva', 'caridad.villanueva@test.com', 'pass'), ('Gregorio', 'Contreras', 'gregorio.contreras@test.com', 'pass'), ('Adela', 'Ramos', 'adela.ramos@test.com', 'pass'), ('Aaron', 'Pereira', 'aaron.pereira@test.com', 'pass'), ('Ona', 'Guerra', 'ona.guerra@test.com', 'pass'), ('Hernan', 'Fajardo', 'hernan.fajardo@test.com', 'pass'), ('Adoracion', 'Valero', 'adoracion.valero@test.com', 'pass'), ('Hugo', 'Navas', 'hugo.navas@test.com', 'pass'), ('Amaya', 'Cabrera', 'amaya.cabrera@test.com', 'pass'), ('Iker', 'Mendez', 'iker.mendez@test.com', 'pass'), ('Jimena', 'Rojas', 'jimena.rojas@test.com', 'pass'), ('Unai', 'Duarte', 'unai.duarte@test.com', 'pass'), ('Chloe', 'Vera', 'chloe.vera@test.com', 'pass'), ('Gael', 'Abad', 'gael.abad@test.com', 'pass'), ('Abril', 'Guzman', 'abril.guzman@test.com', 'pass'), ('Thiago', 'Jurado', 'thiago.jurado@test.com', 'pass'), ('Aitana', 'Pineda', 'aitana.pineda@test.com', 'pass'), ('Enzo', 'Correa', 'enzo.correa@test.com', 'pass'), ('Alma', 'Valdivia', 'alma.valdivia@test.com', 'pass'), ('Adam', 'Soto', 'adam.soto@test.com', 'pass'), ('Triana', 'Luna', 'triana.luna@test.com', 'pass'), ('Marco', 'Puga', 'marco.puga@test.com', 'pass'), ('Lola', 'Gallardo', 'lola.gallardo@test.com', 'pass'), ('Leo', 'Sampedro', 'leo.sampedro@test.com', 'pass'), ('Candela', 'Osorio', 'candela.osorio@test.com', 'pass'), ('Dylan', 'Casanova', 'dylan.casanova@test.com', 'pass'), ('Vera', 'Bernal', 'vera.bernal@test.com', 'pass'), ('Alex', 'Maldonado', 'alex.maldonado@test.com', 'pass'), ('India', 'Canto', 'india.canto@test.com', 'pass'), ('Bruno', 'Valcarcel', 'bruno.valcarcel@test.com', 'pass'), ('Luca', 'Toro', 'luca.toro@test.com', 'pass'), ('Elias', 'Patiño', 'elias.patiño@test.com', 'pass'), ('Erik', 'Pantoja', 'erik.pantoja@test.com', 'pass'), ('Joel', 'Dueñas', 'joel.dueñas@test.com', 'pass'), ('Pau', 'Montesinos', 'pau.montesinos@test.com', 'pass'), ('Jan', 'Maya', 'jan.maya@test.com', 'pass'), ('Liam', 'Vaca', 'liam.vaca@test.com', 'pass'), ('Saul', 'Cea', 'saul.cea@test.com', 'pass'), ('Diego', 'Holgado', 'diego.holgado@test.com', 'pass'), ('Noah', 'Ojeda', 'noah.ojeda@test.com', 'pass'), ('Hector', 'Pelaez', 'hector.pelaez@test.com', 'pass'), ('Adria', 'Baro', 'adria.baro@test.com', 'pass'), ('Biel', 'Reyes', 'biel.reyes@test.com', 'pass'), ('Mohamed', 'Alonso', 'mohamed.alonso@test.com', 'pass'), ('Pol', 'Cabello', 'pol.cabello@test.com', 'pass'), ('Izan', 'Gallardo', 'izan.gallardo@test.com', 'pass'), ('Nil', 'Puerta', 'nil.puerta@test.com', 'pass'), ('Arnau', 'Rivas', 'arnau.rivas@test.com', 'pass'), ('Eric', 'Tellez', 'eric.tellez@test.com', 'pass'), ('Marc', 'Rojo', 'marc.rojo@test.com', 'pass'), ('Teo', 'Plaza', 'teo.plaza@test.com', 'pass'), ('Anas', 'Amor', 'anas.amor@test.com', 'pass'), ('Rayan', 'Pintor', 'rayan.pintor@test.com', 'pass'), ('Amir', 'Mata', 'amir.mata@test.com', 'pass'), ('Omar', 'Márquez', 'omar.marquez@test.com', 'pass'), ('Youssef', 'Carrasco', 'youssef.carrasco@test.com', 'pass'), ('Bilal', 'Paez', 'bilal.paez@test.com', 'pass'), ('Imran', 'Hurtado', 'imran.hurtado@test.com', 'pass'), ('Abel', 'Cabrera', 'abel.cabrera@test.com', 'pass'), ('Ander', 'Valero', 'ander.valero@test.com', 'pass'), ('Benito', 'Rendon', 'benito.rendon@test.com', 'pass'), ('Bernat', 'Moya', 'bernat.moya@test.com', 'pass'), ('Carles', 'Siles', 'carles.siles@test.com', 'pass'), ('Dario', 'Triana', 'dario.triana@test.com', 'pass'), ('Didac', 'Barrio', 'didac.barrio@test.com', 'pass'), ('Eloy', 'Lara', 'eloy.lara@test.com', 'pass'), ('Fermin', 'Lama', 'fermin.lama@test.com', 'pass'), ('Gorka', 'Polo', 'gorka.polo@test.com', 'pass'), ('Guifre', 'Pina', 'guifre.pina@test.com', 'pass'), ('Ian', 'Garriga', 'ian.garriga@test.com', 'pass'), ('Jon', 'Perea', 'jon.perea@test.com', 'pass'), ('Josep', 'Egea', 'josep.egea@test.com', 'pass'), ('Kai', 'Milla', 'kai.milla@test.com', 'pass'), ('Lluc', 'Mesa', 'lluc.mesa@test.com', 'pass'), ('Lois', 'Raya', 'lois.raya@test.com', 'pass'), ('Marti', 'Vallejo', 'marti.vallejo@test.com', 'pass'), ('Max', 'Cobo', 'max.cobo@test.com', 'pass'), ('Mikel', 'Patiño', 'mikel.patiño@test.com', 'pass'), ('Nacho', 'Carrion', 'nacho.carrion@test.com', 'pass'), ('Nel', 'Mena', 'nel.mena@test.com', 'pass'), ('Pep', 'Rojo', 'pep.rojo@test.com', 'pass'), ('Quim', 'Tejera', 'quim.tejera@test.com', 'pass'), ('Roger', 'Bonilla', 'roger.bonilla@test.com', 'pass'), ('Xavi', 'Rojo', 'xavi.rojo@test.com', 'pass'), ('Yerai', 'Coronado', 'yerai.coronado@test.com', 'pass'), ('Aleix', 'Pantoja', 'aleix.pantoja@test.com', 'pass');
END

IF (SELECT COUNT(*) FROM Companies) = 0
BEGIN
    INSERT INTO Companies (CompanyName, Email, Password, Location, Industry) VALUES
    ('Innovatech Solutions', 'contact@innovatech.com', 'pass123', 'San Francisco, CA', 'Technology'),
    ('Creative Minds Agency', 'hello@creativeminds.com', 'pass123', 'New York, NY', 'Marketing'),
    ('Quantum Logistics', 'info@quantumlogistics.com', 'pass123', 'Houston, TX', 'Logistics & Supply Chain'),
    ('Healthwise Medical', 'hr@healthwise.com', 'pass123', 'Boston, MA', 'Healthcare');
END

IF (SELECT COUNT(*) FROM Jobs) = 0
BEGIN
    INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, Location, Status) VALUES
    (1, 'Desarrollador Frontend (React)', 'Buscamos un desarrollador frontend con experiencia en React para construir interfaces de usuario modernas y receptivas.', 'Remoto', 'Activa'),
    (1, 'Desarrollador Backend (Node.js)', 'Únete a nuestro equipo de backend para diseñar y construir APIs RESTful robustas y escalables con Node.js y Express.', 'San Francisco, CA', 'Activa'),
    (2, 'Especialista en Marketing Digital', 'Responsable de la estrategia y ejecución de campañas de marketing digital, incluyendo SEO, SEM y redes sociales.', 'New York, NY', 'Activa'),
    (2, 'Diseñador UX/UI', 'Buscamos un diseñador talentoso para crear experiencias de usuario intuitivas y atractivas para nuestras aplicaciones web y móviles.', 'Remoto', 'Cerrada'),
    (1, 'Ingeniero de DevOps', 'Implementar y mantener nuestra infraestructura de CI/CD, asegurando despliegues rápidos y confiables.', 'San Francisco, CA', 'Activa'),
    (3, 'Gerente de Operaciones Logísticas', 'Supervisar y optimizar nuestras operaciones de la cadena de suministro para garantizar la eficiencia y la entrega a tiempo.', 'Houston, TX', 'Activa'),
    (4, 'Enfermero/a Registrado/a', 'Proporcionar atención de alta calidad a los pacientes en nuestro centro médico de última generación.', 'Boston, MA', 'Activa'),
    (1, 'Científico de Datos', 'Analizar grandes conjuntos de datos para extraer insights valiosos y construir modelos de machine learning.', 'Remoto', 'Activa'),
    (2, 'Creador de Contenido', 'Producir contenido atractivo y relevante para nuestro blog y redes sociales.', 'New York, NY', 'Activa'),
    (1, 'Desarrollador Full-Stack', 'Buscamos un desarrollador versátil para trabajar tanto en el frontend como en el backend de nuestras aplicaciones.', 'San Francisco, CA', 'Activa'),
    (3, 'Coordinador de Almacén', 'Gestionar el inventario y coordinar la recepción y envío de mercancías en nuestro almacén.', 'Houston, TX', 'Activa'),
    (4, 'Asistente Médico', 'Apoyar a los médicos y enfermeras en la atención al paciente y tareas administrativas.', 'Boston, MA', 'Activa'),
    (1, 'Ingeniero de Software (Python)', 'Desarrollar y mantener aplicaciones de backend utilizando Python y Django.', 'Remoto', 'Activa'),
    (2, 'Estratega de Marca', 'Definir y comunicar la voz y el posicionamiento de nuestra marca en el mercado.', 'Remoto', 'Activa'),
    (1, 'QA Tester Automatizado', 'Crear y ejecutar scripts de prueba automatizados para garantizar la calidad de nuestro software.', 'San Francisco, CA', 'Activa'),
    (3, 'Analista de Cadena de Suministro', 'Analizar datos de la cadena de suministro para identificar áreas de mejora y optimización de costos.', 'Houston, TX', 'Activa'),
    (4, 'Recepcionista Médico', 'Gestionar citas, registrar pacientes y realizar tareas administrativas en un entorno clínico.', 'Boston, MA', 'Activa'),
    (1, 'Product Manager', 'Definir la hoja de ruta del producto y colaborar con los equipos de diseño e ingeniería para su ejecución.', 'San Francisco, CA', 'Activa'),
    (2, 'Manager de Redes Sociales', 'Gestionar nuestras comunidades online y crear estrategias de contenido para aumentar el engagement.', 'New York, NY', 'Activa'),
    (1, 'Arquitecto de Soluciones en la Nube (AWS)', 'Diseñar y supervisar la implementación de soluciones escalables y seguras en AWS.', 'Remoto', 'Activa'),
    (3, 'Planificador de Rutas', 'Diseñar rutas de entrega eficientes para nuestra flota de vehículos.', 'Houston, TX', 'Activa'),
    (4, 'Técnico de Laboratorio Clínico', 'Realizar análisis y pruebas de laboratorio para ayudar en el diagnóstico y tratamiento de pacientes.', 'Boston, MA', 'Activa'),
    (1, 'Desarrollador Móvil (iOS)', 'Desarrollar y mantener nuestra aplicación para iOS utilizando Swift y SwiftUI.', 'Remoto', 'Activa'),
    (2, 'Analista de SEO', 'Realizar análisis de palabras clave y optimizar nuestro sitio web para mejorar el ranking en los motores de búsqueda.', 'New York, NY', 'Activa'),
    (1, 'Ingeniero de Datos', 'Construir y mantener pipelines de datos para asegurar la disponibilidad y calidad de la información.', 'San Francisco, CA', 'Activa'),
    (3, 'Especialista en Aduanas', 'Asegurar el cumplimiento de todas las regulaciones aduaneras para importaciones y exportaciones.', 'Houston, TX', 'Activa');
END

IF (SELECT COUNT(*) FROM UserSkills) = 0
BEGIN
    INSERT INTO UserSkills (UserID, SkillID) VALUES
    (58, 2), (58, 6), (58, 35), (59, 41), (59, 42), (59, 43),
    (60, 8), (60, 25), (60, 68), (61, 71), (61, 72), (61, 73),
    (62, 9), (62, 81), (62, 82), (63, 101), (63, 102), (63, 103),
    (64, 115), (64, 116), (64, 117), (65, 131), (65, 132), (65, 133),
    (66, 140), (66, 141), (66, 150), (67, 151), (67, 152), (67, 160),
    (68, 161), (68, 162), (69, 170), (69, 171), (70, 180), (70, 181),
    (71, 190), (71, 191), (72, 200), (72, 201), (73, 210), (73, 211),
    (74, 220), (74, 221), (75, 1), (75, 3), (76, 5), (76, 13),
    (77, 7), (77, 17), (78, 9), (78, 80), (79, 21), (79, 22),
    (80, 23), (80, 24), (81, 30), (81, 31), (82, 44), (82, 45),
    (83, 50), (83, 51), (84, 60), (84, 61), (85, 70), (85, 71);
END

IF (SELECT COUNT(*) FROM BlogPosts) = 0
BEGIN
    INSERT INTO BlogPosts (Title, AuthorID, PublishedDate, Excerpt, Content) VALUES
    ('Gestión de Proyectos para No-Managers: Principios de Éxito', 9, '2026-01-10', 'No necesitas ser un manager para gestionar proyectos. Aprende los fundamentos de la organización, planificación y ejecución.', '<p>La gestión de proyectos es una habilidad, no un cargo. Cualquiera puede beneficiarse de sus principios para organizar su trabajo y lograr sus metas. Se trata de definir un objetivo claro, dividirlo en tareas manejables y seguir el progreso.</p><h4>Fases Clave</h4><ol><li><strong>Iniciación:</strong> Define el qué y el porqué. ¿Cuál es el objetivo? ¿Quiénes son los interesados?</li><li><strong>Planificación:</strong> Crea una hoja de ruta. Define las tareas, estima los tiempos y asigna recursos. Herramientas como Trello o Asana son excelentes para esto.</li><li><strong>Ejecución:</strong> ¡Manos a la obra! Mantén la comunicación fluida con tu equipo y monitoriza el progreso.</li><li><strong>Cierre:</strong> Entrega el resultado final, evalúa qué salió bien y qué se puede mejorar para la próxima vez.</li></ol><p>Adoptar un enfoque estructurado, incluso para proyectos personales, puede aumentar drásticamente tus posibilidades de éxito.</p>'),
    ('La Psicología del Color en el Diseño de Interfaces', 10, '2026-01-15', 'Los colores evocan emociones y guían la atención del usuario. Aprende a usar la paleta de colores de forma estratégica en tus diseños.', '<p>El color es una de las herramientas más poderosas en el arsenal de un diseñador. No se trata solo de estética; el color comunica significado, jerarquía y emoción.</p><ul><li><strong>Azul:</strong> Confianza, calma, profesionalismo. Muy usado en banca y tecnología.</li><li><strong>Rojo:</strong> Urgencia, pasión, peligro. Ideal para llamadas a la acción (CTAs) o notificaciones importantes.</li><li><strong>Verde:</strong> Naturaleza, crecimiento, éxito. Se asocia con la positividad y la confirmación.</li><li><strong>Amarillo:</strong> Optimismo, advertencia, atención. Úsalo con moderación para destacar elementos clave.</li></ul><p>Una paleta de colores coherente y accesible (¡no olvides el contraste para la legibilidad!) es fundamental para una buena experiencia de usuario.</p>'),
    ('Introducción a la Impresión 3D para Creativos y Makers', 42, '2026-01-20', 'La impresión 3D ha dejado de ser una tecnología de nicho para convertirse en una herramienta accesible para todos. Te contamos cómo empezar.', '<p>La impresión 3D, o fabricación aditiva, te permite convertir un modelo digital en un objeto físico, capa por capa. Las posibilidades son infinitas: prototipos de productos, figuras personalizadas, piezas de repuesto, herramientas, y mucho más.</p><h3>Tipos de Impresoras</h3><p>La más común para principiantes es la FDM (Modelado por deposición fundida), que funciona derritiendo un filamento de plástico (como PLA o ABS) y depositándolo en capas. Otras tecnologías como SLA (estereolitografía) usan una resina líquida que se solidifica con luz UV, logrando un nivel de detalle mucho mayor.</p><h3>Tu Primer Proyecto</h3><ol><li><strong>Consigue un modelo 3D:</strong> Puedes diseñarlo tú mismo con software como Tinkercad (muy fácil) o Blender (más avanzado), o descargar millones de modelos gratuitos de sitios como Thingiverse.</li><li><strong>Prepara el modelo (Slicing):</strong> Un software "slicer" como Cura o PrusaSlicer convierte tu modelo 3D en instrucciones que la impresora puede entender (el G-code).</li><li><strong>Imprime:</strong> Envía el archivo a tu impresora y ¡mira cómo la magia sucede!</li></ol>'),
    ('Cómo Construir una Marca Personal Auténtica como Profesional Tech', 25, '2026-01-25', 'Tu marca personal es la historia que la gente cuenta sobre ti cuando no estás en la sala. Aprende a construirla de forma intencional.', '<p>En el competitivo mundo de la tecnología, tus habilidades técnicas son solo una parte de la ecuación. Una marca personal sólida puede abrirte puertas a nuevas oportunidades, colaboraciones y roles de liderazgo.</p><h4>Claves para una Marca Auténtica</h4><ul><li><strong>Encuentra tu Nicho:</strong> ¿Qué te apasiona? ¿En qué área única puedes aportar valor? No intentes ser un experto en todo.</li><li><strong>Crea y Comparte Contenido:</strong> Escribe un blog, haz videos, responde preguntas en foros, contribuye a proyectos de código abierto. Documenta tu aprendizaje y comparte tu conocimiento.</li><li><strong>Construye tu Red:</strong> Participa en comunidades online (Twitter, LinkedIn) y eventos (meetups, conferencias). No se trata de coleccionar contactos, sino de construir relaciones genuinas.</li><li><strong>Sé Consistente:</strong> Tu mensaje, tu tono y tu presencia deben ser coherentes a través de todas las plataformas.</li></ul><p>Tu marca personal no se construye de la noche a la mañana. Es un maratón de autenticidad y generosidad.</p>'),
    ('El Rol del Human-in-the-Loop en el Machine Learning', 36, '2026-02-01', 'La automatización total no siempre es la respuesta. El enfoque Human-in-the-Loop (HITL) combina la inteligencia humana y la artificial para crear sistemas más robustos.', '<p>El Machine Learning es increíblemente bueno para encontrar patrones en grandes volúmenes de datos, pero a menudo carece de sentido común o de la capacidad para manejar casos ambiguos. Ahí es donde entra en juego el "humano en el bucle".</p><p>Un sistema HITL utiliza modelos de ML para procesar la mayor parte de los datos, pero cuando el modelo tiene un bajo nivel de confianza en su predicción, deriva el problema a un humano para que tome la decisión final. La decisión del humano se utiliza luego para reentrenar y mejorar el modelo. Este ciclo de retroalimentación crea un sistema que se vuelve más inteligente con el tiempo.</p><h4>Aplicaciones Comunes</h4><ul><li><strong>Moderación de Contenido:</strong> Un modelo puede marcar contenido potencialmente inapropiado, pero un humano toma la decisión final de eliminarlo.</li><li><strong>Etiquetado de Datos:</strong> Para entrenar un modelo de Computer Vision, los humanos etiquetan las imágenes iniciales para enseñar al modelo qué buscar.</li><li><strong>Diagnóstico Médico:</strong> Un modelo puede resaltar áreas de interés en una radiografía, pero el radiólogo tiene la última palabra.</li></ul>'),
    ('Scrum vs. Kanban: ¿Qué Metodología Ágil es Mejor para tu Equipo?', 9, '2026-02-05', 'Ambas son metodologías ágiles populares, pero tienen diferencias clave. Te ayudamos a decidir cuál se adapta mejor a tu flujo de trabajo.', '<p><strong>Scrum</strong> es un framework prescriptivo que funciona en ciclos de tiempo fijos llamados "sprints" (normalmente de 2 a 4 semanas). Es ideal para proyectos con un alcance definido donde el equipo puede comprometerse a entregar un incremento de producto al final de cada sprint. Sus roles (Product Owner, Scrum Master, Equipo de Desarrollo) y ceremonias (Sprint Planning, Daily Standup, Sprint Review, Retrospective) están claramente definidos.</p><p><strong>Kanban</strong>, por otro lado, es un método más flexible enfocado en la visualización del flujo de trabajo y en la limitación del trabajo en progreso (WIP). No utiliza sprints; las tareas fluyen continuamente a través de un tablero Kanban (To Do, In Progress, Done). Es excelente para equipos que reciben trabajo de forma continua (como equipos de soporte o mantenimiento) y necesitan ser altamente reactivos a los cambios de prioridades.</p><h3>¿Cuál elegir?</h3><ul><li>Usa <strong>Scrum</strong> si tu equipo trabaja en un producto con releases planificados y puede beneficiarse de un ritmo regular y predecible.</li><li>Usa <strong>Kanban</strong> si el trabajo es más impredecible, las prioridades cambian con frecuencia y el objetivo es optimizar el flujo de entrega continua.</li></ul><p>Muchas veces, los equipos terminan usando un híbrido de ambos, conocido como "Scrumban".</p>');
END

BEGIN
    INSERT INTO Applications (UserID, JobID, Status, AppliedAt) VALUES
    (58, 1, 'Enviada', '2026-01-06'), (59, 2, 'Revisando', '2026-01-07'),
    (60, 3, 'Enviada', '2026-01-08'), (61, 4, 'Aceptada', '2026-01-09'),
    (62, 5, 'Enviada', '2026-01-10'), (63, 6, 'Rechazada', '2026-01-11'),
    (64, 7, 'Revisando', '2026-01-12'), (65, 8, 'Enviada', '2026-01-13'),
    (66, 9, 'Aceptada', '2026-01-14'), (67, 10, 'Enviada', '2026-01-15'),
    (68, 11, 'Revisando', '2026-01-16'), (69, 12, 'Enviada', '2026-01-17'),
    (70, 13, 'Revisando', '2026-01-18'), (71, 14, 'Aceptada', '2026-01-19'),
    (72, 15, 'Enviada', '2026-01-20'), (73, 16, 'Rechazada', '2026-01-21'),
    (74, 17, 'Revisando', '2026-01-22'), (75, 18, 'Enviada', '2026-01-23'),
    (76, 19, 'Aceptada', '2026-01-24'), (77, 20, 'Enviada', '2026-01-25'),
    (78, 21, 'Revisando', '2026-01-26'), (79, 22, 'Enviada', '2026-01-27'),
    (80, 23, 'Aceptada', '2026-01-28'), (81, 24, 'Rechazada', '2026-01-29'),
    (82, 25, 'Enviada', '2026-01-30'), (83, 26, 'Revisando', '2026-01-31'),
    (84, 1, 'Enviada', '2026-02-01'), (85, 2, 'Aceptada', '2026-02-02'),
    (86, 3, 'Enviada', '2026-02-03'), (87, 4, 'Rechazada', '2026-02-04'),
    (88, 5, 'Revisando', '2026-02-05'), (89, 6, 'Enviada', '2026-02-06'),
    (90, 7, 'Aceptada', '2026-02-07'), (91, 8, 'Enviada', '2026-02-08'),
    (92, 9, 'Revisando', '2026-02-09'), (93, 10, 'Enviada', '2026-02-10'),
    (94, 11, 'Rechazada', '2026-02-11'), (95, 12, 'Enviada', '2026-02-12'),
    (96, 13, 'Revisando', '2026-02-13'), (97, 14, 'Aceptada', '2026-02-14'),
    (98, 15, 'Enviada', '2026-02-15'), (99, 16, 'Revisando', '2026-02-16'),
    (100, 17, 'Enviada', '2026-02-17'), (101, 18, 'Aceptada', '2026-02-18'),
    (102, 19, 'Enviada', '2026-02-19'), (103, 20, 'Rechazada', '2026-02-20'),
    (104, 21, 'Revisando', '2026-02-21'), (105, 22, 'Enviada', '2026-02-22'),
    (106, 23, 'Aceptada', '2026-02-23'), (107, 24, 'Enviada', '2026-02-24'),
    (108, 25, 'Revisando', '2026-02-25'), (109, 26, 'Enviada', '2026-02-26'),
    (110, 1, 'Aceptada', '2026-02-27'), (111, 2, 'Enviada', '2026-02-28'),
    (112, 3, 'Revisando', '2026-03-01'), (113, 4, 'Enviada', '2026-03-02'),
    (114, 5, 'Rechazada', '2026-03-03'), (115, 6, 'Enviada', '2026-03-04'),
    (116, 7, 'Revisando', '2026-03-05'), (117, 8, 'Aceptada', '2026-03-06'),
    (118, 9, 'Enviada', '2026-03-07'), (119, 10, 'Revisando', '2026-03-08'),
    (120, 11, 'Enviada', '2026-03-09'), (121, 12, 'Aceptada', '2026-03-10'),
    (122, 13, 'Enviada', '2026-03-11'), (123, 14, 'Rechazada', '2026-03-12'),
    (124, 15, 'Revisando', '2026-03-13'), (125, 16, 'Enviada', '2026-03-14'),
    (126, 17, 'Aceptada', '2026-03-15'), (127, 18, 'Enviada', '2026-03-16'),
    (128, 19, 'Revisando', '2026-03-17'), (129, 20, 'Enviada', '2026-03-18'),
    (130, 21, 'Aceptada', '2026-03-19'), (131, 22, 'Enviada', '2026-03-20'),
    (132, 23, 'Rechazada', '2026-03-21'), (133, 24, 'Revisando', '2026-03-22'),
    (134, 25, 'Enviada', '2026-03-23'), (135, 26, 'Aceptada', '2026-03-24'),
    (136, 1, 'Enviada', '2026-03-25'), (137, 2, 'Revisando', '2026-03-26'),
    (138, 3, 'Enviada', '2026-03-27'), (139, 4, 'Aceptada', '2026-03-28'),
    (140, 5, 'Enviada', '2026-03-29'), (141, 6, 'Rechazada', '2026-03-30'),
    (142, 7, 'Revisando', '2026-03-31'), (143, 8, 'Enviada', '2026-04-01'),
    (144, 9, 'Aceptada', '2026-04-02'), (145, 10, 'Enviada', '2026-04-03'),
    (146, 11, 'Revisando', '2026-04-04'), (147, 12, 'Enviada', '2026-04-05'),
    (148, 13, 'Aceptada', '2026-04-06'), (149, 14, 'Enviada', '2026-04-07'),
    (150, 15, 'Rechazada', '2026-04-08'), (151, 16, 'Revisando', '2026-04-09'),
    (152, 17, 'Enviada', '2026-04-10'), (153, 18, 'Aceptada', '2026-04-11'),
    (154, 19, 'Enviada', '2026-04-12'), (155, 20, 'Revisando', '2026-04-13'),
    (156, 21, 'Enviada', '2026-04-14'), (157, 22, 'Aceptada', '2026-04-15'),
    (158, 23, 'Enviada', '2026-04-16'), (159, 24, 'Rechazada', '2026-04-17'),
    (160, 25, 'Revisando', '2026-04-18'), (161, 26, 'Enviada', '2026-04-19'),
    (162, 1, 'Aceptada', '2026-04-20'), (163, 2, 'Enviada', '2026-04-21'),
    (164, 3, 'Revisando', '2026-04-22'), (165, 4, 'Enviada', '2026-04-23'),
    (166, 5, 'Rechazada', '2026-04-24'), (167, 6, 'Enviada', '2026-04-25'),
    (168, 7, 'Revisando', '2026-04-26'), (169, 8, 'Aceptada', '2026-04-27'),
    (170, 9, 'Enviada', '2026-04-28'), (171, 10, 'Revisando', '2026-04-29'),
    (172, 11, 'Enviada', '2026-04-30'), (173, 12, 'Aceptada', '2026-05-01'),
    (174, 13, 'Enviada', '2026-05-02'), (175, 14, 'Rechazada', '2026-05-03'),
    (176, 15, 'Revisando', '2026-05-04'), (177, 16, 'Enviada', '2026-05-05');
END

BEGIN
    INSERT INTO BlogPosts (Title, AuthorID, PublishedDate, Excerpt, Content) VALUES
    ('El Auge del "No-Code": Programando sin Escribir Código', 60, '2026-02-10', 'Las herramientas No-Code están democratizando la creación de software. ¿Son una amenaza para los desarrolladores?', '<p>Plataformas como Webflow, Bubble y Adalo permiten a personas sin conocimientos de programación construir aplicaciones y sitios web complejos. Esto no es el fin de los programadores, sino una evolución. Libera a los desarrolladores de tareas repetitivas para que puedan enfocarse en problemas más complejos, como la arquitectura de backend, la seguridad y la lógica de negocio especializada que las herramientas no-code no pueden manejar. Para los emprendedores y pequeñas empresas, es una forma poderosa de crear un MVP (Producto Mínimo Viable) rápidamente y validar una idea en el mercado sin una gran inversión inicial.</p>'),
    ('Data Storytelling: Más Allá de los Gráficos', 4, '2026-02-15', 'Tus datos tienen una historia que contar. Aprende a construir narrativas convincentes que inspiren a la acción.', '<p>Un dashboard lleno de gráficos no sirve de nada si la audiencia no entiende qué hacer con la información. El "Data Storytelling" es el arte de combinar datos, visualizaciones y una narrativa para comunicar insights de manera efectiva. No se trata solo de presentar datos, sino de explicar qué significan y por qué son importantes. Una buena historia de datos tiene un comienzo (el problema o la pregunta), un nudo (el análisis y los hallazgos) y un desenlace (la conclusión y las recomendaciones). Es la habilidad que convierte a un analista de datos en un asesor de confianza.</p>'),
    ('La Sostenibilidad en el Desarrollo de Software ("Green Software")', 11, '2026-02-20', 'El código que escribimos consume energía. Exploramos los principios del "Green Software" para construir aplicaciones más eficientes y ecológicas.', '<p>Los centros de datos consumen una enorme cantidad de electricidad. Como desarrolladores, tenemos la responsabilidad de minimizar la huella de carbono de nuestras aplicaciones. El "Green Software" se enfoca en la eficiencia energética del código. Esto incluye optimizar algoritmos para que requieran menos poder de cómputo, elegir centros de datos que usen energías renovables, y diseñar aplicaciones que transmitan menos datos. Pequeños cambios en el código, multiplicados por millones de usuarios, pueden tener un impacto significativo en el consumo energético global.</p>'),
    ('El Metaverso: ¿La Próxima Frontera Digital o una Distopía Corporativa?', 17, '2026-02-25', 'Todos hablan del metaverso, pero ¿qué es realmente y qué implicaciones tiene para nuestro futuro digital?', '<p>El metaverso se concibe como una red interconectada de mundos virtuales 3D donde podemos socializar, trabajar y jugar. Impulsado por tecnologías como VR y AR, promete una internet más inmersiva. Sin embargo, surgen preguntas importantes: ¿quién controlará estos mundos? ¿Serán ecosistemas abiertos e interoperables o jardines vallados propiedad de unas pocas grandes corporaciones? La batalla por el futuro del metaverso es una batalla por la descentralización, la propiedad de los datos y la definición misma de nuestra identidad digital.</p>'),
    ('La Importancia de las Habilidades Blandas ("Soft Skills") en Tecnología', 6, '2026-03-01', 'Tu capacidad para programar te consigue la entrevista. Tu capacidad para comunicarte y colaborar te consigue el trabajo (y el éxito).', '<p>En un sector que valora tanto la destreza técnica, es fácil subestimar el poder de las habilidades blandas. La comunicación efectiva, el trabajo en equipo, la empatía, la resolución de conflictos y la adaptabilidad son cruciales. Un desarrollador brillante que no puede explicar sus ideas, recibir feedback o trabajar bien con otros se convierte en un cuello de botella para el equipo. Las empresas más exitosas no solo contratan a los mejores programadores, sino a las personas que hacen mejores a los demás a su alrededor.</p>'),
    ('Edge Computing: Llevando la Computación más Cerca del Usuario', 38, '2026-03-05', 'El "Edge Computing" es un nuevo paradigma que complementa a la nube, procesando datos en el borde de la red para una respuesta ultrarrápida.', '<p>En lugar de enviar todos los datos a un centro de datos centralizado en la nube para su procesamiento, el Edge Computing realiza parte de ese cálculo mucho más cerca de donde se generan los datos: en los propios dispositivos (como tu smartphone), en una puerta de enlace local o en una torre de 5G cercana. Esto es crucial para aplicaciones que requieren una latencia mínima, como los vehículos autónomos, la realidad aumentada o el IoT industrial. No reemplaza a la nube, sino que trabaja con ella, decidiendo qué datos procesar localmente y cuáles enviar para un análisis más profundo.</p>'),
    ('La Accesibilidad Web (a11y) no es una Opción, es un Requisito', 10, '2026-03-10', 'Construir sitios web y aplicaciones accesibles garantiza que todas las personas, incluidas aquellas con discapacidades, puedan usar nuestros productos.', '<p>La accesibilidad (a menudo abreviada como a11y) se trata de diseñar para la inclusión. Esto significa asegurarse de que tu sitio pueda ser navegado con un teclado, que las imágenes tengan texto alternativo para los lectores de pantalla, que los colores tengan suficiente contraste y que el contenido sea comprensible para todos. No es una característica adicional que se añade al final; es una parte fundamental del proceso de diseño y desarrollo. Construir de forma accesible no solo es lo correcto, sino que también mejora el SEO y la experiencia de usuario para todos.</p>'),
    ('El Futuro del Trabajo: ¿Híbrido, Remoto o de Vuelta a la Oficina?', 5, '2026-03-15', 'La pandemia aceleró un debate que ya estaba en marcha. Analizamos los modelos de trabajo del futuro y sus implicaciones.', '<p>El modelo de trabajo de 9 a 5 en una oficina está siendo desafiado como nunca antes. El trabajo <strong>remoto</strong> ofrece flexibilidad y acceso a talento global, pero puede dificultar la colaboración espontánea y la cultura de empresa. El modelo <strong>híbrido</strong>, donde los empleados van a la oficina unos días a la semana, busca un equilibrio, pero puede crear una división entre los que están presentes y los que no. La <strong>vuelta a la oficina</strong> es preferida por empresas que valoran la interacción cara a cara, pero puede limitar su capacidad para atraer talento. No hay una solución única; cada empresa debe encontrar el modelo que mejor se adapte a su cultura y a las necesidades de sus empleados.</p>'),
    ('DeFi 2.0: Sostenibilidad y Rendimientos Reales', 9, '2026-03-20', 'La primera ola de Finanzas Descentralizadas (DeFi) se centró en rendimientos insostenibles. DeFi 2.0 busca construir un sistema financiero más maduro y estable.', '<p>La fase inicial de DeFi se caracterizó por el "yield farming" y los altos rendimientos (APY) que a menudo eran insostenibles y estaban impulsados por la especulación. DeFi 2.0 representa un cambio hacia la construcción de protocolos con modelos de negocio reales. Esto incluye un enfoque en la "liquidez propiedad del protocolo" (Protocol Owned Liquidity), donde el protocolo posee sus propios activos en lugar de "alquilarlos" de los usuarios, creando un sistema más estable. También vemos un mayor enfoque en la gestión de riesgos, los seguros descentralizados y la creación de productos que generen ingresos a través de comisiones de uso real, no solo de la emisión de tokens.</p>'),
    ('GraphQL vs. REST: Una Comparación Detallada', 2, '2026-03-25', 'Ambos son estándares para construir APIs, pero ofrecen enfoques muy diferentes. ¿Cuál deberías usar para tu próximo proyecto?', '<p><strong>REST</strong> ha sido el estándar durante años. Se basa en recursos (como `/users` o `/jobs`) y utiliza verbos HTTP (GET, POST, PUT, DELETE) para operar sobre ellos. Es simple y bien entendido. Sin embargo, puede llevar a problemas de "over-fetching" (obtener más datos de los necesarios) o "under-fetching" (tener que hacer múltiples llamadas para obtener todos los datos).<p><strong>GraphQL</strong>, desarrollado por Facebook, aborda estos problemas. Permite al cliente solicitar exactamente los datos que necesita, ni más ni menos, en una sola llamada. El cliente define la forma de la respuesta. Esto es increíblemente eficiente, especialmente para aplicaciones móviles. Sin embargo, la curva de aprendizaje es más pronunciada y la gestión del caché en el lado del cliente puede ser más compleja que con las APIs REST.</p>');
END

BEGIN
    INSERT INTO Applications (UserID, JobID, Status, AppliedAt) VALUES
    (178, 17, 'Enviada', '2026-05-06'), (179, 18, 'Revisando', '2026-05-07'),
    (180, 19, 'Enviada', '2026-05-08'), (181, 20, 'Aceptada', '2026-05-09'),
    (182, 21, 'Enviada', '2026-05-10'), (183, 22, 'Rechazada', '2026-05-11'),
    (184, 23, 'Revisando', '2026-05-12'), (185, 24, 'Enviada', '2026-05-13'),
    (186, 25, 'Aceptada', '2026-05-14'), (187, 26, 'Enviada', '2026-05-15'),
    (188, 1, 'Revisando', '2026-05-16'), (189, 2, 'Enviada', '2026-05-17'),
    (190, 3, 'Revisando', '2026-05-18'), (191, 4, 'Aceptada', '2026-05-19'),
    (192, 5, 'Enviada', '2026-05-20'), (193, 6, 'Rechazada', '2026-05-21'),
    (194, 7, 'Revisando', '2026-05-22'), (195, 8, 'Enviada', '2026-05-23'),
    (196, 9, 'Aceptada', '2026-05-24'), (197, 10, 'Enviada', '2026-05-25'),
    (198, 11, 'Revisando', '2026-05-26'), (199, 12, 'Enviada', '2026-05-27'),
    (200, 13, 'Aceptada', '2026-05-28'), (201, 14, 'Rechazada', '2026-05-29'),
    (202, 15, 'Enviada', '2026-05-30'), (203, 16, 'Revisando', '2026-05-31'),
    (204, 17, 'Enviada', '2026-06-01'), (205, 18, 'Aceptada', '2026-06-02'),
    (206, 19, 'Enviada', '2026-06-03'), (207, 20, 'Rechazada', '2026-06-04'),
    (208, 21, 'Revisando', '2026-06-05'), (209, 22, 'Enviada', '2026-06-06'),
    (210, 23, 'Aceptada', '2026-06-07'), (211, 24, 'Enviada', '2026-06-08'),
    (212, 25, 'Revisando', '2026-06-09'), (213, 26, 'Enviada', '2026-06-10'),
    (214, 1, 'Aceptada', '2026-06-11'), (215, 2, 'Enviada', '2026-06-12'),
    (216, 3, 'Revisando', '2026-06-13'), (217, 4, 'Enviada', '2026-06-14'),
    (218, 5, 'Rechazada', '2026-06-15'), (219, 6, 'Enviada', '2026-06-16'),
    (220, 7, 'Revisando', '2026-06-17'), (221, 8, 'Aceptada', '2026-06-18'),
    (222, 9, 'Enviada', '2026-06-19'), (223, 10, 'Revisando', '2026-06-20'),
    (224, 11, 'Enviada', '2026-06-21'), (225, 12, 'Aceptada', '2026-06-22'),
    (226, 13, 'Enviada', '2026-06-23'), (227, 14, 'Rechazada', '2026-06-24'),
    (228, 15, 'Revisando', '2026-06-25'), (229, 16, 'Enviada', '2026-06-26');
END

BEGIN
    INSERT INTO Applications (UserID, JobID, Status, AppliedAt) VALUES
    (2, 1, 'Enviada', '2026-06-15'), 
    (3, 1, 'Enviada', '2026-06-16'), 
    (4, 1, 'Revisando', '2026-06-17'),
    (5, 1, 'Enviada', '2026-06-18'), 
    (6, 1, 'Enviada', '2026-06-19'), 
    (7, 1, 'Revisando', '2026-06-20'),
    (8, 1, 'Enviada', '2026-06-21'), 
    (9, 1, 'Aceptada', '2026-06-22'), 
    (10, 1, 'Enviada', '2026-06-23'),
    (11, 1, 'Revisando', '2026-06-24');
END
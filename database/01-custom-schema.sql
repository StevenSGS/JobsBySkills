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

IF (SELECT COUNT(*) FROM Skills) = 0
BEGIN
    INSERT INTO Skills (SkillName) VALUES 
    ('JavaScript'),
    ('Python'),
    ('React'),
    ('Vue.js'),
    ('Node.js'),
    ('SQL'),
    ('Diseño UX/UI'),
    ('Marketing Digital'),
    ('Project Management'),
    ('HTML'),
    ('CSS'),
    ('API REST'),
    ('Express'),
    ('MongoDB'),
    ('Docker'),
    ('AWS'),
    ('Figma'),
    ('Sketch'),
    ('UX Research'),
    ('Prototipado'),
    ('Excel'),
    ('Power BI'),
    ('SEO'),
    ('SEM'),
    ('Redes Sociales'),
    ('Google Analytics'),
    ('Git'),
    ('Cypress'),
    ('Jest'),
    ('CI/CD'),
    ('Logística'),
    ('Gestión de Rutas'),
    ('Photoshop'),
    ('Illustrator'),
    ('Google Ads'),
    ('Analytics'),
    ('Microservicios'),
    ('Diseño de Interacción'),
    ('Diseño Web');
END

IF (SELECT COUNT(*) FROM Users) = 0
BEGIN
    INSERT INTO Users (FirstName, LastName, Email, Password) VALUES 
    ('Ryan', 'Smith', 'ryan.smith@example.com', '12345678'),
    ('Juan', 'Perez', 'juan.perez@example.com', '12345678'),
    ('Admin', 'Root', 'admin', 'admin');
END

IF (SELECT COUNT(*) FROM Companies) = 0
BEGIN
    INSERT INTO Companies (CompanyName, Email, Password, Logo, Location, Industry, CompanySize, Founded, Website, Description) VALUES 
    ('Admin', 'admin', 'admin', NULL, 'Sistema', 'Administración', 'N/A', NULL, NULL, 'Usuario administrador del sistema'),
    ('Tech Solutions', 'contact@techsolutions.com', '12345678', 'https://via.placeholder.com/100x100?text=TS', 'Remoto', 'Tecnología', '50-100 empleados', 2015, 'https://techsolutions.example.com', 'Tech Solutions es una empresa líder en desarrollo de software, especializada en soluciones innovadoras para la transformación digital. Nos apasiona la tecnología y el impacto que podemos generar.'),
    ('Global Innovations', 'contact@globalinnovations.com', '12345678', 'https://via.placeholder.com/100x100?text=GI', 'Madrid, España', 'Tecnología', '200-500 empleados', 2010, 'https://globalinnovations.example.com', 'Global Innovations es una multinacional tecnológica que impulsa el futuro con productos y servicios de vanguardia. Buscamos talentos que quieran crecer con nosotros.'),
    ('Creative Agency', 'contact@creativeagency.com', '12345678', 'https://via.placeholder.com/100x100?text=CA', 'Barcelona, España', 'Diseño', '20-50 empleados', 2018, 'https://creativeagency.example.com', 'Creative Agency es un estudio de diseño galardonado, enfocado en crear experiencias de usuario memorables y estéticamente atractivas para marcas globales.'),
    ('Data Insights', 'contact@datainsights.com', '12345678', NULL, 'Remoto', 'Análisis de Datos', '10-20 empleados', 2020, NULL, 'Data Insights ayuda a las empresas a tomar decisiones basadas en datos mediante análisis avanzado y visualización de información.'),
    ('Growth Hackers', 'contact@growthhackers.com', '12345678', NULL, 'Valencia, España', 'Marketing', '30-50 empleados', 2017, NULL, 'Growth Hackers es una agencia de marketing digital especializada en estrategias de crecimiento acelerado para startups y empresas consolidadas.'),
    ('Tech Solutions S.A.', 'contacto@techsolutionssa.com', '12345678', '/img/tech-solutions.png', 'San José, Costa Rica', 'Tecnología y Desarrollo de Software', '51 - 200 colaboradores', 2018, 'https://techsolutions.example.com', 'Tech Solutions S.A. desarrolla soluciones digitales a la medida para empresas de distintos sectores, con un enfoque en calidad, innovación y metodologías ágiles.'),
    ('LogiPro Logistics', 'contacto@logipro.com', '12345678', '/images/companies/logipro.svg', 'Heredia, Costa Rica', 'Logística y Cadena de Suministro', '201 - 500 colaboradores', 2012, 'https://logipro.example.com', 'LogiPro Logistics se especializa en soluciones logísticas integrales, optimizando el flujo de mercancías y la trazabilidad en toda la cadena de suministro.');
END

IF (SELECT COUNT(*) FROM CompanyValues) = 0
BEGIN
    INSERT INTO CompanyValues (CompanyID, ValueText) VALUES 
    (2, 'Innovación tecnológica'),
    (2, 'Excelencia en desarrollo'),
    (2, 'Cultura colaborativa'),
    (2, 'Crecimiento profesional'),
    (3, 'Creatividad sin límites'),
    (3, 'Diseño centrado en el usuario'),
    (3, 'Pasión por la estética'),
    (3, 'Trabajo en equipo'),
    (4, 'Decisiones basadas en datos'),
    (4, 'Transparencia analítica'),
    (4, 'Innovación constante'),
    (5, 'Resultados medibles'),
    (5, 'Estrategias innovadoras'),
    (5, 'Enfoque en el cliente'),
    (6, 'Innovación continua'),
    (6, 'Trabajo en equipo'),
    (6, 'Calidad en cada entrega'),
    (7, 'Compromiso con el cliente'),
    (7, 'Transparencia'),
    (7, 'Responsabilidad operativa'),
    (8, 'Excelencia técnica'),
    (8, 'Innovación y calidad'),
    (8, 'Compromiso con el equipo');
END

IF (SELECT COUNT(*) FROM Jobs) = 0
BEGIN
    INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, Location, Status) VALUES 
    (7, 'Desarrollador Frontend Vue.js', 'Buscamos un desarrollador Frontend experimentado en Vue.js para unirse a nuestro equipo dinámico. Serás responsable de construir y mantener la interfaz de usuario de nuestras aplicaciones web.', 'Remoto', 'Activa'),
    (2, 'Ingeniero de Backend Node.js', 'Únete a nuestro equipo de backend para desarrollar y mantener servicios escalables utilizando Node.js. Trabajarás en la arquitectura de microservicios y bases de datos NoSQL.', 'Madrid, España', 'Activa'),
    (3, 'Diseñador UX/UI Senior', 'Estamos buscando un Diseñador UX/UI Senior para liderar el diseño de experiencias de usuario intuitivas y atractivas para nuestros productos digitales.', 'Barcelona, España', 'Activa'),
    (4, 'Analista de Datos Junior', 'Buscamos un analista de datos junior para unirse a nuestro equipo. Trabajarás con grandes volúmenes de datos y crearás visualizaciones impactantes.', 'Remoto', 'Activa'),
    (5, 'Especialista en Marketing Digital', 'Buscamos un especialista en marketing digital con experiencia en SEO, SEM y gestión de redes sociales para potenciar nuestra presencia online.', 'Valencia, España', 'Activa'),
    (6, 'Desarrollador Frontend Vue.js', 'Desarrollador Frontend con experiencia en Vue.js para proyectos innovadores.', 'Remoto - Costa Rica', 'Activa'),
    (6, 'QA Engineer Automatizado', 'Ingeniero de QA con experiencia en automatización de pruebas.', 'Híbrido - San José', 'Activa'),
    (7, 'Coordinador de Operaciones Logísticas', 'Coordinador para gestionar operaciones logísticas y optimizar rutas de distribución.', 'Heredia, Costa Rica', 'Activa'),
    (8, 'Desarrollador Backend Senior', 'Buscamos un desarrollador backend senior con experiencia en Node.js y bases de datos SQL/NoSQL para unirse a nuestro equipo de ingeniería. Será responsable del diseño, desarrollo y mantenimiento de APIs escalables.', 'Remoto', 'Activa'),
    (3, 'Diseñador Gráfico Junior', 'Oportunidad para un diseñador gráfico junior creativo y apasionado por el diseño digital. Trabajarás en la creación de material visual para campañas de marketing y redes sociales.', 'Barcelona, España', 'Pendiente'),
    (5, 'Especialista en Marketing Digital', 'Buscamos un especialista en marketing digital con experiencia en SEO, SEM y gestión de redes sociales para potenciar nuestra presencia online.', 'Valencia, España', 'Cerrada');
END

IF (SELECT COUNT(*) FROM JobRequirements) = 0
BEGIN
    INSERT INTO JobRequirements (JobID, RequirementText) VALUES 
    (1, 'Experiencia demostrable con Vue.js (Vue 2/3)'),
    (1, 'Dominio de JavaScript, HTML5 y CSS3'),
    (1, 'Conocimiento de herramientas de construcción como Webpack o Vite'),
    (1, 'Experiencia con API RESTful'),
    (1, 'Capacidad para trabajar en equipo y de forma autónoma'),
    (2, 'Experiencia sólida con Node.js y Express.js'),
    (2, 'Conocimiento de bases de datos (MongoDB, PostgreSQL)'),
    (2, 'Experiencia con Docker y microservicios'),
    (2, 'Familiaridad con metodologías ágiles'),
    (3, 'Portafolio sólido demostrando experiencia en UX/UI'),
    (3, 'Dominio de herramientas de diseño (Figma, Sketch, Adobe XD)'),
    (3, 'Experiencia en investigación de usuarios y pruebas de usabilidad'),
    (3, 'Conocimiento de principios de diseño centrado en el usuario');
END

IF (SELECT COUNT(*) FROM JobSkills) = 0
BEGIN
    INSERT INTO JobSkills (JobID, SkillID) VALUES 
    (1, 4), (1, 1), (1, 10), (1, 11), (1, 12), (1, 27),
    (2, 5), (2, 13), (2, 14), (2, 6), (2, 15), (2, 16),
    (3, 17), (3, 18), (3, 19), (3, 20), (3, 38),
    (4, 2), (4, 6), (4, 21), (4, 22),
    (5, 23), (5, 24), (5, 25), (5, 26),
    (6, 4), (6, 1), (6, 11), (6, 12),
    (7, 28), (7, 29), (7, 27), (7, 30),
    (8, 31), (8, 21), (8, 32),
    (9, 5), (9, 13), (9, 6), (9, 14), (9, 16), (9, 37),
    (10, 33), (10, 34), (10, 17), (10, 39),
    (11, 23), (11, 24), (11, 35), (11, 25), (11, 36);
END

IF (SELECT COUNT(*) FROM UserSkills) = 0
BEGIN
    INSERT INTO UserSkills (UserID, SkillID) VALUES 
    (1, 4), (1, 1),
    (2, 4), (2, 1), (2, 10), (2, 11), (2, 5), (2, 6);
END

IF (SELECT COUNT(*) FROM Applications) = 0
BEGIN
    INSERT INTO Applications (UserID, JobID, Status, AppliedAt) VALUES 
    (2, 1, 'En Revisión', '2025-11-10'),
    (2, 2, 'Entrevista', '2025-11-05'),
    (2, 3, 'Rechazado', '2025-11-01'),
    (2, 1, 'Enviada', '2025-11-15'),
    (2, 2, 'En Revisión', '2025-11-10'),
    (2, 3, 'Rechazada', '2025-11-01');
END

IF (SELECT COUNT(*) FROM BlogPosts) = 0
BEGIN
    INSERT INTO BlogPosts (Title, Author, PublishedDate, Excerpt, Content) VALUES 
    ('Introducción a las Bases de Datos NoSQL para Desarrolladores SQL', 'Javier Martín', '28 Oct, 2025', 'Si vienes del mundo SQL, las bases de datos NoSQL pueden parecer un universo diferente. Te damos una guía de iniciación para facilitar tu transición.', '
           <p>Si vienes del mundo SQL, moverte a NoSQL es casi como cambiar de idioma mental. En SQL todo es muy ordenado: tablas con columnas estrictas, relaciones definidas y un esquema fijo. En cambio, NoSQL te deja modelar los datos con mucha más libertad, permitiéndote guardar información sin un formato rígido y adaptándose mucho mejor cuando una app crece rápido o recibe miles de solicitudes simultáneamente.</p>

<h3>¿Qué es NoSQL exactamente?</h3>
<p>El nombre puede confundir — NoSQL no significa "sin SQL", sino "no solo SQL". Es una familia de bases de datos pensadas para manejar datos distribuidos y de gran tamaño, priorizando que el sistema responda rápido y siga funcionando incluso bajo alta carga.</p>

<h3>Tipos de bases de datos NoSQL</h3>
<ul>
  <li><strong>Documentales:</strong> guardan información similar a JSON; muy prácticas y fáciles de leer. Ej: MongoDB.</li>
  <li><strong>Clave-Valor:</strong> básicamente un "diccionario gigante". Ultra rápidas. Ej: Redis.</li>
  <li><strong>Columnar:</strong> funcionan muy bien para análisis de datos a gran escala. Ej: Cassandra.</li>
  <li><strong>Grafos:</strong> pensadas para escenarios donde las relaciones entre datos son lo importante. Ej: Neo4j.</li>
</ul>

<h3>SQL vs NoSQL en la vida real</h3>
<ul>
  <li>SQL requiere un esquema fijo; en NoSQL puedes cambiar la estructura de los datos sin quebrarte la cabeza.</li>
  <li>SQL escala haciendo más potente una sola máquina; NoSQL escala agregando más nodos.</li>
  <li>SQL funciona perfecto con datos estructurados; NoSQL brilla cuando los datos son flexibles o irregulares.</li>
  <li>SQL prioriza consistencia estricta; NoSQL suele priorizar disponibilidad y velocidad.</li>
</ul>

<h3>¿Cuál deberías usar?</h3>
<p>SQL sigue siendo ideal cuando tu aplicación necesita transacciones seguras y relaciones complejas entre datos, como un sistema bancario. NoSQL es mejor cuando tus datos cambian de forma seguido, cuando tu app necesita escalar rápido o cuando el volumen de información es enorme y necesitas mantener el rendimiento.</p>
          '),
    ('Trabajo Remoto: Ventajas y Desafíos', 'Sofía López', '01 Nov, 2025', 'El trabajo remoto ha llegado para quedarse. Analizamos los pros y los contras de esta modalidad y cómo puedes adaptarte con éxito.', '
  <p>El trabajo remoto ha crecido como una nube que se expande sin hacer ruido, llevando a la gente a vivir una mezcla rara de libertad y presión, donde la ventaja de estar en casa se junta con la sensación extraña de estar siempre disponible, como si el tiempo y el espacio se volvieran planos y el hogar se transformara en oficina y la oficina en sombra mental; y mientras muchos celebran la facilidad de evitar traslados y la comodidad de un entorno familiar, otros sienten un desafío invisible hecho de distracciones suaves, silencios largos y una constante confusión entre vida y labor, generando un equilibrio frágil que parece simple pero se mueve con complejidad oculta.</p>

  <h3>Ventajas del Trabajo Remoto</h3>
  <ul>
    <li>Permite trabajar desde casa u otro lugar cómodo.</li>
    <li>Elimina o reduce el tiempo de traslado.</li>
    <li>Mejora la conciliación entre vida personal y laboral.</li>
    <li>Da mayor autonomía para organizar el tiempo.</li>
    <li>Puede aumentar la productividad si el entorno es adecuado.</li>
    <li>Reduce gastos de transporte, comidas fuera y vestimenta.</li>
    <li>Amplía oportunidades laborales sin depender de la ubicación.</li>
  </ul>

  <h3>Desafíos del Trabajo Remoto</h3>
  <ul>
    <li>Dificultad para separar trabajo y vida personal.</li>
    <li>Posible sensación de aislamiento social.</li>
    <li>Distracciones en el hogar.</li>
    <li>Falta de supervisión directa y retorno inmediato.</li>
    <li>Problemas de comunicación y coordinación.</li>
    <li>Dependencia de una buena conexión y equipo tecnológico.</li>
    <li>Riesgo de trabajar más horas sin darse cuenta.</li>
  </ul>
'),
    ('Cómo Preparar tu Perfil para Atraer a los Mejores Reclutadores', 'Carlos Ruiz', '05 Nov, 2025', 'Tu perfil es tu carta de presentación. Aprende a optimizarlo para que no pase desapercibido por las empresas más importantes del sector.', '
            <p>Tu perfil en una plataforma de empleo es tu escaparate profesional. Aquí te dejamos algunos consejos para que brille:</p>
            <h3>Define tus Habilidades Clave</h3>
            <p>No te limites a listar tecnologías. Añade habilidades blandas y duras que te definan. Sé específico. En lugar de "JavaScript", puedes poner "JavaScript (ES6+), TypeScript, Node.js".</p>
            <h3>Un Resumen Profesional Atractivo</h3>
            <p>Escribe un párrafo corto y potente que resuma quién eres, qué buscas y qué puedes aportar. Esta es la primera impresión que se llevará un reclutador.</p>
            <h3>Mantén tu Perfil Actualizado</h3>
            <p>Añade nuevos proyectos, habilidades y experiencias laborales tan pronto como las adquieras. Un perfil activo demuestra interés y compromiso.</p>
          '),
    ('5 Habilidades Clave que todo Desarrollador Frontend Necesita en 2025', 'Ana García', '10 Nov, 2025', 'El mundo del desarrollo frontend evoluciona rápidamente. Descubre las 5 habilidades que te mantendrán relevante y competitivo en el mercado actual.', '
            <h3>1. Dominio de un Framework Moderno (y sus fundamentos)</h3>
            <p>Ya sea React, Vue.js o Angular, es crucial no solo saber usar un framework, sino entender cómo funciona por debajo. Conocer los principios de la reactividad, el renderizado y la gestión del estado te hará un desarrollador mucho más sólido.</p>
            <h3>2. Competencia en TypeScript</h3>
            <p>TypeScript se ha convertido en el estándar de la industria para proyectos de cualquier tamaño. Aporta seguridad, mejora la legibilidad del código y facilita el trabajo en equipo. Si aún no lo dominas, es el momento.</p>
            <h3>3. Conocimientos de Performance y Optimización Web (Core Web Vitals)</h3>
            <p>Un sitio rápido es un sitio exitoso. Entender cómo optimizar el tiempo de carga, la interactividad y la estabilidad visual (LCP, FID, CLS) es una habilidad muy demandada. Aprende a usar herramientas como Lighthouse para medir y mejorar el rendimiento.</p>
            <h3>4. Habilidades de Testing</h3>
            <p>Saber cómo probar tu propio código es fundamental. Familiarízate con librerías como Jest, Vitest o Cypress para realizar pruebas unitarias, de integración y end-to-end. Un código bien probado es sinónimo de calidad.</p>
            <h3>5. Manejo de Herramientas de CI/CD y Despliegue</h3>
            <p>El trabajo de un desarrollador no termina en el editor de código. Entender los flujos de integración y despliegue continuo (CI/CD) con herramientas como GitHub Actions o Vercel te dará una visión completa del ciclo de vida del software.</p>
          ');
END

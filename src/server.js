const express = require('express');
const sql = require('mssql');

const app = express();
const port = 3000;

const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT, 10),
    options: {
        encrypt: true, 
        trustServerCertificate: true 
    }
};

let dbConnection;

const ensureDbExists = async (retries = 15) => {
    while (retries > 0) {
        console.log('Verificando DB...');
        const masterDbConfig = { ...dbConfig, database: 'master' };
        let pool;
        try {
            pool = await sql.connect(masterDbConfig);
            const dbName = dbConfig.database;
            const checkDbQuery = `IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = '${dbName}') CREATE DATABASE [${dbName}];`;
            await pool.request().query(checkDbQuery);
            console.log('DB correcta.');
            return;
        } catch (err) {
            console.error('Fallo al verificar DB. Reintentando...');
            retries--;
            if (retries === 0) throw err;
            await new Promise(res => setTimeout(res, 10000));
        } finally {
            if (pool) {
                await pool.close();
            }
        }
    }
};

const connectWithRetry = async (retries = 15) => {
    while (retries > 0) {
        try {
            console.log('Conectando a la DB...');
            dbConnection = await sql.connect(dbConfig);
            console.log('Conexion DB correcta.');
            return;
        } catch (err) {
            console.error('Falló la conexión. Reintentando...');
            retries--;
            if (retries === 0) throw err;
            console.log(`Reintentando... (${retries})`);
            await new Promise(res => setTimeout(res, 10000));
        }
    }
};

app.get('/', async (req, res) => {
    res.send('Servidor JobsBySkills activo.');
});

app.get('/db-test', async (req, res) => {
    if (dbConnection && dbConnection.connected) {
        res.send("Conexion a la base de datos 'jobsbyskills' activa.");
    } else {
        res.status(500).send('La conexión a la base de datos no esta activa.');
    }
});

const startServer = async () => {
    try {
        console.log('Iniciando...');
        await ensureDbExists();
        await connectWithRetry();

        app.listen(port, () => {
            console.log(`Servidor activo en http://localhost:${port}`);
            console.log('Servidor ejecutandose.');
        });

    } catch (err) {
        console.error('No se pudo conectar a la base de datos. El servidor no se puede iniciar.');
        process.exit(1);
    }
};

startServer();
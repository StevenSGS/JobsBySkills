const express = require('express');
const sql = require('mssql');
const fs = require('fs');

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
            console.error('Fallo la conexion. Reintentando...');
            retries--;
            if (retries === 0) throw err;
            console.log(`Reintentando... (${retries})`);
            await new Promise(res => setTimeout(res, 10000));
        }
    }
};

const initializeDatabase = async () => {
    const initScriptPath = process.env.DB_INIT_SCRIPT;
    if (!initScriptPath) {
        console.log('No se obtuvo el script de inicializacion (DB_INIT_SCRIPT).');
        return;
    }

    try {
        const tableCheck = await dbConnection.request()
            .query("SELECT COUNT(*) as count FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'");

        if (tableCheck.recordset[0].count > 0) {
            console.log('La base de datos está inicializada.');
            return;
        }

        console.log(`Inicializando la base de datos con el script: ${initScriptPath}`);
        const initSql = fs.readFileSync(initScriptPath, 'utf8');
        await dbConnection.request().query(initSql);
        console.log('Script de inicializacion de la base de datos ejecutado con exito.');

    } catch (err) {
        console.error(`Error al ejecutar el script de inicializacion de la base de datos: ${err.message}`);
        throw err;
    }
};

app.get('/', async (req, res) => {
    res.send('Servidor JobsBySkills activo.');
});

app.get('/db-test', async (req, res) => {
    if (!dbConnection || !dbConnection.connected) {
        return res.status(500).send('La conexion a la base de datos no esta activa.');
    }

    try {
        const dbState = {};
        const tablesResult = await dbConnection.request()
            .query("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG = db_name()");
        
        const tableNames = tablesResult.recordset.map(row => row.TABLE_NAME);

        for (const tableName of tableNames) {
            const columnsResult = await dbConnection.request()
                .input('tableName', sql.NVarChar, tableName)
                .query('SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tableName');
            
            const dataResult = await dbConnection.request().query(`SELECT * FROM ${tableName}`);

            dbState[tableName] = {
                columns: columnsResult.recordset,
                data: dataResult.recordset
            };
        }

        res.json(dbState);

    } catch (err) {
        res.status(500).json({ error: 'Error al consultar la base de datos', details: err.message });
    }
});

const startServer = async () => {
    try {
        console.log('Iniciando...');
        await ensureDbExists();
        await connectWithRetry();
        await initializeDatabase();

        app.listen(port, () => {
            console.log(`Servidor activo en http://localhost:${port}`);
            console.log('Servidor ejecutandose.');
        });

    } catch (err) {
        console.error('No se pudo conectar o inicializar la base de datos. El servidor no se puede iniciar.');
        process.exit(1);
    }
};

startServer();
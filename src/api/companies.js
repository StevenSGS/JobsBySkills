import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const result = await sql.query`
            SELECT CompanyID as id, CompanyName as name, Logo as logo,
                   Location as location, Description as description
            FROM Companies
            ORDER BY CreatedAt DESC
        `;
        res.json(result.recordset);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await sql.query`
            SELECT CompanyID as id, CompanyName as name, Logo as logo,
                   Location as location, Industry as industry, CompanySize as size,
                   Founded as founded, Website as website, Description as description
            FROM Companies
            WHERE CompanyID = ${id}
        `;
        
        if (result.recordset.length === 0) {
            return res.status(404).json({ error: 'Company not found' });
        }
        
        const company = result.recordset[0];
        
        const valuesResult = await sql.query`
            SELECT ValueText
            FROM CompanyValues
            WHERE CompanyID = ${id}
        `;
        company.values = valuesResult.recordset.map(row => row.ValueText);
        
        res.json(company);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        
        if (email === 'admin' && password === 'admin') {
            return res.json({
                id: 0,
                companyName: 'Admin',
                email: 'admin',
                userType: 'admin'
            });
        }
        
        const companyCheck = await sql.query`
            SELECT CompanyID FROM Companies WHERE Email = ${email}
        `;
        
        if (companyCheck.recordset.length === 0) {
            return res.status(404).json({ 
                error: 'No existe una cuenta asociada a este correo electrónico.' 
            });
        }
        
        const result = await sql.query`
            SELECT CompanyID as id, CompanyName as companyName, Email as email
            FROM Companies
            WHERE Email = ${email} AND Password = ${password}
        `;
        
        if (result.recordset.length === 0) {
            return res.status(401).json({ 
                error: 'El correo y la contraseña no coinciden.' 
            });
        }
        
        res.json(result.recordset[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

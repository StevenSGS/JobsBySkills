import express from 'express';
import sql from 'mssql';
const router = express.Router();

router.post('/register', async (req, res) => {
    try {
        const { firstName, lastName, email, password } = req.body;

        const checkUser = await sql.query`SELECT Email FROM Users WHERE Email = ${email}`;
        if (checkUser.recordset.length > 0) {
            return res.status(409).json({ error: 'El correo electrónico ya está registrado.' });
        }

        const result = await sql.query`
            INSERT INTO Users (FirstName, LastName, Email, Password)
            OUTPUT INSERTED.UserID, INSERTED.FirstName, INSERTED.LastName, INSERTED.Email
            VALUES (${firstName}, ${lastName}, ${email}, ${password})
        `;

        const newUser = result.recordset[0];
        
        res.status(201).json({
            id: newUser.UserID,
            name: `${newUser.FirstName} ${newUser.LastName}`,
            email: newUser.Email,
            userType: 'client'
        });

    } catch (err) {
        if (err.number === 2627 || err.number === 2601) {
            return res.status(409).json({ error: 'El correo electrónico ya está registrado.' });
        }
        console.error('Error registering user:', err);
        res.status(500).json({ error: 'Error interno del servidor al registrar usuario.' });
    }
});

router.post('/company-register', async (req, res) => {
    try {
        const { companyName, email, password, location, industry, size } = req.body;

        const checkCompany = await sql.query`SELECT Email FROM Companies WHERE Email = ${email}`;
        if (checkCompany.recordset.length > 0) {
            return res.status(409).json({ error: 'El correo electrónico de la empresa ya está registrado.' });
        }

        const result = await sql.query`
            INSERT INTO Companies (CompanyName, Email, Password, Location, Industry, CompanySize)
            OUTPUT INSERTED.CompanyID, INSERTED.CompanyName, INSERTED.Email
            VALUES (${companyName}, ${email}, ${password}, ${location}, ${industry}, ${size})
        `;

        const newCompany = result.recordset[0];

        res.status(201).json({
            id: newCompany.CompanyID,
            name: newCompany.CompanyName,
            email: newCompany.Email,
            userType: 'company'
        });

    } catch (err) {
        if (err.number === 2627 || err.number === 2601) {
             return res.status(409).json({ error: 'El correo electrónico ya está registrado.' });
        }
        console.error('Error registering company:', err);
        res.status(500).json({ error: 'Error interno del servidor al registrar empresa.' });
    }
});

export default router;

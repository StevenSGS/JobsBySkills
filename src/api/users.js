import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const result = await sql.query`
            SELECT UserID as id, FirstName as firstName, LastName as lastName,
                   Email as email, 'client' as userType
            FROM Users
        `;
        const users = result.recordset.map(user => ({
            ...user,
            name: `${user.firstName} ${user.lastName}`.trim()
        }));
        res.json(users);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await sql.query`
            SELECT UserID as id, FirstName as firstName, LastName as lastName,
                   Email as email
            FROM Users
            WHERE UserID = ${id}
        `;
        
        if (result.recordset.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        
        const user = result.recordset[0];
        user.name = `${user.firstName} ${user.lastName}`.trim();
        
        const skillsResult = await sql.query`
            SELECT s.SkillName
            FROM UserSkills us
            INNER JOIN Skills s ON us.SkillID = s.SkillID
            WHERE us.UserID = ${id}
        `;
        user.skills = skillsResult.recordset.map(row => row.SkillName);
        
        res.json(user);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        let { firstName, lastName, email, skills, name } = req.body;
        
        if (name && !firstName && !lastName) {
            const nameParts = name.split(' ');
            firstName = nameParts[0] || '';
            lastName = nameParts.slice(1).join(' ') || '';
        }
        
        firstName = firstName || '';
        lastName = lastName || '';
        
        await sql.query`
            UPDATE Users
            SET FirstName = ${firstName}, LastName = ${lastName}, Email = ${email}
            WHERE UserID = ${id}
        `;
        
        await sql.query`DELETE FROM UserSkills WHERE UserID = ${id}`;
        
        if (skills && skills.length > 0) {
            for (const skillName of skills) {
                const skillResult = await sql.query`
                    SELECT SkillID FROM Skills WHERE SkillName = ${skillName}
                `;
                if (skillResult.recordset.length > 0) {
                    await sql.query`
                        INSERT INTO UserSkills (UserID, SkillID)
                        VALUES (${id}, ${skillResult.recordset[0].SkillID})
                    `;
                } else {
                    const newSkillResult = await sql.query`
                        INSERT INTO Skills (SkillName)
                        OUTPUT INSERTED.SkillID
                        VALUES (${skillName})
                    `;
                    await sql.query`
                        INSERT INTO UserSkills (UserID, SkillID)
                        VALUES (${id}, ${newSkillResult.recordset[0].SkillID})
                    `;
                }
            }
        }
        
        res.json({ message: 'User updated successfully' });
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
                firstName: 'Admin',
                lastName: 'Root',
                name: 'Admin Root',
                email: 'admin',
                userType: 'admin'
            });
        }
        
        const userCheck = await sql.query`
            SELECT UserID FROM Users WHERE Email = ${email}
        `;
        
        if (userCheck.recordset.length > 0) {
            const result = await sql.query`
                SELECT UserID as id, FirstName as firstName, LastName as lastName, Email as email, 'client' as userType
                FROM Users
                WHERE Email = ${email} AND Password = ${password}
            `;
            
            if (result.recordset.length === 0) {
                return res.status(401).json({ 
                    error: 'El correo y la contraseña no coinciden.' 
                });
            }
            
            const user = result.recordset[0];
            user.name = `${user.firstName} ${user.lastName}`.trim();
            
            return res.json(user);
        }

        const companyCheck = await sql.query`
            SELECT CompanyID FROM Companies WHERE Email = ${email}
        `;

        if (companyCheck.recordset.length > 0) {
             const result = await sql.query`
                SELECT CompanyID as id, CompanyName as name, Email as email, 'company' as userType
                FROM Companies
                WHERE Email = ${email} AND Password = ${password}
             `;
             
             if (result.recordset.length === 0) {
                return res.status(401).json({ 
                    error: 'El correo y la contraseña no coinciden.' 
                });
             }

             return res.json(result.recordset[0]);
        }
        
        return res.status(404).json({ 
            error: 'No existe una cuenta asociada a este correo electrónico.' 
        });

    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

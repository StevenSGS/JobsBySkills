import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/popular', async (req, res) => {
    try {
        const result = await sql.query`
            SELECT TOP 9 SkillName
            FROM Skills
            ORDER BY SkillID
        `;
        const skills = result.recordset.map(row => row.SkillName);
        res.json(skills);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/', async (req, res) => {
    try {
        const result = await sql.query`
            SELECT SkillID as id, SkillName as name
            FROM Skills
            ORDER BY SkillName ASC
        `;
        res.json(result.recordset);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

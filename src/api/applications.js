import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/user/:userId', async (req, res) => {
    try {
        const { userId } = req.params;
        const result = await sql.query`
            SELECT a.ApplicationID as id, a.JobID as jobId, j.JobTitle as jobTitle,
                   c.CompanyName as company, a.Status as status,
                   CONVERT(VARCHAR, a.AppliedAt, 105) as date
            FROM Applications a
            INNER JOIN Jobs j ON a.JobID = j.JobID
            INNER JOIN Companies c ON j.CompanyID = c.CompanyID
            WHERE a.UserID = ${userId}
            ORDER BY a.AppliedAt DESC
        `;
        res.json(result.recordset);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.post('/', async (req, res) => {
    try {
        const { userId, jobId } = req.body;
        const result = await sql.query`
            INSERT INTO Applications (UserID, JobID, Status)
            OUTPUT INSERTED.ApplicationID
            VALUES (${userId}, ${jobId}, 'Enviada')
        `;
        res.json({ id: result.recordset[0].ApplicationID, message: 'Application submitted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

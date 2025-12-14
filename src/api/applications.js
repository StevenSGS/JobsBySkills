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
            ORDER BY a.AppliedAt ASC
        `;
        res.json(result.recordset);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.post('/', async (req, res) => {
    try {
        const { userId, jobId, status } = req.body;
        
        const existing = await sql.query`
            SELECT ApplicationID FROM Applications 
            WHERE UserID = ${userId} AND JobID = ${jobId}
        `;
        
        if (existing.recordset.length > 0) {
            return res.status(400).json({ error: 'Ya te has postulado a este empleo' });
        }
        
        const result = await sql.query`
            INSERT INTO Applications (UserID, JobID, Status)
            OUTPUT INSERTED.ApplicationID
            VALUES (${userId}, ${jobId}, ${status || 'Pendiente'})
        `;
        res.json({ id: result.recordset[0].ApplicationID, message: 'Application submitted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/job/:jobId', async (req, res) => {
    try {
        const { jobId } = req.params;
        const result = await sql.query`
            SELECT a.ApplicationID as id, a.UserID as userId, a.Status as status,
                   u.FirstName as firstName, u.LastName as lastName,
                   u.Email as email,
                   CONVERT(VARCHAR, a.AppliedAt, 105) as appliedDate
            FROM Applications a
            INNER JOIN Users u ON a.UserID = u.UserID
            WHERE a.JobID = ${jobId}
            ORDER BY a.AppliedAt ASC
        `;
        const applicants = result.recordset.map(app => ({
            ...app,
            name: `${app.firstName} ${app.lastName}`.trim()
        }));
        res.json(applicants);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        
        await sql.query`
            UPDATE Applications
            SET Status = ${status}
            WHERE ApplicationID = ${id}
        `;
        res.json({ message: 'Application status updated successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await sql.query`DELETE FROM Applications WHERE ApplicationID = ${id}`;
        res.json({ message: 'Application deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

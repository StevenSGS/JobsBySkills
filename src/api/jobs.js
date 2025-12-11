import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const { companyId } = req.query;
        let query = `
            SELECT j.JobID as id, j.JobTitle as title, c.CompanyName as company,
                   j.Location as location, j.CompanyID as companyId
            FROM Jobs j
            INNER JOIN Companies c ON j.CompanyID = c.CompanyID
            WHERE j.Status = 'Activa'
        `;
        
        if (companyId) {
            query += ` AND j.CompanyID = ${parseInt(companyId)}`;
        }
        
        query += ` ORDER BY j.PostedAt DESC`;
        
        const result = await sql.query(query);
        
        const jobsWithSkills = await Promise.all(result.recordset.map(async (job) => {
            const skillsResult = await sql.query`
                SELECT s.SkillName
                FROM JobSkills js
                INNER JOIN Skills s ON js.SkillID = s.SkillID
                WHERE js.JobID = ${job.id}
            `;
            job.skills = skillsResult.recordset.map(row => row.SkillName);
            return job;
        }));
        
        res.json(jobsWithSkills);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/featured', async (req, res) => {
    try {
        const result = await sql.query`
            SELECT TOP 3 j.JobID as id, j.JobTitle as title, c.CompanyName as company,
                   j.Location as location, j.CompanyID as companyId
            FROM Jobs j
            INNER JOIN Companies c ON j.CompanyID = c.CompanyID
            WHERE j.Status = 'Activa'
            ORDER BY j.PostedAt DESC
        `;
        
        const jobsWithSkills = await Promise.all(result.recordset.map(async (job) => {
            const skillsResult = await sql.query`
                SELECT s.SkillName
                FROM JobSkills js
                INNER JOIN Skills s ON js.SkillID = s.SkillID
                WHERE js.JobID = ${job.id}
            `;
            job.skills = skillsResult.recordset.map(row => row.SkillName);
            return job;
        }));
        
        res.json(jobsWithSkills);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await sql.query`
            SELECT j.JobID as id, j.JobTitle as title, c.CompanyName as company,
                   j.Location as location, j.JobDescription as description,
                   j.CompanyID as companyId
            FROM Jobs j
            INNER JOIN Companies c ON j.CompanyID = c.CompanyID
            WHERE j.JobID = ${id}
        `;
        
        if (result.recordset.length === 0) {
            return res.status(404).json({ error: 'Job not found' });
        }
        
        const job = result.recordset[0];
        
        const requirementsResult = await sql.query`
            SELECT RequirementText
            FROM JobRequirements
            WHERE JobID = ${id}
        `;
        job.requirements = requirementsResult.recordset.map(row => row.RequirementText);
        
        const skillsResult = await sql.query`
            SELECT s.SkillName
            FROM JobSkills js
            INNER JOIN Skills s ON js.SkillID = s.SkillID
            WHERE js.JobID = ${id}
        `;
        job.skills = skillsResult.recordset.map(row => row.SkillName);
        
        res.json(job);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.post('/', async (req, res) => {
    try {
        const { companyId, title, description, location, skills, requirements } = req.body;
        
        const result = await sql.query`
            INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, Location, Status)
            OUTPUT INSERTED.JobID
            VALUES (${companyId}, ${title}, ${description}, ${location}, 'Pendiente')
        `;
        
        const jobId = result.recordset[0].JobID;
        
        if (requirements && requirements.length > 0) {
            for (const req of requirements) {
                await sql.query`
                    INSERT INTO JobRequirements (JobID, RequirementText)
                    VALUES (${jobId}, ${req})
                `;
            }
        }
        
        if (skills && skills.length > 0) {
            for (const skillName of skills) {
                const skillResult = await sql.query`
                    SELECT SkillID FROM Skills WHERE SkillName = ${skillName}
                `;
                if (skillResult.recordset.length > 0) {
                    await sql.query`
                        INSERT INTO JobSkills (JobID, SkillID)
                        VALUES (${jobId}, ${skillResult.recordset[0].SkillID})
                    `;
                }
            }
        }
        
        res.json({ id: jobId, message: 'Job created successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { title, description, location, status, skills, requirements } = req.body;
        
        await sql.query`
            UPDATE Jobs
            SET JobTitle = ${title}, JobDescription = ${description},
                Location = ${location}, Status = ${status}
            WHERE JobID = ${id}
        `;
        
        await sql.query`DELETE FROM JobRequirements WHERE JobID = ${id}`;
        if (requirements && requirements.length > 0) {
            for (const req of requirements) {
                await sql.query`
                    INSERT INTO JobRequirements (JobID, RequirementText)
                    VALUES (${id}, ${req})
                `;
            }
        }
        
        await sql.query`DELETE FROM JobSkills WHERE JobID = ${id}`;
        if (skills && skills.length > 0) {
            for (const skillName of skills) {
                const skillResult = await sql.query`
                    SELECT SkillID FROM Skills WHERE SkillName = ${skillName}
                `;
                if (skillResult.recordset.length > 0) {
                    await sql.query`
                        INSERT INTO JobSkills (JobID, SkillID)
                        VALUES (${id}, ${skillResult.recordset[0].SkillID})
                    `;
                }
            }
        }
        
        res.json({ message: 'Job updated successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

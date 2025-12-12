import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/all', async (req, res) => {
    try {
        const query = `
            SELECT j.JobID as id, j.JobTitle as title, c.CompanyName as company,
                   j.Location as location, j.Status as status, j.PostedAt as postedAt
            FROM Jobs j
            INNER JOIN Companies c ON j.CompanyID = c.CompanyID
            ORDER BY j.PostedAt ASC
        `;
        const result = await sql.query(query);
        res.json(result.recordset);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/', async (req, res) => {
    try {
        const { companyId } = req.query;
        let query = `
            SELECT j.JobID as id, j.JobTitle as title, c.CompanyName as company,
                   j.Location as location, j.CompanyID as companyId, j.Status as status,
                   CONVERT(VARCHAR, j.PostedAt, 23) as date
            FROM Jobs j
            INNER JOIN Companies c ON j.CompanyID = c.CompanyID
            WHERE j.Status = 'Activa'
        `;
        
        if (companyId) {
            query += ` AND j.CompanyID = ${parseInt(companyId)}`;
        }
        
        query += ` ORDER BY j.PostedAt ASC`;
        
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
            ORDER BY j.PostedAt ASC
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
            SELECT s.SkillID as id, s.SkillName as name
            FROM JobSkills js
            INNER JOIN Skills s ON js.SkillID = s.SkillID
            WHERE js.JobID = ${id}
        `;
        job.skills = skillsResult.recordset;
        
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
        const { title, status, description, skills } = req.body;
        
        await sql.query`
            UPDATE Jobs
            SET JobTitle = ${title}, Status = ${status}, JobDescription = ${description || ''}
            WHERE JobID = ${id}
        `;
        
        if (skills && Array.isArray(skills)) {
            await sql.query`DELETE FROM JobSkills WHERE JobID = ${id}`;
            
            for (const skillId of skills) {
                const skillIdInt = parseInt(skillId, 10);
                if (!isNaN(skillIdInt)) {
                    await sql.query`
                        INSERT INTO JobSkills (JobID, SkillID)
                        VALUES (${id}, ${skillIdInt})
                    `;
                }
            }
        }
        
        res.json({ message: 'Job updated successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await sql.query`DELETE FROM Jobs WHERE JobID = ${id}`;
        res.json({ message: 'Job deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

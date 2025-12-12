import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/stats', async (req, res) => {
    try {
        const stats = {
            users: 0,
            companies: 0,
            jobs: 0,
            applications: 0,
            posts: 0
        };

        const usersResult = await sql.query`SELECT COUNT(*) as count FROM Users`;
        stats.users = usersResult.recordset[0].count;

        const companiesResult = await sql.query`SELECT COUNT(*) as count FROM Companies`;
        stats.companies = companiesResult.recordset[0].count;

        const jobsResult = await sql.query`SELECT COUNT(*) as count FROM Jobs`;
        stats.jobs = jobsResult.recordset[0].count;

        try {
             const appsResult = await sql.query`SELECT COUNT(*) as count FROM Applications`;
             stats.applications = appsResult.recordset[0].count;
        } catch (e) {
            console.warn('Applications table fetch failed:', e.message);
        }

        try {
             const postsResult = await sql.query`SELECT COUNT(*) as count FROM BlogPosts`;
             stats.posts = postsResult.recordset[0].count;
        } catch (e) {
            console.warn('BlogPosts table fetch failed:', e.message);
            stats.posts = 0;
        }

        res.json(stats);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

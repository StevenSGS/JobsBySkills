import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const result = await sql.query`
            SELECT PostID as id, Title as title, Author as author, 
                   PublishedDate as date, Excerpt as excerpt
            FROM BlogPosts
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
            SELECT PostID as id, Title as title, Author as author,
                   PublishedDate as date, Excerpt as excerpt, Content as content
            FROM BlogPosts
            WHERE PostID = ${id}
        `;
        if (result.recordset.length === 0) {
            return res.status(404).json({ error: 'Post not found' });
        }
        res.json(result.recordset[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

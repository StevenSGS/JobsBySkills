import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const result = await sql.query`
            SELECT PostID as id, Title as title, Author as author, 
                   PublishedDate as date, Excerpt as excerpt, Content as content
            FROM BlogPosts
            ORDER BY CreatedAt ASC
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

router.post('/', async (req, res) => {
    try {
        const { title, author, content, excerpt } = req.body;
        const date = new Date();
        
        await sql.query`
            INSERT INTO BlogPosts (Title, Author, Content, Excerpt, PublishedDate)
            VALUES (${title}, ${author}, ${content}, ${excerpt || ''}, ${date})
        `;
        res.json({ message: 'Post created successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { title, author, content, excerpt } = req.body;
        
        await sql.query`
            UPDATE BlogPosts
            SET Title = ${title}, Author = ${author}, Content = ${content}, Excerpt = ${excerpt}
            WHERE PostID = ${id}
        `;
        res.json({ message: 'Post updated successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

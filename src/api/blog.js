import express from 'express';
import sql from 'mssql';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const result = await sql.query`
            SELECT b.PostID as id, b.Title as title, 
                   CONCAT(u.FirstName, ' ', u.LastName) as author,
                   CONVERT(VARCHAR, b.PublishedDate, 107) as date,
                   b.Excerpt as excerpt, b.Content as content
            FROM BlogPosts b
            INNER JOIN Users u ON b.AuthorID = u.UserID
            ORDER BY b.CreatedAt ASC
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
            SELECT b.PostID as id, b.Title as title,
                   CONCAT(u.FirstName, ' ', u.LastName) as author,
                   CONVERT(VARCHAR, b.PublishedDate, 107) as date,
                   b.Excerpt as excerpt, b.Content as content
            FROM BlogPosts b
            INNER JOIN Users u ON b.AuthorID = u.UserID
            WHERE b.PostID = ${id}
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
        const { title, authorId, content, excerpt } = req.body;
        
        await sql.query`
            INSERT INTO BlogPosts (Title, AuthorID, Content, Excerpt)
            VALUES (${title}, ${authorId}, ${content}, ${excerpt || ''})
        `;
        res.json({ message: 'Post created successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { title, content, excerpt, authorId } = req.body;
        
        if (authorId) {
            await sql.query`
                UPDATE BlogPosts
                SET Title = ${title}, Content = ${content}, Excerpt = ${excerpt}, AuthorID = ${authorId}
                WHERE PostID = ${id}
            `;
        } else {
            await sql.query`
                UPDATE BlogPosts
                SET Title = ${title}, Content = ${content}, Excerpt = ${excerpt}
                WHERE PostID = ${id}
            `;
        }
        res.json({ message: 'Post updated successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await sql.query`DELETE FROM BlogPosts WHERE PostID = ${id}`;
        res.json({ message: 'Post deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;

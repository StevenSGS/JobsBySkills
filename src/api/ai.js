import express from "express";
import sql from "mssql";
import axios from "axios";

const router = express.Router();

let dbConnection;

const setDbConnection = (conn) => {
  dbConnection = conn;
};

router.post("/match-candidates", async (req, res) => {
  const { jobId } = req.body;

  if (!jobId) {
    return res.status(400).json({ error: "jobId es requerido" });
  }

  try {
    const jobResult = await dbConnection
      .request()
      .input("jobId", sql.Int, jobId)
      .query("SELECT * FROM Jobs WHERE JobID = @jobId");

    if (jobResult.recordset.length === 0) {
      return res.status(404).json({ error: "Trabajo no encontrado" });
    }
    const jobDetails = jobResult.recordset[0];

    const applicantsResult = await dbConnection
      .request()
      .input("jobId", sql.Int, jobId).query(`
                SELECT u.UserID, u.FirstName, u.LastName, u.Email, s.SkillName 
                FROM Applications a
                JOIN Users u ON a.UserID = u.UserID
                LEFT JOIN UserSkills us ON u.UserID = us.UserID
                LEFT JOIN Skills s ON us.SkillID = s.SkillID
                WHERE a.JobID = @jobId
            `);

    if (applicantsResult.recordset.length === 0) {
      return res
        .status(404)
        .json({ error: "No se encontraron aplicantes para este trabajo" });
    }

    const applicants = applicantsResult.recordset.reduce((acc, row) => {
      if (!acc[row.UserID]) {
        acc[row.UserID] = {
          userId: row.UserID,
          name: `${row.FirstName} ${row.LastName}`,
          email: row.Email,
          skills: [],
        };
      }
      if (row.SkillName) {
        acc[row.UserID].skills.push(row.SkillName);
      }
      return acc;
    }, {});

    const prompt = `
            Eres un asistente de reclutamiento experto. Tu tarea es analizar una oferta de trabajo y una lista de candidatos, y luego clasificar a los candidatos del mejor al peor según su idoneidad para el puesto.

            **Oferta de Trabajo:**
            - **Título:** ${jobDetails.JobTitle}
            - **Descripción:** ${jobDetails.JobDescription}

            **Candidatos:**
            ${Object.values(applicants)
              .map(
                (c) => `
            - **ID de Candidato:** ${c.userId}
              - **Nombre:** ${c.name}
              - **Habilidades:** ${c.skills.join(", ") || "No especificadas"}
            `
              )
              .join("")}

            **Instrucciones:**
            1. Evalúa a cada candidato basándote en cómo sus habilidades se alinean con el título y la descripción del trabajo.
            2. Proporciona una respuesta en formato JSON. La respuesta debe ser un array de objetos, donde cada objeto contiene "userId" y "justificacion".
            3. Ordena el array desde el candidato más adecuado hasta el menos adecuado.
            4. La justificación debe ser un texto breve (1-2 frases) que explique por qué el candidato es una buena o mala opción.

            **Ejemplo de formato de respuesta JSON:**
            [
              { "userId": 1, "justificacion": "Las habilidades del candidato en 'Desarrollo Web' y 'Bases de Datos' se alinean perfectamente con los requisitos del puesto." },
              { "userId": 3, "justificacion": "Aunque tiene algunas habilidades relevantes, su experiencia parece más orientada al diseño que al desarrollo." }
            ]
        `;

    try {
      const response = await axios.post(
        "https://openrouter.ai/api/v1/chat/completions",
        {
          model: "openrouter/free",
          messages: [{ role: "user", content: prompt }],
        },
        {
          headers: {
            Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
            "Content-Type": "application/json",
          },
        }
      );

      const aiResponse = response.data.choices[0].message.content;
      const jsonMatch = aiResponse.match(
        /\S*```(?:json)?\s*([\s\S]*?)\s*```\S*|([\s\S]*)/s
      );
      if (!jsonMatch || (!jsonMatch[1] && !jsonMatch[2])) {
        throw new Error("La respuesta de la IA no contenía un JSON válido.");
      }

      const cleanedJson = jsonMatch[1] || jsonMatch[2];
      const rankedCandidates = JSON.parse(cleanedJson);

      res.status(200).json(rankedCandidates);
    } catch (apiError) {
      console.error(
        "Error al llamar a la API de OpenRouter o al procesar su respuesta:",
        apiError.response ? apiError.response.data : apiError.message
      );
      res.status(500).json({
        error: "Fallo al contactar o procesar la respuesta del servicio de IA.",
      });
    }
  } catch (error) {
    console.error("Error en /match-candidates:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
});

export { router as aiRoutes, setDbConnection as setAiDbConnection };

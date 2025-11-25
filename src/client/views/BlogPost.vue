<template>
  <div class="blog-post-view container">
    <BaseCard v-if="post">
      <div class="post-header">
        <h1>{{ post.title }}</h1>
        <p class="post-meta">Por {{ post.author }} el {{ post.date }}</p>
      </div>
      <div class="post-body" v-html="post.content"></div>
      <div class="back-to-blog">
        <router-link to="/blog">
          <BaseButton type="text">&larr; Volver al Blog</BaseButton>
        </router-link>
      </div>
    </BaseCard>
    <div v-else class="loading-message">
      Cargando artículo...
    </div>
  </div>
</template>

<script>
import BaseCard from '../components/BaseCard.vue';
import BaseButton from '../components/BaseButton.vue';

export default {
  name: 'BlogPostView',
  components: {
    BaseCard,
    BaseButton,
  },
  data() {
    return {
      post: null,
      allPosts: [
        {
          id: 1,
          title: '5 Habilidades Clave que todo Desarrollador Frontend Necesita en 2025',
          author: 'Ana García',
          date: '10 Nov, 2025',
          excerpt: 'El mundo del desarrollo frontend evoluciona rápidamente. Descubre las 5 habilidades que te mantendrán relevante y competitivo en el mercado actual.',
          content: `
            <h3>1. Dominio de un Framework Moderno (y sus fundamentos)</h3>
            <p>Ya sea React, Vue.js o Angular, es crucial no solo saber usar un framework, sino entender cómo funciona por debajo. Conocer los principios de la reactividad, el renderizado y la gestión del estado te hará un desarrollador mucho más sólido.</p>
            <h3>2. Competencia en TypeScript</h3>
            <p>TypeScript se ha convertido en el estándar de la industria para proyectos de cualquier tamaño. Aporta seguridad, mejora la legibilidad del código y facilita el trabajo en equipo. Si aún no lo dominas, es el momento.</p>
            <h3>3. Conocimientos de Performance y Optimización Web (Core Web Vitals)</h3>
            <p>Un sitio rápido es un sitio exitoso. Entender cómo optimizar el tiempo de carga, la interactividad y la estabilidad visual (LCP, FID, CLS) es una habilidad muy demandada. Aprende a usar herramientas como Lighthouse para medir y mejorar el rendimiento.</p>
            <h3>4. Habilidades de Testing</h3>
            <p>Saber cómo probar tu propio código es fundamental. Familiarízate con librerías como Jest, Vitest o Cypress para realizar pruebas unitarias, de integración y end-to-end. Un código bien probado es sinónimo de calidad.</p>
            <h3>5. Manejo de Herramientas de CI/CD y Despliegue</h3>
            <p>El trabajo de un desarrollador no termina en el editor de código. Entender los flujos de integración y despliegue continuo (CI/CD) con herramientas como GitHub Actions o Vercel te dará una visión completa del ciclo de vida del software.</p>
          `
        },
        {
          id: 2,
          title: 'Cómo Preparar tu Perfil para Atraer a los Mejores Reclutadores',
          author: 'Carlos Ruiz',
          date: '05 Nov, 2025',
          excerpt: 'Tu perfil es tu carta de presentación. Aprende a optimizarlo para que no pase desapercibido por las empresas más importantes del sector.',
          content: `
            <p>Tu perfil en una plataforma de empleo es tu escaparate profesional. Aquí te dejamos algunos consejos para que brille:</p>
            <h3>Define tus Habilidades Clave</h3>
            <p>No te limites a listar tecnologías. Añade habilidades blandas y duras que te definan. Sé específico. En lugar de "JavaScript", puedes poner "JavaScript (ES6+), TypeScript, Node.js".</p>
            <h3>Un Resumen Profesional Atractivo</h3>
            <p>Escribe un párrafo corto y potente que resuma quién eres, qué buscas y qué puedes aportar. Esta es la primera impresión que se llevará un reclutador.</p>
            <h3>Mantén tu Perfil Actualizado</h3>
            <p>Añade nuevos proyectos, habilidades y experiencias laborales tan pronto como las adquieras. Un perfil activo demuestra interés y compromiso.</p>
          `
        },
        {
          id: 3,
          title: 'Trabajo Remoto: Ventajas y Desafíos',
          author: 'Sofía López',
          date: '01 Nov, 2025',
          excerpt: 'El trabajo remoto ha llegado para quedarse. Analizamos los pros y los contras de esta modalidad y cómo puedes adaptarte con éxito.',
          content: `
  <p>El trabajo remoto ha crecido como una nube que se expande sin hacer ruido, llevando a la gente a vivir una mezcla rara de libertad y presión, donde la ventaja de estar en casa se junta con la sensación extraña de estar siempre disponible, como si el tiempo y el espacio se volvieran planos y el hogar se transformara en oficina y la oficina en sombra mental; y mientras muchos celebran la facilidad de evitar traslados y la comodidad de un entorno familiar, otros sienten un desafío invisible hecho de distracciones suaves, silencios largos y una constante confusión entre vida y labor, generando un equilibrio frágil que parece simple pero se mueve con complejidad oculta.</p>

  <h3>Ventajas del Trabajo Remoto</h3>
  <ul>
    <li>Permite trabajar desde casa u otro lugar cómodo.</li>
    <li>Elimina o reduce el tiempo de traslado.</li>
    <li>Mejora la conciliación entre vida personal y laboral.</li>
    <li>Da mayor autonomía para organizar el tiempo.</li>
    <li>Puede aumentar la productividad si el entorno es adecuado.</li>
    <li>Reduce gastos de transporte, comidas fuera y vestimenta.</li>
    <li>Amplía oportunidades laborales sin depender de la ubicación.</li>
  </ul>

  <h3>Desafíos del Trabajo Remoto</h3>
  <ul>
    <li>Dificultad para separar trabajo y vida personal.</li>
    <li>Posible sensación de aislamiento social.</li>
    <li>Distracciones en el hogar.</li>
    <li>Falta de supervisión directa y retorno inmediato.</li>
    <li>Problemas de comunicación y coordinación.</li>
    <li>Dependencia de una buena conexión y equipo tecnológico.</li>
    <li>Riesgo de trabajar más horas sin darse cuenta.</li>
  </ul>
`
        },
        {
          id: 4,
          title: 'Introducción a las Bases de Datos NoSQL para Desarrolladores SQL',
          author: 'Javier Martín',
          date: '28 Oct, 2025',
          excerpt: 'Si vienes del mundo SQL, las bases de datos NoSQL pueden parecer un universo diferente. Te damos una guía de iniciación para facilitar tu transición.',
          content: `
           <p>Si vienes del mundo SQL, moverte a NoSQL es casi como cambiar de idioma mental. En SQL todo es muy ordenado: tablas con columnas estrictas, relaciones definidas y un esquema fijo. En cambio, NoSQL te deja modelar los datos con mucha más libertad, permitiéndote guardar información sin un formato rígido y adaptándose mucho mejor cuando una app crece rápido o recibe miles de solicitudes simultáneamente.</p>

<h3>¿Qué es NoSQL exactamente?</h3>
<p>El nombre puede confundir — NoSQL no significa “sin SQL”, sino “no solo SQL”. Es una familia de bases de datos pensadas para manejar datos distribuidos y de gran tamaño, priorizando que el sistema responda rápido y siga funcionando incluso bajo alta carga.</p>

<h3>Tipos de bases de datos NoSQL</h3>
<ul>
  <li><strong>Documentales:</strong> guardan información similar a JSON; muy prácticas y fáciles de leer. Ej: MongoDB.</li>
  <li><strong>Clave-Valor:</strong> básicamente un “diccionario gigante”. Ultra rápidas. Ej: Redis.</li>
  <li><strong>Columnar:</strong> funcionan muy bien para análisis de datos a gran escala. Ej: Cassandra.</li>
  <li><strong>Grafos:</strong> pensadas para escenarios donde las relaciones entre datos son lo importante. Ej: Neo4j.</li>
</ul>

<h3>SQL vs NoSQL en la vida real</h3>
<ul>
  <li>SQL requiere un esquema fijo; en NoSQL puedes cambiar la estructura de los datos sin quebrarte la cabeza.</li>
  <li>SQL escala haciendo más potente una sola máquina; NoSQL escala agregando más nodos.</li>
  <li>SQL funciona perfecto con datos estructurados; NoSQL brilla cuando los datos son flexibles o irregulares.</li>
  <li>SQL prioriza consistencia estricta; NoSQL suele priorizar disponibilidad y velocidad.</li>
</ul>

<h3>¿Cuál deberías usar?</h3>
<p>SQL sigue siendo ideal cuando tu aplicación necesita transacciones seguras y relaciones complejas entre datos, como un sistema bancario. NoSQL es mejor cuando tus datos cambian de forma seguido, cuando tu app necesita escalar rápido o cuando el volumen de información es enorme y necesitas mantener el rendimiento.</p>
          `
        },
      ]
    };
  },
  created() {
    const postId = parseInt(this.$route.params.id);
    this.post = this.allPosts.find(p => p.id === postId);
  },
};
</script>

<style scoped>
.blog-post-view {
  max-width: 800px;
  margin: 2rem auto;
}

.post-header {
  text-align: center;
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid var(--color-border);
}

.post-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
}

.post-meta {
  font-size: 1rem;
  color: var(--color-text);
  opacity: 0.8;
}

.post-body {
  line-height: 1.8;
  font-size: 1.1rem;
}

.post-body :deep(h3) {
  font-size: 1.5rem;
  margin-top: 2rem;
  margin-bottom: 1rem;
}

.post-body :deep(p) {
  margin-bottom: 1rem;
}

.back-to-blog {
  margin-top: 2rem;
  text-align: center;
}

.loading-message {
  text-align: center;
  font-size: 1.2rem;
  padding: 2rem;
}
</style>

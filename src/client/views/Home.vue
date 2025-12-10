<template>
  <div class="home-view">
    <header class="hero-section">
      <div class="container">
        <h1>Conecta tu talento con el futuro</h1>
        <p>La plataforma inteligente que te empareja con el trabajo de tus sueños basado en tus habilidades.</p>
        <router-link to="/jobs">
          <BaseButton type="primary">Explorar Empleos</BaseButton>
        </router-link>
      </div>
    </header>

    <section class="featured-jobs-section container">
      <h2>Empleos Destacados</h2>
      <div class="job-list">
        <JobCard v-for="job in featuredJobs" :key="job.id" :job="job" />
      </div>
    </section>

    <section class="browse-by-skill-section container">
      <h2>Explorar por Habilidad</h2>
      <div class="skill-tags">
        <span v-for="skill in popularSkills" :key="skill" class="skill-tag">{{ skill }}</span>
      </div>
    </section>

    <section class="why-us-section">
      <div class="container">
        <h2>¿Por qué JobsBySkills?</h2>
        <div class="features-grid">
          <div class="feature-item">
            <h3>Búsqueda Inteligente</h3>
            <p>Nuestro algoritmo te conecta con las ofertas que realmente importan.</p>
          </div>
          <div class="feature-item">
            <h3>Perfil Profesional</h3>
            <p>Destaca tus habilidades y crea un perfil que atraiga a los reclutadores.</p>
          </div>
          <div class="feature-item">
            <h3>Empresas de Nivel</h3>
            <p>Accede a oportunidades en las empresas más innovadoras del sector.</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import BaseButton from '../components/BaseButton.vue';
import JobCard from '../components/JobCard.vue';

export default {
  name: 'HomeView',
  components: {
    BaseButton,
    JobCard,
  },
  data() {
    return {
      featuredJobs: [],
      popularSkills: [],
    };
  },
  async mounted() {
    try {
      const [jobsRes, skillsRes] = await Promise.all([
        fetch('/api/jobs/featured'),
        fetch('/api/skills/popular')
      ]);
      this.featuredJobs = await jobsRes.json();
      this.popularSkills = await skillsRes.json();
    } catch (err) {
      console.error('Error loading data:', err);
    }
  },
};
</script>

<style scoped>
.home-view {
  width: 100%;
}

.hero-section {
  text-align: center;
  padding: 4rem 0;
  background-color: var(--color-card-bg);
}

.hero-section h1 {
  font-size: 3rem;
  font-weight: bold;
  margin-bottom: 1rem;
}

.hero-section p {
  font-size: 1.25rem;
  color: var(--color-text);
  margin-bottom: 2rem;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

section {
  padding: 4rem 0;
}

section h2 {
  text-align: center;
  font-size: 2.2rem;
  margin-bottom: 2rem;
}

.job-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.browse-by-skill-section .skill-tags {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 1rem;
}

.browse-by-skill-section .skill-tag {
  background-color: var(--color-primary);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 500;
  cursor: pointer;
  transition: transform 0.2s ease;
}

.browse-by-skill-section .skill-tag:hover {
  transform: scale(1.05);
}

.why-us-section {
  background-color: var(--color-card-bg);
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  text-align: center;
}

.feature-item h3 {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}
</style>

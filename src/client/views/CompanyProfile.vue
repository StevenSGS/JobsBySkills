<template>
  <div class="company-profile-view container">
    <BaseCard v-if="company">
      <div class="company-header">
        <img :src="company.logo" :alt="company.name + ' logo'" class="company-logo" v-if="company.logo">
        <h1>{{ company.name }}</h1>
        <p class="company-location">{{ company.location }}</p>
      </div>

      <div class="company-description">
        <h3>Sobre Nosotros</h3>
        <p>{{ company.description }}</p>
      </div>

      <div class="company-jobs-section">
        <h3>Ofertas de Empleo de {{ company.name }}</h3>
        <div v-if="companyJobs.length > 0" class="job-list">
          <JobCard v-for="job in companyJobs" :key="job.id" :job="job" />
        </div>
        <p v-else class="no-jobs-message">
          Actualmente no hay ofertas de empleo disponibles de esta empresa.
        </p>
      </div>
    </BaseCard>
    <div v-else class="loading-message">
      Cargando perfil de la empresa...
    </div>
  </div>
</template>

<script>
import BaseCard from '../components/BaseCard.vue';
import JobCard from '../components/JobCard.vue';

export default {
  name: 'CompanyProfileView',
  components: {
    BaseCard,
    JobCard,
  },
  data() {
    return {
      company: null,
      allJobs: [],
    };
  },
  computed: {
    companyJobs() {
      return this.allJobs;
    },
  },
  async mounted() {
    const companyId = this.$route.params.id;
    try {
      const [companyRes, jobsRes] = await Promise.all([
        fetch(`/api/companies/${companyId}`),
        fetch(`/api/jobs?companyId=${companyId}`)
      ]);
      if (companyRes.ok) {
        this.company = await companyRes.json();
      }
      if (jobsRes.ok) {
        this.allJobs = await jobsRes.json();
      }
    } catch (err) {
      console.error('Error loading company:', err);
    }
  },
};
</script>

<style scoped>
.company-profile-view {
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
}

.company-header {
  text-align: center;
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid var(--color-border);
}

.company-logo {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  object-fit: cover;
  margin-bottom: 1rem;
  border: 1px solid var(--color-border);
}

.company-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  color: var(--color-text);
}

.company-header .company-location {
  font-size: 1.1rem;
  color: var(--color-text);
  opacity: 0.8;
}

.company-description, .company-jobs-section {
  margin-bottom: 2rem;
}

.company-description h3, .company-jobs-section h3 {
  font-size: 1.8rem;
  margin-bottom: 1.5rem;
  color: var(--color-text);
}

.company-description p {
  line-height: 1.8;
}

.job-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.no-jobs-message {
  text-align: center;
  font-style: italic;
  color: var(--color-text);
  opacity: 0.7;
}

.loading-message {
  text-align: center;
  font-size: 1.2rem;
  color: var(--color-text);
}
</style>

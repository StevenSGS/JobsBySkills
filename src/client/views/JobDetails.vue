<template>
  <div class="job-details-view container">
    <BaseCard v-if="job">
      <div class="job-header">
        <h1>{{ job.title }}</h1>
        <router-link :to="{ name: 'CompanyProfile', params: { id: job.companyId } }" class="company-link">
          {{ job.company }}
        </router-link>
        <p class="job-location">{{ job.location }}</p>
      </div>

      <div class="job-description">
        <h3>Descripción del Puesto</h3>
        <p>{{ job.description }}</p>
      </div>

      <div class="job-requirements">
        <h3>Requisitos</h3>
        <ul>
          <li v-for="req in job.requirements" :key="req">{{ req }}</li>
        </ul>
      </div>

      <div class="job-skills-required">
        <h3>Habilidades Requeridas</h3>
        <div class="skill-tags">
          <span v-for="skill in job.skills" :key="skill" class="skill-tag">{{ skill }}</span>
        </div>
      </div>

      <div class="job-actions">
        <BaseButton type="primary" @click="applyForJob">Postularse Ahora</BaseButton>
      </div>
    </BaseCard>
    <div v-else class="loading-message">
      Cargando detalles del empleo...
    </div>
  </div>
</template>

<script>
import BaseCard from '../components/BaseCard.vue';
import BaseButton from '../components/BaseButton.vue';
import authStore from '../store/authStore';

export default {
  name: 'JobDetailsView',
  components: {
    BaseCard,
    BaseButton,
  },
  data() {
    return {
      job: null,
    };
  },
  computed: {
    authStore() {
      return authStore;
    },
    isLoggedIn() {
      return authStore.state.isLoggedIn && authStore.state.userData?.id;
    },
  },
  mounted() {
    this.fetchJobDetails(this.$route.params.id);
  },
  methods: {
    async applyForJob() {
      const userData = authStore.state.userData;
      
      if (!userData || !userData.id) {
        alert('Debes iniciar sesión para postularte a un empleo.');
        this.$router.push('/login');
        return;
      }

      const userId = userData.id;

      try {
        const res = await fetch('/api/applications', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            userId: userId,
            jobId: this.job.id,
            status: 'Pendiente'
          })
        });

        if (res.ok) {
          alert('¡Te has postulado exitosamente a este empleo!');
        } else {
          const error = await res.json();
          alert(error.error || 'Error al postularse. Intenta nuevamente.');
        }
      } catch (err) {
        console.error('Error applying for job:', err);
        alert('Error al postularse. Verifica tu conexión.');
      }
    },
    async fetchJobDetails(jobId) {
      try {
        const res = await fetch(`/api/jobs/${jobId}`);
        if (res.ok) {
          this.job = await res.json();
        } else {
          console.error('Job not found');
        }
      } catch (err) {
        console.error('Error loading job details:', err);
      }
    },
  },
};
</script>

<style scoped>
.job-details-view {
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
}

.job-header {
  margin-bottom: 2rem;
  text-align: center;
}

.job-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  color: var(--color-primary);
}

.job-header .company-link {
  font-size: 1.2rem;
  font-weight: 500;
  color: var(--color-text);
  margin-bottom: 0.25rem;
  display: block;
}

.job-header .job-location {
  font-size: 1rem;
  color: var(--color-text);
  opacity: 0.8;
}

.job-description, .job-requirements, .job-skills-required {
  margin-bottom: 2rem;
}

.job-description h3, .job-requirements h3, .job-skills-required h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: var(--color-text);
}

.job-description p {
  line-height: 1.8;
}

.job-requirements ul {
  list-style: inside;
  padding-left: 1rem;
}

.job-requirements li {
  margin-bottom: 0.5rem;
}

.skill-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.skill-tag {
  background-color: var(--color-border);
  color: var(--color-text);
  padding: 0.3rem 0.7rem;
  border-radius: 5px;
  font-size: 0.9rem;
}

.job-actions {
  text-align: center;
  margin-top: 3rem;
}

.loading-message {
  text-align: center;
  font-size: 1.2rem;
  color: var(--color-text);
}
</style>

<template>
  <div class="company-profile-view container">
   
    <p v-if="isLoading" class="loading-message">
      Cargando perfil de la empresa...
    </p>

    
    <BaseCard v-else-if="company">
      <div class="company-header">
        <div class="company-header-text">
          <h1>{{ company.name }}</h1>
          <p class="company-location">{{ company.location }}</p>
          <p class="company-industry">
            <strong>Sector:</strong> {{ company.industry }}
          </p>
          <div class="company-tags">
            <span class="tag">{{ company.size }}</span>
            <span class="tag" v-if="company.founded">
              Fundada en {{ company.founded }}
            </span>
          </div>
          <div class="company-actions">
           <BaseButton 
             :key="isOwner ? 'owner' : 'visitor'"
             v-if="isOwner || company.website"
             :type="isOwner ? 'secondary' : 'primary'" 
             @click="handleAction"
           >
             {{ isOwner ? 'Editar Perfil' : 'Visitar Sitio Web' }}
           </BaseButton>
           <BaseButton 
             v-if="isOwner"
             type="primary"
             @click="$router.push('/company/request/new')"
             style="margin-left: 0.5rem;"
           >
             Publicar Solicitud
           </BaseButton>
          </div>
        </div>
      </div>

      <div class="company-description">
        <h3>Sobre Nosotros</h3>
        <p>{{ company.description }}</p>
      </div>

      <div class="company-extra-info" v-if="company.values && company.values.length > 0">
        <h3>Nuestros Valores</h3>
        <ul>
          <li v-for="(value, index) in company.values" :key="index">
            {{ value }}
          </li>
        </ul>
      </div>

      <div class="company-jobs-section">
        <h3>Ofertas de empleo en {{ company.name }}</h3>

        <div v-if="companyJobs.length" class="job-list">
          <JobCard
            v-for="job in companyJobs"
            :key="job.id"
            :job="job"
            :customLink="isOwner ? `/company/request/${job.id}` : `/job/${job.id}`"
          />
        </div>

        <p v-else class="no-jobs-message">
          Esta empresa aún no tiene ofertas publicadas.
        </p>
      </div>
    </BaseCard>

   
    <p v-else class="no-company-message">
      No se encontró información para esta empresa.
    </p>
  </div>
</template>

<script>
import BaseCard from '../../components/BaseCard.vue';
import BaseButton from '../../components/BaseButton.vue';
import JobCard from '../../components/JobCard.vue';
import authStore from '../../store/authStore';

export default {
  name: 'CompanyProfileView',
  components: {
    BaseCard,
    BaseButton,
    JobCard,
  },
  data() {
    return {
      isLoading: true,
      company: null,
      allJobs: [],
    };
  },
  computed: {
    authState() {
      return authStore.state;
    },
    companyJobs() {
      return this.allJobs;
    },
    isOwner() {
        if (!this.company) return false;
        
        const { isAuthenticated, userType, userData } = this.authState;
        
        if (!isAuthenticated || userType !== 'company' || !userData) {
            return false;
        }

        return String(userData.id) === String(this.company.id);
    }
  },
  async created() {
    const companyId = Number(this.$route.params.id) || 1;
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
    } finally {
      this.isLoading = false;
    }
  },
  methods: {
    handleAction() {
        if (this.isOwner) {
            this.$router.push('/company/edit');
        } else if (this.company.website && typeof window !== 'undefined') {
            window.open(this.company.website, '_blank');
        }
    },
  },
};
</script>

<style scoped>
.company-profile-view {
  padding-top: 2rem;
  padding-bottom: 2rem;
}

.company-header {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}

.company-logo-wrapper {
  width: 72px;
  height: 72px;
  border-radius: 16px;
  overflow: hidden;
  border: 1px solid var(--color-border);
  background-color: var(--color-card-bg);
  flex-shrink: 0;
}

.company-logo {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.company-header-text h1 {
  margin: 0;
  font-size: 2rem;
  color: var(--color-text);
}

.company-location {
  margin: 0.25rem 0;
  color: var(--color-text);
  opacity: 0.8;
}

.company-industry {
  margin: 0;
  color: var(--color-text);
}

.company-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 0.75rem;
}

.tag {
  background-color: var(--color-border);
  color: var(--color-text);
  padding: 0.25rem 0.75rem;
  border-radius: 999px;
  font-size: 0.8rem;
}

.company-actions {
  margin-top: 1rem;
}

.company-description {
  margin-top: 1.5rem;
}

.company-description h3 {
  margin-bottom: 0.75rem;
}

.company-description p {
  line-height: 1.7;
}

.company-extra-info {
  margin-top: 1.5rem;
}

.company-extra-info h3 {
  margin-bottom: 0.5rem;
}

.company-extra-info ul {
  padding-left: 1.2rem;
  margin: 0;
}

.company-extra-info li {
  margin-bottom: 0.25rem;
}

.company-jobs-section {
  margin-top: 2rem;
}

.company-jobs-section h3 {
  margin-bottom: 1rem;
}

.job-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}

.no-jobs-message,
.no-company-message {
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

<template>
  <div class="company-profile-view container">
   
    <p v-if="isLoading" class="loading-message">
      Cargando perfil de la empresa...
    </p>

    
    <BaseCard v-else-if="company">
      <div class="company-header">
        <div v-if="company.logo" class="company-logo-wrapper">
          <img
            :src="company.logo"
            :alt="company.name + 'logo'"
            class="company-logo"
          />
        </div>
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
          <div class="company-actions" v-if="company.website">
            <BaseButton type="primary" @click="openWebsite">
              Visitar sitio web
            </BaseButton>
          </div>
        </div>
      </div>

      <div class="company-description">
        <h3>Sobre Nosotros</h3>
        <p>{{ company.description }}</p>
      </div>

      <div class="company-extra-info" v-if="company.values && company.values.length">
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
  
      allCompanies: [
        {
          id: 1,
          name: 'Tech Solutions S.A.',
          logo: '/img/tech-solutions.png',
          location: 'San José, Costa Rica',
          industry: 'Tecnología y Desarrollo de Software',
          website: 'https://techsolutions.example.com',
          size: '51 - 200 colaboradores',
          founded: 2018,
          description:
            'Tech Solutions S.A. desarrolla soluciones digitales a la medida para empresas de distintos sectores, con un enfoque en calidad, innovación y metodologías ágiles.',
          values: [
            'Innovación continua',
            'Trabajo en equipo',
            'Calidad en cada entrega',
          ],
        },
        {
          id: 2,
          name: 'LogiPro Logistics',
          logo: '/images/companies/logipro.svg',
          location: 'Heredia, Costa Rica',
          industry: 'Logística y Cadena de Suministro',
          website: 'https://logipro.example.com',
          size: '201 - 500 colaboradores',
          founded: 2012,
          description:
            'LogiPro Logistics se especializa en soluciones logísticas integrales, optimizando el flujo de mercancías y la trazabilidad en toda la cadena de suministro.',
          values: [
            'Compromiso con el cliente',
            'Transparencia',
            'Responsabilidad operativa',
          ],
        },
      ],
      allJobs: [
        {
          id: 1,
          title: 'Desarrollador Frontend Vue.js',
          company: 'Tech Solutions S.A.',
          companyId: 1,
          location: 'Remoto - Costa Rica',
          skills: ['Vue.js', 'JavaScript', 'CSS', 'REST APIs'],
        },
        {
          id: 2,
          title: 'QA Engineer Automatizado',
          company: 'Tech Solutions S.A.',
          companyId: 1,
          location: 'Híbrido - San José',
          skills: ['Cypress', 'Jest', 'Git', 'CI/CD'],
        },
        {
          id: 3,
          title: 'Coordinador de Operaciones Logísticas',
          company: 'LogiPro Logistics',
          companyId: 2,
          location: 'Heredia, Costa Rica',
          skills: ['Logística', 'Excel', 'Gestión de Rutas'],
        },
      ],
    };
  },
  computed: {
    companyJobs() {
      if (!this.company) return [];
      return this.allJobs.filter(
        (job) => job.companyId === this.company.id
      );
    },
  },
  created() {
    const idFromRoute = Number(this.$route.params.id);
    const companyId = Number.isNaN(idFromRoute) ? 1 : idFromRoute;

    this.loadCompany(companyId);
  },
  methods: {
    loadCompany(companyId) {
      const found = this.allCompanies.find(
        (company) => company.id === companyId
      );
      this.company = found || null;
      this.isLoading = false;
    },
    openWebsite() {
      if (this.company && this.company.website && typeof window !== 'undefined') {
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

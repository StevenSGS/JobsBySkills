<template>
  <div class="company-requests-view container">
    <BaseCard>
      <h1>Gestión de Solicitudes de Empleo</h1>
      <p class="intro-text">Desde aquí puede publicar nuevas solicitudes de empleo y gestionar las existentes.</p>

      <div class="publish-request-section">
        <BaseButton type="primary" @click="publishNewRequest">Publicar Nueva Solicitud</BaseButton>
      </div>

      <h2 class="section-title">Mis Solicitudes Publicadas</h2>
      <div v-if="requests.length > 0" class="requests-list">
        <div v-for="request in requests" :key="request.id" class="request-item">
          <div class="request-details">
            <h3><router-link :to="{ name: 'CompanyRequestDetails', params: { id: request.id } }">{{ request.title }}</router-link></h3>
            <p class="request-status">Estado: <span :class="['status-tag', (request.status || 'activa').toLowerCase()]">{{ request.status || 'Activa' }}</span></p>
            <p class="request-date">Publicada el: {{ request.date || 'N/A' }}</p>
          </div>
          <div class="request-actions">
            <router-link :to="{ name: 'CompanyRequestDetails', params: { id: request.id } }">
              <BaseButton type="secondary">Editar</BaseButton>
            </router-link>
          </div>
        </div>
      </div>
      <p v-else class="no-requests-message">
        Aún no ha publicado ninguna solicitud de empleo.
      </p>
    </BaseCard>
  </div>
</template>

<script>
import BaseCard from '../../components/BaseCard.vue';
import BaseButton from '../../components/BaseButton.vue';
import authStore from '../../store/authStore';

export default {
  name: 'CompanyRequestsView',
  components: {
    BaseCard,
    BaseButton,
  },
  data() {
    return {
      requests: [],
    };
  },
  async mounted() {
    const companyId = authStore.state.userData?.id;
    
    if (!companyId) {
      this.$router.push('/company/login');
      return;
    }
    
    try {
      const res = await fetch(`/api/jobs?companyId=${companyId}`);
      if (res.ok) {
        this.requests = await res.json();
      }
    } catch (err) {
      console.error('Error loading requests:', err);
    }
  },
  methods: {
    publishNewRequest() {
      this.$router.push({ name: 'CompanyRequestDetails', params: { id: 'new' } });
    },
  },
};
</script>

<style scoped>
.company-requests-view {
  max-width: 900px;
  margin: 2rem auto;
}

.company-requests-view h1 {
  font-size: 2rem;
  margin-bottom: 1rem;
  text-align: center;
}

.intro-text {
  text-align: center;
  margin-bottom: 2rem;
  color: var(--color-text);
  opacity: 0.9;
}

.publish-request-section {
  text-align: center;
  margin-bottom: 3rem;
}

.section-title {
  font-size: 1.8rem;
  margin-top: 3rem;
  margin-bottom: 1.5rem;
  text-align: center;
  border-bottom: 1px solid var(--color-border);
  padding-bottom: 0.5rem;
}

.requests-list {
  margin-top: 1.5rem;
}

.request-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 0;
  border-bottom: 1px solid var(--color-border);
}

.request-item:last-child {
  border-bottom: none;
}

.request-details h3 {
  font-size: 1.2rem;
  margin-bottom: 0.25rem;
}

.request-details h3 a {
  color: var(--color-primary);
}

.request-status {
  font-weight: 500;
  color: var(--color-text);
  opacity: 0.9;
}

.request-date {
  font-size: 0.9rem;
  color: var(--color-text);
  opacity: 0.7;
}

.status-tag {
  padding: 0.3rem 0.6rem;
  border-radius: 5px;
  font-size: 0.8rem;
  font-weight: 500;
  color: white;
}

.status-tag.activa {
  background-color: #28a745;
}

.status-tag.pendiente {
  background-color: #ffc107;
  color: #333;
}

.status-tag.cerrada {
  background-color: #6c757d;
}

.no-requests-message {
  text-align: center;
  margin-top: 2rem;
  font-style: italic;
  color: var(--color-text);
  opacity: 0.8;
}
</style>

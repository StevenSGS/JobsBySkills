<template>
  <div class="my-applications-view container">
    <BaseCard>
      <h2>Mis Postulaciones</h2>
      <div v-if="applications.length > 0" class="applications-list">
        <div v-for="app in applications" :key="app.id" class="application-item">
          <div class="app-details">
            <h3><router-link :to="{ name: 'JobDetails', params: { id: app.jobId } }">{{ app.jobTitle }}</router-link></h3>
            <p class="company-name">{{ app.company }}</p>
            <p class="application-date">Postulado el: {{ app.date }}</p>
          </div>
          <div class="app-status">
            <span :class="['status-tag', app.status.toLowerCase()]">{{ app.status }}</span>
          </div>
        </div>
      </div>
      <p v-else class="no-applications-message">
        Aún no  has apliocado a ningún empleo. ¡Explora nuestras ofertas!
      </p>
      <div class="explore-jobs-action">
        <router-link to="/jobs">
          <BaseButton type="primary">Buscar Empleos</BaseButton>
        </router-link>
      </div>
    </BaseCard>
  </div>
</template>

<script>
import BaseCard from '../components/BaseCard.vue';
import BaseButton from '../components/BaseButton.vue';
import authStore from '../store/authStore';

export default {
  name: 'MyApplicationsView',
  components: {
    BaseCard,
    BaseButton,
  },
  data() {
    return {
      applications: [],
    };
  },
  async mounted() {
    const userId = authStore.state.userData?.id;
    
    if (!userId) {
      this.$router.push('/login');
      return;
    }
    
    try {
      const res = await fetch(`/api/applications/user/${userId}`);
      if (res.ok) {
        this.applications = await res.json();
      }
    } catch (err) {
      console.error('Error loading applications:', err);
    }
  },
};
</script>

<style scoped>
.my-applications-view {
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}

.applications-list {
  margin-top: 1.5rem;
}

.application-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 0;
  border-bottom: 1px solid var(--color-border);
}

.application-item:last-child {
  border-bottom: none;
}

.app-details h3 {
  font-size: 1.2rem;
  margin-bottom: 0.25rem;
}

.app-details h3 a {
  color: var(--color-primary);
}

.app-details .company-name {
  font-weight: 500;
  color: var(--color-text);
  opacity: 0.9;
}

.app-details .application-date {
  font-size: 0.9rem;
  color: var(--color-text);
  opacity: 0.7;
}

.app-status .status-tag {
  padding: 0.4rem 0.8rem;
  border-radius: 5px;
  font-size: 0.9rem;
  font-weight: 500;
}

.status-tag.enviada {
  background-color: rgba(0, 123, 255, 0.2);
  color: #007bff;
}

.status-tag.en-revisión {
  background-color: rgba(255, 193, 7, 0.2);
  color: #ffc107;
}

.status-tag.rechazada {
  background-color: rgba(220, 53, 69, 0.2);
  color: #dc3545;
}

.no-applications-message {
  text-align: center;
  margin-top: 2rem;
  font-style: italic;
  color: var(--color-text);
  opacity: 0.8;
}

.explore-jobs-action {
  text-align: center;
  margin-top: 2rem;
}
</style>

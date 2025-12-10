<template>
  <div class="profile-view container">
    <BaseCard class="profile-card">
      <div class="profile-header">
        <h2>Mi Perfil</h2>
        <router-link to="/profile/edit" class="edit-profile-link">
          <BaseButton type="secondary">Editar Perfil</BaseButton>
        </router-link>
      </div>

      <div class="profile-info-section">
        <h3>Información Personal</h3>
        <p><strong>Nombre:</strong> {{ user.name }}</p>
        <p><strong>Correo Electrónico:</strong> {{ user.email }}</p>
      </div>

      <div class="profile-skills-section">
        <h3>Mis Habilidades</h3>
        <div v-if="user.skills.length > 0" class="skill-tags">
          <span v-for="skill in user.skills" :key="skill" class="skill-tag">{{ skill }}</span>
        </div>
        <p v-else class="no-skills-message">
          Aún no has añadido ninguna habilidad. ¡Añade algunas para encontrar mejores empleos!
        </p>

      </div>

      <div class="profile-applications-section">
        <h3>Mis Postulaciones</h3>
        <div v-if="applications.length > 0" class="applications-list">
          <BaseCard v-for="app in applications" :key="app.id" class="application-item">
            <h4>{{ app.jobTitle }}</h4>
            <p><strong>Empresa:</strong> {{ app.company }}</p>
            <p><strong>Fecha de Postulación:</strong> {{ app.date }}</p>
            <p><strong>Estado:</strong> <span :class="['status-tag', app.status.toLowerCase()]">{{ app.status }}</span></p>
          </BaseCard>
        </div>
        <p v-else class="no-applications-message">
          Aún no  has apliocado a ningún empleo. ¡Explora nuestras ofertas!
        </p>
      </div>
    </BaseCard>
  </div>
</template>

<script>
import BaseCard from '../components/BaseCard.vue';
import BaseButton from '../components/BaseButton.vue';
import authStore from '../store/authStore';

export default {
  name: 'ProfileView',
  components: {
    BaseCard,
    BaseButton,
  },
  data() {
    return {
      user: {
        name: '',
        email: '',
        skills: [],
      },
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
      const [userRes, appsRes] = await Promise.all([
        fetch(`/api/users/${userId}`),
        fetch(`/api/applications/user/${userId}`)
      ]);
      if (userRes.ok) {
        this.user = await userRes.json();
      }
      if (appsRes.ok) {
        this.applications = await appsRes.json();
      }
    } catch (err) {
      console.error('Error loading profile:', err);
    }
  },
};
</script>

<style scoped>
.profile-view {
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}

.profile-card {
  padding: 2rem;
}

.profile-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  border-bottom: 1px solid var(--color-border);
  padding-bottom: 1rem;
}

.profile-header h2 {
  font-size: 2rem;
  color: var(--color-text);
}

.profile-info-section, .profile-skills-section, .profile-applications-section {
  margin-bottom: 2rem;
}

.profile-info-section h3, .profile-skills-section h3, .profile-applications-section h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: var(--color-text);
}

.profile-info-section p {
  margin-bottom: 0.5rem;
}

.skill-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.skill-tag {
  background-color: var(--color-border);
  color: var(--color-text);
  padding: 0.4rem 0.8rem;
  border-radius: 5px;
  font-size: 0.9rem;
}

.no-skills-message {
  font-style: italic;
  color: var(--color-text);
  opacity: 0.7;
  margin-bottom: 1rem;
}

.add-skills-button {
  margin-top: 1rem;
}

.applications-list {
  display: grid;
  gap: 1rem;
}

.application-item {
  padding: 1rem;
  border: 1px solid var(--color-border);
  border-radius: 8px;
}

.application-item h4 {
  font-size: 1.2rem;
  margin-bottom: 0.5rem;
  color: var(--color-primary);
}

.application-item p {
  margin-bottom: 0.25rem;
}

.status-tag {
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  font-size: 0.85rem;
  font-weight: 500;
  color: white;
}

.status-tag.en {
  background-color: #007bff;
}

.status-tag.entrevista {
  background-color: #ffc107;
  color: #333;
}

.status-tag.rechazado {
  background-color: #dc3545; 
}

.no-applications-message {
  font-style: italic;
  color: var(--color-text);
  opacity: 0.7;
}
</style>

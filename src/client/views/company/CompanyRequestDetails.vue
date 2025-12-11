<template>
  <div class="company-request-details-view container">
    <BaseCard>
      <div class="request-header">
        <h1>{{ isNewRequest ? 'Crear Nueva Solicitud' : ' ' + request.title }}</h1>
        <p v-if="!isNewRequest" class="request-status">Estado: <span :class="['status-tag', request.status.toLowerCase()]">{{ request.status }}</span></p>
      </div>

      <form @submit.prevent="saveRequest" class="request-form">
        <InputField
          id="requestTitle"
          label="Título de la Solicitud"
          type="text"
          v-model="request.title"
          required
        />
        <div class="form-group">
          <label for="requestDescription">Descripción</label>
          <textarea
            id="requestDescription"
            v-model="request.description"
            rows="8"
            class="textarea-field"
          ></textarea>
        </div>
        <InputField
          id="requestLocation"
          label="Ubicación"
          type="text"
          v-model="request.location"
        />
        <div class="form-group">
          <label for="requestSkills">Habilidades Requeridas</label>
          <input
            id="requestSkills"
            type="text"
            v-model="skillsInput"
            class="input-field"
          />
        </div>

        <div class="form-actions">
          <BaseButton type="primary" @click="saveRequest">{{ isNewRequest ? 'Publicar Solicitud' : 'Guardar Cambios' }}</BaseButton>
          <BaseButton type="secondary" @click="cancelEdit">Cancelar</BaseButton>
        </div>
      </form>

      <div class="back-to-requests">
        <router-link to="/company/requests">
          <BaseButton type="text">&larr; Volver a Mis Solicitudes</BaseButton>
        </router-link>
      </div>
    </BaseCard>
  </div>
</template>

<script>
import BaseCard from '../../components/BaseCard.vue';
import BaseButton from '../../components/BaseButton.vue';
import InputField from '../../components/InputField.vue';
import authStore from '../../store/authStore';

export default {
  name: 'CompanyRequestDetailsView',
  components: {
    BaseCard,
    BaseButton,
    InputField,
  },
  data() {
    return {
      request: {
        id: null,
        title: '',
        status: 'Pendiente',
        date: new Date().toLocaleDateString('es-ES'),
        description: '',
        location: '',
        skills: [],
      },
      skillsInput: '',
    };
  },
  computed: {
    isNewRequest() {
      return this.$route.params.id === 'new';
    },
  },
  async created() {
    if (!this.isNewRequest) {
      const requestId = parseInt(this.$route.params.id);
      try {
        const res = await fetch(`/api/jobs/${requestId}`);
        if (res.ok) {
          const job = await res.json();
          this.request = {
            id: job.id,
            title: job.title,
            status: job.status || 'Activa',
            date: new Date().toLocaleDateString('es-ES'),
            description: job.description,
            location: job.location,
            skills: job.skills || [],
          };
          this.skillsInput = this.request.skills.join(', ');
        } else {
          this.$router.push('/company/requests');
        }
      } catch (err) {
        console.error('Error loading request:', err);
        this.$router.push('/company/requests');
      }
    }
  },
  methods: {
    async saveRequest() {
      const companyId = authStore.state.userData?.id;
      
      if (!companyId) {
        this.$router.push('/company/login');
        return;
      }
      
      const skills = this.skillsInput.split(',').map(s => s.trim()).filter(s => s);
      
      try {
        if (this.isNewRequest) {
          const res = await fetch('/api/jobs', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              companyId,
              title: this.request.title,
              description: this.request.description,
              location: this.request.location,
              status: this.request.status,
              skills
            })
          });
          
          if (res.ok) {
            alert('Solicitud creada correctamente');
            this.$router.push('/company/requests');
          }
        } else {
          const res = await fetch(`/api/jobs/${this.request.id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              companyId,
              title: this.request.title,
              description: this.request.description,
              location: this.request.location,
              status: this.request.status,
              skills
            })
          });
          
          if (res.ok) {
            alert('Solicitud actualizada correctamente');
            this.$router.push('/company/requests');
          }
        }
      } catch (err) {
        console.error('Error saving request:', err);
      }
    },
    cancelEdit() {
      this.$router.push('/company/requests');
    },
  },
};
</script>

<style scoped>
.company-request-details-view {
  max-width: 900px;
  margin: 2rem auto;
}

.request-header {
  text-align: center;
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid var(--color-border);
}

.request-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
}

.request-status {
  font-size: 1.1rem;
  font-weight: 500;
}

.status-tag {
  padding: 0.3rem 0.6rem;
  border-radius: 5px;
  font-size: 0.9rem;
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

.request-form {
  margin-top: 2rem;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: var(--color-text);
}

.textarea-field {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  font-size: 1rem;
  background-color: var(--color-card-bg);
  color: var(--color-text);
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
  resize: vertical;
}

.textarea-field:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.25);
}

.form-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  margin-top: 2rem;
}

.back-to-requests {
  margin-top: 2rem;
  text-align: center;
}

.loading-message {
  text-align: center;
  font-size: 1.2rem;
  padding: 2rem;
}
</style>

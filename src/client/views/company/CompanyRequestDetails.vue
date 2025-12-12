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
        <div class="form-group" v-if="!isNewRequest">
          <label for="requestStatus">Estado</label>
          <select id="requestStatus" v-model="request.status" class="input-field">
            <option value="Activa">Activa</option>
            <option value="Pendiente">Pendiente</option>
            <option value="Cerrada">Cerrada</option>
          </select>
        </div>

        <div class="form-group">
          <label>Habilidades Requeridas</label>
          <div class="skills-selection">
            <div class="available-skills">
              <span 
                v-for="skill in availableSkills" 
                :key="skill"
                :class="['skill-chip', { selected: request.skills.includes(skill) }]"
                @click="toggleSkill(skill)"
              >
                {{ skill }}
              </span>
            </div>
          </div>
        </div>

        <div class="form-group">
          <label for="requirements">Requisitos (uno por línea)</label>
          <textarea
            id="requirements"
            v-model="requirementsInput"
            rows="4"
            class="textarea-field"
            placeholder="- 3 años de experiencia..."
          ></textarea>
        </div>

        <div class="form-actions">
          <BaseButton type="primary">{{ isNewRequest ? 'Publicar Solicitud' : 'Guardar Cambios' }}</BaseButton>
          <BaseButton type="secondary" @click="cancelEdit">Cancelar</BaseButton>
        </div>
      </form>

      <div v-if="!isNewRequest && applicants.length > 0" class="applicants-section">
        <h3>Postulantes ({{ applicants.length }})</h3>
        <div class="applicants-list">
          <div v-for="applicant in applicants" :key="applicant.id" class="applicant-card">
            <div class="applicant-info">
              <h4 @click="viewApplicantProfile(applicant.userId)" class="applicant-name">{{ applicant.name }}</h4>
              <p class="applicant-email">{{ applicant.email }}</p>
              <p class="applicant-date">Postulado: {{ applicant.appliedDate }}</p>
            </div>
            <div class="applicant-status">
              <select 
                v-model="applicant.status" 
                @change="updateApplicationStatus(applicant.id, applicant.status)"
                class="status-select"
              >
                <option value="Pendiente">Pendiente</option>
                <option value="Revisando">Revisando</option>
                <option value="Aceptada">Aceptada</option>
                <option value="Rechazada">Rechazada</option>
              </select>
            </div>
          </div>
        </div>
      </div>

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
import { saveRecord, loadRecord } from '../../utils/dataHandler';

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
        requirements: [],
      },
      availableSkills: [],
      requirementsInput: '',
      applicants: [],
      viewingProfile: null,
    };
  },
  computed: {
    isNewRequest() {
      return this.$route.params.id === 'new';
    },
  },
  async created() {
    const skillsData = await loadRecord('/api/skills');
    if (skillsData) {
      this.availableSkills = skillsData.map(s => s.name);
    }

    if (!this.isNewRequest) {
      const requestId = parseInt(this.$route.params.id);
      const jobData = await loadRecord(`/api/jobs/${requestId}`);
      
      if (jobData) {
        this.request = {
          id: jobData.id,
          title: jobData.title,
          status: jobData.status || 'Activa',
          date: new Date().toLocaleDateString('es-ES'),
          description: jobData.description,
          location: jobData.location,
          skills: jobData.skills || [],
          requirements: jobData.requirements || [],
        };
        this.requirementsInput = this.request.requirements.join('\n');
        
        const applicantsData = await loadRecord(`/api/applications/job/${requestId}`);
        if (applicantsData) {
          this.applicants = applicantsData;
        }
      } else {
        this.$router.push('/company/requests');
      }
    }
  },
  methods: {
    toggleSkill(skill) {
      if (this.request.skills.includes(skill)) {
        this.request.skills = this.request.skills.filter(s => s !== skill);
      } else {
        this.request.skills.push(skill);
      }
    },
    async saveRequest() {
      const companyId = authStore.state.userData?.id;
      
      if (!companyId) {
        this.$router.push('/company/login');
        return;
      }
      
      const requirements = this.requirementsInput.split('\n').map(r => r.trim()).filter(r => r);
      
      const payload = {
        companyId,
        title: this.request.title,
        description: this.request.description,
        location: this.request.location,
        status: this.request.status,
        skills: this.request.skills,
        requirements
      };

      let result;
      if (this.isNewRequest) {
        result = await saveRecord(
          '/api/jobs',
          'POST',
          payload,
          'Solicitud creada correctamente'
        );
      } else {
        result = await saveRecord(
          `/api/jobs/${this.request.id}`,
          'PUT',
          payload,
          'Solicitud actualizada correctamente'
        );
      }

      if (result) {
        this.$router.push('/company/requests');
      }
    },
    cancelEdit() {
      this.$router.push('/company/requests');
    },
    async updateApplicationStatus(applicationId, newStatus) {
      const result = await saveRecord(
        `/api/applications/${applicationId}`,
        'PUT',
        { status: newStatus },
        `Estado actualizado a: ${newStatus}`
      );
    },
    viewApplicantProfile(userId) {
      this.$router.push(`/profile/${userId}`);
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
}

.status-tag.activa {
  background-color: rgba(40, 167, 69, 0.2);
  color: #28a745;
}

.status-tag.pendiente {
  background-color: rgba(255, 193, 7, 0.2);
  color: #ffc107;
}

.status-tag.cerrada {
  background-color: rgba(108, 117, 125, 0.2);
  color: #6c757d;
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

.skills-selection {
  margin-top: 0.5rem;
}

.available-skills {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  padding: 1rem;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  background-color: var(--color-card-bg);
  min-height: 60px;
}

.skill-chip {
  padding: 0.5rem 1rem;
  border-radius: 20px;
  background-color: var(--color-background);
  border: 2px solid var(--color-border);
  cursor: pointer;
  transition: all 0.2s ease;
  user-select: none;
  font-size: 0.9rem;
}

.skill-chip:hover {
  border-color: var(--color-primary);
  transform: translateY(-2px);
}

.skill-chip.selected {
  background-color: var(--color-primary);
  color: white;
  border-color: var(--color-primary);
}

.input-field {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  font-size: 1rem;
  background-color: var(--color-card-bg);
  color: var(--color-text);
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.input-field:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.25);
}

.applicants-section {
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 2px solid var(--color-border);
}

.applicants-section h3 {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  color: var(--color-text);
}

.applicants-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.applicant-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  background-color: var(--color-card-bg);
  transition: box-shadow 0.2s;
}

.applicant-card:hover {
  box-shadow: 0 2px 8px var(--color-card-shadow);
}

.applicant-info {
  flex: 1;
}

.applicant-name {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--color-primary);
  cursor: pointer;
  margin-bottom: 0.25rem;
}

.applicant-name:hover {
  text-decoration: underline;
}

.applicant-email {
  font-size: 0.9rem;
  color: var(--color-text);
  opacity: 0.8;
  margin-bottom: 0.25rem;
}

.applicant-date {
  font-size: 0.85rem;
  color: var(--color-text);
  opacity: 0.6;
}

.applicant-status {
  min-width: 150px;
}

.status-select {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid var(--color-border);
  border-radius: 4px;
  background-color: var(--color-background);
  color: var(--color-text);
  font-size: 0.9rem;
  cursor: pointer;
}

.status-select:focus {
  outline: none;
  border-color: var(--color-primary);
}
</style>

<template>
  <div class="admin-view">
    <div class="header-actions">
      <h2>Gestión de Empleos</h2>
      <div class="filters">
      </div>
    </div>

    <div v-if="isLoading" class="loading-state">
      Cargando empleos...
    </div>

    <div v-else-if="error" class="error-state">
      {{ error }}
    </div>

    <div v-else class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Título</th>
            <th>Empresa</th>
            <th>Ubicación</th>
            <th>Estado</th>
            <th>Publicado</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="job in jobs" :key="job.id">
            <td>{{ job.id }}</td>
            <td>{{ job.title }}</td>
            <td>{{ job.company }}</td>
            <td>{{ job.location }}</td>
            <td>
              <span :class="['status-badge', job.status.toLowerCase()]">
                {{ job.status }}
              </span>
            </td>
            <td>{{ formatDate(job.postedAt) }}</td>
            <td>
              <button class="action-btn edit" @click="editJob(job)">Editar</button>
              <button class="action-btn delete" @click="confirmDelete(job)">Eliminar</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <BaseModal 
      v-if="showModal" 
      title="Editar Empleo"
      @close="closeModal"
      @save="saveChanges"
    >
      <div v-if="editingJob" class="edit-form">
        <div class="form-group">
          <label>Título</label>
          <input v-model="form.title" class="modal-input" />
        </div>
        <div class="form-group">
          <label>Estado</label>
          <select v-model="form.status" class="modal-input select">
            <option value="Activa">Activa</option>
            <option value="Pendiente">Pendiente</option>
            <option value="Cerrada">Cerrada</option>
          </select>
        </div>
        <div class="form-group">
          <label>Descripción</label>
          <textarea v-model="form.description" class="modal-input textarea"></textarea>
        </div>
        <div class="form-group">
          <div class="toggle-header" @click="showSkills = !showSkills">
            <label>Habilidades Requeridas</label>
            <span class="toggle-icon">{{ showSkills ? '▼' : '▶' }}</span>
          </div>
          <div v-if="showSkills" class="chips-container">
            <div class="available-chips">
              <div 
                v-for="skill in availableSkills" 
                :key="skill.id"
                @click="toggleSkill(skill.id)"
                :class="['chip', { selected: isSkillSelected(skill.id) }]"
              >
                {{ skill.name }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </BaseModal>
    
    <ConfirmModal
      :show="showDeleteModal"
      title="Eliminar Empleo"
      message="¿Estás seguro de que deseas eliminar este empleo? Esta acción eliminará también todas las aplicaciones asociadas."
      variant="danger"
      confirmButtonText="Eliminar"
      @confirm="deleteJob"
      @cancel="showDeleteModal = false"
    />
  </div>
</template>

<script>
import BaseModal from '../../components/BaseModal.vue';
import ConfirmModal from '../../components/ConfirmModal.vue';
import { loadRecord, saveRecord } from '../../utils/dataHandler';

export default {
  name: 'AdminJobs',
  components: { BaseModal, ConfirmModal },
  data() {
    return {
      jobs: [],
      availableSkills: [],
      showSkills: false,
      isLoading: false,
      error: '',
      showModal: false,
      showDeleteModal: false,
      deletingJob: null,
      editingJob: null,
      form: {}
    };
  },
  async mounted() {
    await this.loadJobs();
    await this.loadSkills();
  },
  methods: {
    async loadJobs() {
      this.isLoading = true;
      try {
        this.jobs = await loadRecord('/api/jobs/all');
      } catch (err) {
        this.error = 'Error al cargar empleos';
      } finally {
        this.isLoading = false;
      }
    },
    async loadSkills() {
      try {
        this.availableSkills = await loadRecord('/api/skills');
      } catch (err) {
        console.error('Error loading skills:', err);
      }
    },
    formatDate(dateString) {
      if (!dateString) return 'N/A';
      return new Date(dateString).toLocaleDateString();
    },
    async editJob(job) {
      this.editingJob = job;
      try {
        const response = await fetch(`/api/jobs/${job.id}`);
        const jobDetails = await response.json();
        
        const skillIds = jobDetails.skills ? jobDetails.skills.map(s => parseInt(s.id, 10)) : [];
        
        this.form = { 
          title: job.title,
          status: job.status,
          description: job.description || jobDetails.description || '',
          skills: skillIds
        };
        this.showModal = true;
      } catch (err) {
        console.error('Error loading job details:', err);
        this.form = { 
          title: job.title,
          status: job.status,
          description: job.description || '',
          skills: []
        };
        this.showModal = true;
      }
    },
    toggleSkill(skillId) {
      const skillIdInt = parseInt(skillId, 10);
      const index = this.form.skills.findIndex(s => parseInt(s, 10) === skillIdInt);
      if (index > -1) {
        this.form.skills.splice(index, 1);
      } else {
        this.form.skills.push(skillIdInt);
      }
    },
    isSkillSelected(skillId) {
      const skillIdInt = parseInt(skillId, 10);
      return this.form.skills.some(s => parseInt(s, 10) === skillIdInt);
    },
    closeModal() {
      this.showModal = false;
      this.showSkills = false;
      this.editingJob = null;
      this.form = {
        title: '',
        status: '',
        description: '',
        skills: []
      };
    },
    async saveChanges() {
      try {
        await saveRecord('/api/jobs', this.editingJob.id, this.form);
        this.showModal = false;
        await this.loadJobs();
      } catch (err) {
        this.error = 'Error al guardar';
      }
    },
    confirmDelete(job) {
      this.deletingJob = job;
      this.showDeleteModal = true;
    },
    async deleteJob() {
      try {
        await fetch(`/api/jobs/${this.deletingJob.id}`, { method: 'DELETE' });
        this.showDeleteModal = false;
        this.deletingJob = null;
        await this.loadJobs();
      } catch (err) {
        this.error = 'Error al eliminar';
      }
    }
  }
};
</script>

<style scoped>
.admin-view {
  background-color: var(--color-card-bg);
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px var(--color-card-shadow);
  color: var(--color-text);
  border: 1px solid var(--color-border);
}

.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th,
.data-table td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid var(--color-border);
  color: var(--color-text);
}

.data-table th {
  font-weight: 600;
  color: var(--color-text);
  background-color: var(--color-card-shadow);
}

.status-badge {
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: 500;
}

.status-badge.activa {
  background-color: rgba(46, 204, 113, 0.2); 
  color: #2ecc71;
}

.status-badge.pendiente {
  background-color: rgba(241, 196, 15, 0.2);
  color: #f1c40f;
}

.status-badge.cerrada {
  background-color: rgba(127, 140, 141, 0.2);
  color: #7f8c8d;
}

.action-btn {
  padding: 0.25rem 0.75rem;
  border: 1px solid var(--color-border);
  background: var(--color-card-bg);
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.85rem;
  color: var(--color-text);
}

.action-btn:hover {
  background-color: var(--color-card-shadow);
  border-color: var(--color-text);
}

.toggle-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  padding: 0.5rem;
  background-color: var(--color-card-bg);
  border-radius: 4px;
  margin-bottom: 0.5rem;
}

.toggle-header:hover {
  background-color: var(--color-border);
}

.toggle-icon {
  font-size: 0.8rem;
  color: var(--color-text);
}

.chips-container {
  padding: 1rem;
  background-color: var(--color-bg);
  border-radius: 4px;
  max-height: 300px;
  overflow-y: auto;
}

.available-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.chip {
  padding: 0.5rem 1rem;
  background-color: var(--color-border);
  color: var(--color-text);
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.2s;
  user-select: none;
}

.chip:hover {
  background-color: var(--color-primary);
  color: white;
  transform: translateY(-2px);
}

.chip.selected {
  background-color: var(--color-primary);
  color: white;
  font-weight: 600;
}

.loading-state, .error-state {
  text-align: center;
  padding: 3rem;
  color: var(--color-text);
  opacity: 0.7;
}

.error-state { color: #e74c3c; opacity: 1; }

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
  color: var(--color-text);
  opacity: 0.9;
}

.modal-input {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid var(--color-border);
  border-radius: 4px;
  background-color: var(--color-background);
  color: var(--color-text);
  font-size: 0.95rem;
}

.modal-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.textarea {
  min-height: 100px;
  resize: vertical;
}

.select {
  cursor: pointer;
}
</style>

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
      </div>
    </BaseModal>
  </div>
</template>

<script>
import BaseModal from '../../components/BaseModal.vue';
import { loadRecord, saveRecord } from '../../utils/dataHandler';

export default {
  name: 'AdminJobs',
  components: { BaseModal },
  data() {
    return {
      jobs: [],
      isLoading: false,
      error: '',
      showModal: false,
      editingJob: null,
      form: {}
    };
  },
  async created() {
    await this.fetchJobs();
  },
  methods: {
    async fetchJobs() {
      this.isLoading = true;
      const data = await loadRecord('/api/jobs/all');
      this.isLoading = false;
      
      if (data) {
        this.jobs = data;
      }
    },
    formatDate(dateString) {
      if (!dateString) return 'N/A';
      return new Date(dateString).toLocaleDateString();
    },
    editJob(job) {
      this.editingJob = job;
      this.form = { 
        title: job.title,
        status: job.status,
        description: job.description
      };
      this.showModal = true;
    },
    closeModal() {
      this.showModal = false;
      this.editingJob = null;
      this.form = {};
    },
    async saveChanges() {
      if (!this.editingJob) return;
      
      const result = await saveRecord(
        `/api/jobs/${this.editingJob.id}`,
        'PUT',
        this.form,
        'Empleo actualizado correctamente'
      );

      if (result) {
        this.fetchJobs();
        this.closeModal();
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

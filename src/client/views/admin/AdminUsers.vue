<template>
  <div class="admin-users-view">
    <div class="tabs">
      <button 
        :class="['tab-btn', { active: activeTab === 'users' }]"
        @click="activeTab = 'users'"
      >
        Usuarios
      </button>
      <button 
        :class="['tab-btn', { active: activeTab === 'companies' }]"
        @click="activeTab = 'companies'"
      >
        Empresas
      </button>
    </div>

    <div v-if="isLoading" class="loading-state">
      Cargando datos...
    </div>

    <div v-else-if="error" class="error-state">
      {{ error }}
    </div>

    <div v-else class="content-area">
      <div v-if="activeTab === 'users'" class="users-table-container">
        <h3>Lista de Usuarios Registrados</h3>
        <table class="data-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Nombre</th>
              <th>Email</th>
              <th>Tipo</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in users" :key="user.id">
              <td>{{ user.id }}</td>
              <td>{{ user.name }}</td>
              <td>{{ user.email }}</td>
              <td>{{ user.userType }}</td>
              <td>
                <button class="action-btn edit" @click="editUser(user)">Editar</button>
                <button class="action-btn delete" @click="confirmDeleteUser(user)">Eliminar</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="activeTab === 'companies'" class="companies-table-container">
        <h3>Lista de Empresas Registradas</h3>
        <table class="data-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Empresa</th>
              <th>Email</th>
              <th>Ubicación</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="company in companies" :key="company.id">
              <td>{{ company.id }}</td>
              <td>{{ company.name }}</td>
              <td>{{ company.email }}</td> 
              <td>{{ company.location || 'N/A' }}</td>
              <td>
                <button class="action-btn edit" @click="editCompany(company)">Editar</button>
                <button class="action-btn delete" @click="confirmDeleteCompany(company)">Eliminar</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <BaseModal 
      v-if="showModal" 
      :title="editingItem && editingItem.type === 'company' ? 'Editar Empresa' : 'Editar Usuario'"
      @close="closeModal"
      @save="saveChanges"
    >
      <div v-if="editingItem" class="edit-form">
        <template v-if="editingItem.type === 'company'">
          <div class="form-group">
            <label>Nombre Empresa</label>
            <input v-model="form.name" class="modal-input" />
          </div>
          <div class="form-group">
            <label>Ubicación</label>
            <input v-model="form.location" class="modal-input" />
          </div>
           <div class="form-group">
            <label>Descripción</label>
            <textarea v-model="form.description" class="modal-input textarea"></textarea>
          </div>
        </template>
        
        <template v-else>
          <div class="form-group">
            <label>Nombre</label>
            <input v-model="form.name" class="modal-input" />
          </div>
          <div class="form-group">
            <label>Email</label>
            <input v-model="form.email" class="modal-input" />
          </div>
           <div class="form-group">
            <label>Tipo (client/admin)</label>
             <select v-model="form.userType" class="modal-input select">
              <option value="client">Cliente</option>
              <option value="admin">Administrador</option>
            </select>
          </div>
        </template>
      </div>
    </BaseModal>
    
    <ConfirmModal
      :show="showDeleteModal"
      :title="deleteType === 'user' ? 'Eliminar Usuario' : 'Eliminar Empresa'"
      :message="deleteType === 'user' ? '¿Estás seguro de eliminar este usuario?' : '¿Estás seguro de eliminar esta empresa?'"
      variant="danger"
      confirmButtonText="Eliminar"
      @confirm="executeDelete"
      @cancel="showDeleteModal = false"
    />
  </div>
</template>

<script>
import BaseModal from '../../components/BaseModal.vue';
import ConfirmModal from '../../components/ConfirmModal.vue';
import { loadRecord, saveRecord } from '../../utils/dataHandler';

export default {
  name: 'AdminUsers',
  components: { BaseModal, ConfirmModal },
  data() {
    return {
      activeTab: 'users',
      users: [],
      companies: [],
      isLoading: false,
      error: '',
      showModal: false,
      showDeleteModal: false,
      deleteType: null,
      deletingItem: null,
      editingItem: null,
      form: {}
    };
  },
  async created() {
    await this.fetchData();
  },
  methods: {
    async fetchData() {
      this.isLoading = true;
      this.error = '';
      
      const [usersData, companiesData] = await Promise.all([
          loadRecord('/api/users'),
          loadRecord('/api/companies')
      ]);

      if (usersData) this.users = usersData;
      if (companiesData) this.companies = companiesData;
      
      this.isLoading = false;
    },
    viewProfile(userId) {
      this.$router.push(`/user/${userId}`);
    },
    confirmDeleteUser(user) {
      this.deletingItem = user;
      this.deleteType = 'user';
      this.showDeleteModal = true;
    },
    confirmDeleteCompany(company) {
      this.deletingItem = company;
      this.deleteType = 'company';
      this.showDeleteModal = true;
    },
    async executeDelete() {
      try {
        const endpoint = this.deleteType === 'user' ? 'users' : 'companies';
        await fetch(`/api/${endpoint}/${this.deletingItem.id}`, { method: 'DELETE' });
        this.showDeleteModal = false;
        this.deletingItem = null;
        this.deleteType = null;
        await this.fetchData();
      } catch (err) {
        this.error = 'Error al eliminar';
      }
    },
    editUser(user) {
      this.editingItem = { ...user, type: 'user' };
      this.form = { ...user };
      this.showModal = true;
    },
    editCompany(company) {
      this.editingItem = { ...company, type: 'company' };
      this.form = { ...company };
      this.showModal = true;
    },
    closeModal() {
      this.showModal = false;
      this.editingItem = null;
      this.form = {};
    },
    async saveChanges() {
      if (!this.editingItem) return;

      let result;
      if (this.editingItem.type === 'company') {
        const payload = {
            ...this.form,
            companyName: this.form.name 
        };
        result = await saveRecord(
            `/api/companies/${this.editingItem.id}`,
            'PUT',
            payload,
            'Empresa actualizada correctamente'
        );
      } else {
        const [firstName, ...lastNameParts] = (this.form.name || '').split(' ');
        const payload = {
            ...this.form,
            firstName: firstName || '',
            lastName: lastNameParts.join(' ') || ''
        };
        result = await saveRecord(
            `/api/users/${this.editingItem.id}`,
            'PUT',
            payload,
            'Usuario actualizado correctamente'
        );
      }

      if (result) {
        this.fetchData();
        this.closeModal();
      }
    }
  }
};
</script>

<style scoped>
.admin-users-view {
  background-color: var(--color-card-bg);
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px var(--color-card-shadow);
  color: var(--color-text);
  border: 1px solid var(--color-border);
}

.tabs {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
  border-bottom: 1px solid var(--color-border);
  padding-bottom: 1rem;
}

.tab-btn {
  padding: 0.5rem 1.5rem;
  border: none;
  background: none;
  font-size: 1rem;
  font-weight: 500;
  color: var(--color-text);
  opacity: 0.7;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.2s;
}

.tab-btn:hover {
  background-color: var(--color-card-shadow);
  color: var(--color-primary);
  opacity: 1;
}

.tab-btn.active {
  background-color: var(--color-primary);
  color: white;
  opacity: 1;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 1rem;
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

.loading-state, .error-state {
  text-align: center;
  padding: 3rem;
  color: var(--color-text);
  opacity: 0.7;
}

.error-state {
  color: #e74c3c;
  opacity: 1;
}

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
  min-height: 80px;
  resize: vertical;
}

.select {
    cursor: pointer;
}
</style>

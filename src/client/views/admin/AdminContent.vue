<template>
  <div class="admin-view">
    <div class="header-actions">
      <h2>Gestión de Contenido</h2>
      <button class="primary-btn" @click="openCreateModal">
        <i class="fas fa-plus"></i> Nuevo Post
      </button>
    </div>

    <div v-if="isLoading" class="loading-state">
      Cargando artículos...
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
            <th>Autor</th>
            <th>Fecha</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="post in posts" :key="post.id">
            <td>{{ post.id }}</td>
            <td>{{ post.title }}</td>
            <td>{{ post.author }}</td>
            <td>{{ formatDate(post.date) }}</td>
            <td class="actions">
              <button class="action-btn edit" @click="openEditModal(post)">Editar</button>
              <button class="action-btn delete" @click="confirmDelete(post)">Eliminar</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
        <BaseModal
          v-if="showModal"
          :title="modalTitle"      @close="closeModal"
      @save="saveChanges"
    >
      <div class="edit-form">
        <div class="form-group">
          <label>Título</label>
          <input v-model="form.title" class="modal-input" />
        </div>
        <div class="form-group">
          <label>Autor</label>
          <select v-model="form.authorId" class="modal-input">
            <option value="">Seleccionar autor...</option>
            <option v-for="user in allUsers" :key="user.id" :value="user.id">
              {{ user.name }}
            </option>
          </select>
        </div>
         <div class="form-group">
          <label>Contenido</label>
          <textarea v-model="form.content" class="modal-input textarea"></textarea>
        </div>
      </div>
    </BaseModal>
    
    <ConfirmModal
      :show="showDeleteModal"
      title="Eliminar Post"
      message="¿Estás seguro de que deseas eliminar este post? Esta acción no se puede deshacer."
      variant="danger"
      confirmButtonText="Eliminar"
      @confirm="deletePost"
      @cancel="showDeleteModal = false"
    />
  </div>
</template>

<script>
import BaseModal from '../../components/BaseModal.vue';
import ConfirmModal from '../../components/ConfirmModal.vue';
import { loadRecord, saveRecord } from '../../utils/dataHandler';

export default {
  name: 'AdminContent',
  components: { BaseModal, ConfirmModal },
  data() {
    return {
      posts: [],
      allUsers: [],
      isLoading: false,
      error: '',
      showModal: false,
      showDeleteModal: false,
      deletingPost: null,
      editingPost: null,
      form: {},
      modalTitle: ''
    };
  },
  async mounted() {
    await this.loadPosts();
    await this.loadUsers();
  },
  methods: {
    async loadPosts() {
      this.isLoading = true;
      try {
        this.posts = await loadRecord('/api/blog');
      } catch (err) {
        this.error = 'Error al cargar posts';
      } finally {
        this.isLoading = false;
      }
    },
    async loadUsers() {
      try {
        const users = await loadRecord('/api/users');
        const companies = await loadRecord('/api/companies');
        this.allUsers = [
          ...users.map(u => ({ id: u.id, name: `${u.firstName} ${u.lastName}` })),
          ...companies.map(c => ({ id: c.id, name: c.companyName }))
        ];
      } catch (err) {
        console.error('Error loading users:', err);
      }
    },
    formatDate(dateString) {
      if (!dateString) return 'N/A';
      return new Date(dateString).toLocaleDateString();
    },
    openCreateModal() {
      this.editingPost = null;
      this.form = {
        title: '',
        authorId: '',
        content: ''
      };
      this.modalTitle = 'Crear Publicación';
      this.showModal = true;
    },
        openEditModal(post) {
          this.editingPost = post;
          this.form = {
            title: post.title,
            authorId: post.authorId || '',
            content: post.content || '',
            excerpt: post.excerpt || ''
          };
          this.modalTitle = 'Editar Publicación';
          this.showModal = true;
        },    closeModal() {
      this.showModal = false;
      this.editingPost = null;
      this.form = {};
    },
    async saveChanges() {
      try {
        if (this.editingPost) {
          await saveRecord('/api/blog', this.editingPost.id, this.form);
        } else {
          await saveRecord('/api/blog', null, this.form);
        }
        this.showModal = false;
        await this.loadPosts();
      } catch (err) {
        this.error = 'Error al guardar';
      }
    },
    confirmDelete(post) {
      this.deletingPost = post;
      this.showDeleteModal = true;
    },
    async deletePost() {
      try {
        await fetch(`/api/blog/${this.deletingPost.id}`, { method: 'DELETE' });
        this.showDeleteModal = false;
        this.deletingPost = null;
        await this.loadPosts();
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

.primary-btn {
  background-color: var(--color-primary);
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  gap: 0.5rem;
  font-weight: 500;
  min-width: 140px;
}

.primary-btn:hover {
  opacity: 0.9;
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
  min-height: 80px;
  resize: vertical;
}
</style>

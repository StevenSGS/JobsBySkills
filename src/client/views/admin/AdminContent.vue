<template>
  <div class="admin-view">
    <div class="header-actions">
      <h2>Gestión de Contenido (Blog)</h2>
      <button class="primary-btn" @click="createPost">
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
            <td>
              <button class="action-btn edit" @click="editPost(post)">Editar</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <BaseModal 
      v-if="showModal" 
      title="Editar Publicación"
      @close="closeModal"
      @save="saveChanges"
    >
      <div v-if="editingPost" class="edit-form">
        <div class="form-group">
          <label>Título</label>
          <input v-model="form.title" class="modal-input" />
        </div>
        <div class="form-group">
          <label>Autor</label>
          <input v-model="form.author" class="modal-input" />
        </div>
         <div class="form-group">
          <label>Contenido</label>
          <textarea v-model="form.content" class="modal-input textarea"></textarea>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script>
import BaseModal from '../../components/BaseModal.vue';
import { loadRecord, saveRecord } from '../../utils/dataHandler';

export default {
  name: 'AdminContent',
  components: { BaseModal },
  data() {
    return {
      posts: [],
      isLoading: false,
      error: '',
      showModal: false,
      editingPost: null,
      form: {}
    };
  },
  async created() {
    await this.fetchPosts();
  },
  methods: {
    async fetchPosts() {
      this.isLoading = true;
      const data = await loadRecord('/api/blog');
      this.isLoading = false;
      
      if (data) {
          this.posts = data;
      }
    },
    formatDate(dateString) {
      if (!dateString) return 'N/A';
      return new Date(dateString).toLocaleDateString();
    },
    editPost(post) {
      this.editingPost = post;
      this.form = { ...post };
      this.showModal = true;
    },
    createPost() {
        this.editingPost = null; 
        this.form = { title: '', author: '', content: '' };
        this.showModal = true;
    },
    closeModal() {
      this.showModal = false;
      this.editingPost = null;
      this.form = {};
    },
    async saveChanges() {
       let result;
       
       if (this.editingPost && this.editingPost.id) {
           result = await saveRecord(
               `/api/blog/${this.editingPost.id}`,
               'PUT',
               this.form,
               'Publicación actualizada correctamente'
           );
       } else {
           result = await saveRecord(
               '/api/blog',
               'POST',
               this.form,
               'Publicación creada correctamente'
           );
       }

       if (result) {
           this.fetchPosts();
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

<template>
  <div class="edit-profile-view container">
    <BaseCard class="edit-profile-card">
      <h2>Editar Perfil de Empresa</h2>

      <form @submit.prevent="saveProfile" class="profile-form">
        <h3>Información de la Empresa</h3>
        <InputField
          id="companyName"
          label="Nombre de la Empresa"
          type="text"
          v-model="company.companyName"
          required
        />
        <InputField
          id="location"
          label="Ubicación"
          type="text"
          v-model="company.location"
          required
        />
        
        <div class="form-row">
          <InputField
            id="industry"
            label="Industria"
            type="text"
            v-model="company.industry"
            required
            class="half-width"
          />
          <InputField
            id="size"
            label="Tamaño (Empleados)"
            type="text"
            v-model="company.size"
            required
            class="half-width"
          />
        </div>

        <InputField
          id="website"
          label="Sitio Web"
          type="url"
          v-model="company.website"
          placeholder="https://ejemplo.com"
        />

        <div class="form-group">
          <div class="values-header" @click="valuesExpanded = !valuesExpanded">
            <label>Nuestros Valores</label>
            <span class="toggle-icon">{{ valuesExpanded ? '▼' : '▶' }}</span>
          </div>
          <div v-show="valuesExpanded" class="values-grid">
            <div 
              v-for="val in availableValues" 
              :key="val"
              class="value-chip"
              :class="{ 'active': company.values.includes(val) }"
              @click="toggleValue(val)"
            >
              {{ val }}
              <span v-if="company.values.includes(val)" class="check-icon">✓</span>
            </div>
          </div>
        </div>

        <div class="form-group">
          <label for="description">Descripción</label>
          <textarea
            id="description"
            v-model="company.description"
            class="input-field textarea"
            rows="5"
            required
          ></textarea>
        </div>

        <div class="form-actions">
          <BaseButton type="primary">Guardar Cambios</BaseButton>
        </div>
      </form>

      <div class="back-to-profile">
        <BaseButton type="text" @click="goBack">Volver al Perfil</BaseButton>
      </div>
    </BaseCard>
  </div>
</template>

<script>
import InputField from '../components/InputField.vue';
import BaseButton from '../components/BaseButton.vue';
import BaseCard from '../components/BaseCard.vue';
import authStore from '../store/authStore';
import { saveRecord, loadRecord } from '../utils/dataHandler';

export default {
  name: 'EditCompanyView',
  components: {
    InputField,
    BaseButton,
    BaseCard,
  },
  data() {
    return {
      company: {
        companyName: '',
        location: '',
        industry: '',
        size: '',
        website: '',
        description: '',
        values: [],
      },
      availableValues: [],
      valuesExpanded: false,
    };
  },
  async mounted() {
    const user = authStore.state.userData;
    
    if (!user || authStore.state.userType !== 'company') {
      
    }

    const [companyData, valuesData] = await Promise.all([
         loadRecord(`/api/companies/${user.id}`),
         loadRecord(`/api/companies/values/catalog`)
    ]);

    if (valuesData) {
        this.availableValues = valuesData;
    }

    if (companyData) {
        this.company.companyName = companyData.name;
        this.company.location = companyData.location || '';
        this.company.industry = companyData.industry || '';
        this.company.size = companyData.size || '';
        this.company.website = companyData.website || '';
        this.company.description = companyData.description || '';
        this.company.values = Array.isArray(companyData.values) ? companyData.values : [];
    }
  },
  methods: {
    async saveProfile() {
      const user = authStore.state.userData;
      if (!user) return;

      const result = await saveRecord(
        `/api/companies/${user.id}`,
        'PUT',
        {
          companyName: this.company.companyName,
          location: this.company.location,
          industry: this.company.industry,
          size: this.company.size,
          website: this.company.website,
          description: this.company.description,
          values: this.company.values
        },
        'Perfil de empresa actualizado correctamente'
      );

      if (result) {
        const updatedUser = { 
            ...user, 
            companyName: this.company.companyName,
            name: this.company.companyName 
        };
        authStore.methods.updateUserSession(updatedUser);
        this.$router.push(`/company/profile/${user.id}`);
      }
    },
    goBack() {
       const user = authStore.state.userData;
       if (user) {
           this.$router.push(`/company/profile/${user.id}`);
       } else {
           this.$router.push('/');
       }
    },
    toggleValue(val) {
        if (this.company.values.includes(val)) {
            this.company.values = this.company.values.filter(v => v !== val);
        } else {
            this.company.values.push(val);
        }
    }
  },
};
</script>

<style scoped>
.edit-profile-view {
  display: flex;
  justify-content: center;
  align-items: flex-start;
  min-height: calc(100vh - var(--navbar-height, 4rem));
  padding-bottom: 2rem;
}

.edit-profile-card {
  max-width: 700px;
  width: 100%;
  padding: 2rem;
}

.edit-profile-card h2 {
  font-size: 2rem;
  margin-bottom: 2rem;
  text-align: center;
  color: var(--color-text);
}

.profile-form {
  padding-bottom: 1.5rem;
}

.profile-form h3 {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  color: var(--color-text);
  border-bottom: 1px solid var(--color-border);
  padding-bottom: 0.5rem;
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: var(--color-text);
}

.input-field {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 1px solid var(--color-border);
    border-radius: 8px;
    font-size: 1rem;
    background-color: var(--color-background);
    color: var(--color-text);
    transition: border-color 0.2s, box-shadow 0.2s;
}

.input-field:focus {
    outline: none;
    border-color: var(--color-primary);
    box-shadow: 0 0 0 3px var(--color-primary-light);
}

.textarea {
    font-family: inherit;
    resize: vertical;
}

.form-row {
    display: flex;
    gap: 1.5rem;
}

.half-width {
    flex: 1;
}

.values-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    user-select: none;
    padding: 0.5rem;
    border-radius: 4px;
    transition: background-color 0.2s;
}

.values-header:hover {
    background-color: var(--color-card-shadow);
}

.toggle-icon {
    font-size: 0.8rem;
    color: var(--color-text);
    opacity: 0.7;
}

.values-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
    margin-top: 0.5rem;
}

.value-chip {
    padding: 0.5rem 1rem;
    background-color: var(--color-background);
    border: 1px solid var(--color-border);
    border-radius: 999px;
    cursor: pointer;
    font-size: 0.9rem;
    transition: all 0.2s ease;
    user-select: none;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.value-chip:hover {
    border-color: var(--color-primary);
    background-color: rgba(var(--color-primary-rgb), 0.05);
}

.value-chip.active {
    background-color: var(--color-primary);
    color: white;
    border-color: var(--color-primary);
}

.check-icon {
    font-weight: bold;
    font-size: 0.8rem;
}

.profile-form .form-actions {
  margin-top: 2rem;
  display: flex;
  justify-content: center;
}

.back-to-profile {
  text-align: center;
  margin-top: 1rem;
  border-top: 1px solid var(--color-border);
  padding-top: 1rem;
}
</style>

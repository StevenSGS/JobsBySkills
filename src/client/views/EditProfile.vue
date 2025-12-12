<template>
  <div class="edit-profile-view container">
    <BaseCard class="edit-profile-card">
      <h2>Editar Perfil</h2>

      <form @submit.prevent="saveProfile" class="profile-form">
        <h3>Información Personal</h3>
        <InputField
          id="editName"
          label="Nombre Completo"
          type="text"
          v-model="user.name"
          required
        />
        <InputField
          id="editEmail"
          label="Correo Electrónico"
          type="email"
          v-model="user.email"
          required
        />
        <div class="form-group">
          <div class="skills-header" @click="skillsExpanded = !skillsExpanded">
            <label>Habilidades</label>
            <span class="toggle-icon">{{ skillsExpanded ? '▼' : '▶' }}</span>
          </div>
          <div v-show="skillsExpanded" class="skills-selection">
            <div class="available-skills">
              <span 
                v-for="skill in availableSkills" 
                :key="skill"
                :class="['skill-chip', { selected: user.skills.includes(skill) }]"
                @click="toggleSkill(skill)"
              >
                {{ skill }}
              </span>
            </div>
          </div>
        </div>
        <div class="form-actions">
          <BaseButton type="primary">Guardar Cambios</BaseButton>
        </div>
      </form>

      <form @submit.prevent="changePassword" class="password-form">
        <h3>Cambiar Contraseña</h3>
        <InputField
          id="currentPassword"
          label="Contraseña Actual"
          type="password"
          v-model="passwords.current"
          placeholder="********"
          required
        />
        <InputField
          id="newPassword"
          label="Nueva Contraseña"
          type="password"
          v-model="passwords.new"
          placeholder="********"
          required
        />
        <InputField
          id="confirmNewPassword"
          label="Confirmar Nueva Contraseña"
          type="password"
          v-model="passwords.confirm"
          placeholder="********"
          required
        />
        <BaseButton type="primary">Cambiar Contraseña</BaseButton>
      </form>

      <div class="back-to-profile">
        <router-link to="/profile">
          <BaseButton type="text">Volver al Perfil</BaseButton>
        </router-link>
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
  name: 'EditProfileView',
  components: {
    InputField,
    BaseButton,
    BaseCard,
  },
  data() {
    return {
      user: {
        name: '',
        email: '',
        skills: [],
      },
      passwords: {
        current: '',
        new: '',
        confirm: '',
      },
      availableSkills: [],
      skillsExpanded: false,
    };
  },
  async mounted() {
    const userId = authStore.state.userData?.id;
    
    if (!userId) {
      this.$router.push('/login');
      return;
    }
    
    const [userData, skillsData] = await Promise.all([
      loadRecord(`/api/users/${userId}`),
      loadRecord('/api/skills')
    ]);
    
    if (skillsData) {
      this.availableSkills = skillsData.map(s => s.name);
    }
    
    if (userData) {
        this.user.name = userData.name;
        this.user.email = userData.email;
        this.user.skills = Array.isArray(userData.skills) ? userData.skills : [];
    }
  },
  methods: {
    toggleSkill(skill) {
      if (this.user.skills.includes(skill)) {
        this.user.skills = this.user.skills.filter(s => s !== skill);
      } else {
        this.user.skills.push(skill);
      }
    },
    async saveProfile() {
      const userId = authStore.state.userData?.id;
      
      if (!userId) {
        this.$router.push('/login');
        return;
      }
      
      const updates = {
        name: this.user.name,
        email: this.user.email,
        skills: this.user.skills
      };

      const result = await saveRecord(
        `/api/users/${userId}`, 
        'PUT', 
        updates, 
        'Perfil actualizado correctamente'
      );

      if (result) {
          const updatedUser = { 
              ...authStore.state.userData, 
              ...updates 
          };
          authStore.methods.updateUserSession(updatedUser);
      }
    },
    changePassword() {
      // Future: Use dataHandler to call /api/users/:id/password
      alert('Cambio de contraseña pendiente de implementación en backend');
      this.passwords = { current: '', new: '', confirm: '' };
    },
  },
};
</script>

<style scoped>
.edit-profile-view {
  display: flex;
  justify-content: center;
  align-items: flex-start;
  min-height: calc(100vh - var(--navbar-height, 4rem));
}

.edit-profile-card {
  max-width: 600px;
  width: 100%;
  padding: 2rem;
}

.edit-profile-card h2 {
  font-size: 2rem;
  margin-bottom: 2rem;
  text-align: center;
  color: var(--color-text);
}

.profile-form, .password-form {
  margin-bottom: 2.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid var(--color-border);
}

.password-form {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.profile-form h3, .password-form h3 {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  color: var(--color-text);
}

.form-group label {
  display: block;
  margin-bottom: 1rem;
  font-weight: 500;
  color: var(--color-text);
}

.profile-form .form-actions {
  margin-top: 1.5rem;
  display: flex;
  justify-content: center;
  gap: 1rem;
}

.password-form .base-button {
  margin-top: 1rem;
  width: auto;
}

.back-to-profile {
  text-align: center;
  margin-top: 2rem;
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

.skills-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  user-select: none;
  padding: 0.5rem;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.skills-header:hover {
  background-color: var(--color-card-shadow);
}

.toggle-icon {
  font-size: 0.8rem;
  color: var(--color-text);
  opacity: 0.7;
}
</style>

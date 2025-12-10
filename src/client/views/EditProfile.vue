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
          <label for="editSkills">Habilidades</label>
          <input
            id="editSkills"
            type="text"
            v-model="skillsInput"
            class="input-field"
          />
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
      skillsInput: '',
    };
  },
  async mounted() {
    const userId = authStore.state.userData?.id;
    
    if (!userId) {
      this.$router.push('/login');
      return;
    }
    
    try {
      const res = await fetch(`/api/users/${userId}`);
      if (res.ok) {
        const userData = await res.json();
        this.user.name = userData.name;
        this.user.email = userData.email;
        this.user.skills = userData.skills || [];
        this.skillsInput = this.user.skills.join(', ');
      }
    } catch (err) {
      console.error('Error loading user:', err);
    }
  },
  methods: {
    async saveProfile() {
      const userId = authStore.state.userData?.id;
      
      if (!userId) {
        this.$router.push('/login');
        return;
      }
      
      const skills = this.skillsInput.split(',').map(s => s.trim()).filter(s => s);
      const [firstName, ...lastNameParts] = this.user.name.split(' ');
      const lastName = lastNameParts.join(' ');
      
      try {
        const res = await fetch(`/api/users/${userId}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            firstName,
            lastName,
            email: this.user.email,
            skills
          })
        });
        
        if (res.ok) {
          alert('Perfil actualizado correctamente');
        }
      } catch (err) {
        console.error('Error updating profile:', err);
      }
    },
    changePassword() {
      alert('Contraseña cambiada (simulado)');
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
</style>

<template>
  <div class="signup-view container">
    <BaseCard class="signup-card">
      <h2>Crear Cuenta de Empresa</h2>
      
      <div v-if="error" class="error-box">
        {{ error }}
      </div>

      <form @submit.prevent="handleSignup">
        <InputField
          id="companyName"
          label="Nombre de la Empresa"
          type="text"
          v-model="companyName"
          placeholder="Tu Empresa S.A."
          required
        />
        <InputField
          id="email"
          label="Correo Electrónico de Contacto"
          type="email"
          v-model="email"
          placeholder="contacto@tuempresa.com"
          required
        />
        <InputField
          id="password"
          label="Contraseña"
          type="password"
          v-model="password"
          placeholder="********"
          required
        />
        <BaseButton type="primary" @click="handleSignup">Crear Cuenta</BaseButton>
      </form>
      <p class="alt-action">
        ¿Ya tienes una cuenta de empresa? <router-link to="/company/login">Inicia Sesión</router-link>
      </p>
    </BaseCard>
  </div>
</template>

<script>
import InputField from '../../components/InputField.vue';
import BaseButton from '../../components/BaseButton.vue';
import BaseCard from '../../components/BaseCard.vue';
import authStore from '../../store/authStore';

export default {
  name: 'CompanySignupView',
  components: {
    InputField,
    BaseButton,
    BaseCard,
  },
  data() {
    return {
      companyName: '',
      email: '',
      password: '',
      location: '',
      industry: '',
      size: '',
      error: '',
      isLoading: false,
    };
  },
  methods: {
    async handleSignup() {
      this.isLoading = true;
      this.error = '';

      try {
        const res = await fetch('/api/auth/company-register', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            companyName: this.companyName,
            email: this.email,
            password: this.password,
            location: this.location || 'N/A',
            industry: this.industry || 'Tecnología',
            size: this.size || 'N/A'
          }),
        });

        const data = await res.json();

        if (!res.ok) {
          throw new Error(data.error || 'Error al crear cuenta de empresa');
        }

        authStore.methods.login({
          id: data.id,
          name: data.name,
          email: data.email,
          userType: 'company'
        });

        this.$router.push('/company/requests');
      } catch (err) {
        this.error = err.message;
      } finally {
        this.isLoading = false;
      }
    },
  },
};
</script>

<style scoped>

.signup-view {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 2rem 0;
}

.signup-card {
  max-width: 400px;
  width: 100%;
  text-align: center;
}

.signup-card h2 {
  font-size: 2rem;
  margin-bottom: 1.5rem;
  color: var(--color-text);
}

.signup-card form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.signup-card .alt-action {
  margin-top: 1.5rem;
  font-size: 0.9rem;
  color: var(--color-text);
}

.error-box {
  background-color: #fee;
  border: 1px solid #fcc;
  border-left: 4px solid #f44;
  color: #c33;
  padding: 1rem;
  margin-bottom: 1.5rem;
  border-radius: 4px;
  text-align: left;
}
</style>

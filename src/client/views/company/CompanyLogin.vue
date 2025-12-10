<template>
  <div class="company-login-view container">
    <BaseCard class="login-card">
      <h2>Iniciar Sesión - Empresa</h2>
      
      <div v-if="errorMessage" class="error-box">
        {{ errorMessage }}
      </div>

      <form @submit.prevent="handleLogin" class="login-form">
        <InputField
          id="email"
          label="Correo Electrónico"
          type="text"
          v-model="email"
          placeholder="empresa@correo.com"
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
        <BaseButton type="primary">Iniciar Sesión</BaseButton>
      </form>

      <p class="signup-link">
        ¿No tienes cuenta? <router-link to="/company/signup">Regístrate aquí</router-link>
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
  name: 'CompanyLoginView',
  components: {
    InputField,
    BaseButton,
    BaseCard,
  },
  data() {
    return {
      email: '',
      password: '',
      errorMessage: '',
    };
  },
  methods: {
    async handleLogin() {
      this.errorMessage = '';
      
      if (!this.email || !this.password) {
        this.errorMessage = 'Por favor completa todos los campos.';
        return;
      }

      try {
        const res = await fetch('/api/companies/login', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            email: this.email,
            password: this.password
          })
        });

        const data = await res.json();

        if (!res.ok) {
          this.errorMessage = data.error || 'Error al iniciar sesión.';
          return;
        }

        if (data.userType === 'admin') {
          authStore.methods.login(data);
        } else {
          authStore.methods.login(data);
        }
        
        this.$router.push('/company/requests');
      } catch (err) {
        this.errorMessage = 'Error de conexión. Intenta nuevamente.';
        console.error('Login error:', err);
      }
    },
  },
};
</script>

<style scoped>
.company-login-view {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - var(--navbar-height, 4rem));
}

.login-card {
  max-width: 400px;
  width: 100%;
  padding: 2rem;
}

.login-card h2 {
  font-size: 2rem;
  margin-bottom: 1.5rem;
  text-align: center;
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
  font-size: 0.95rem;
  line-height: 1.5;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.signup-link {
  text-align: center;
  margin-top: 1.5rem;
  color: var(--color-text);
}

.signup-link a {
  color: var(--color-primary);
  font-weight: 500;
}
</style>

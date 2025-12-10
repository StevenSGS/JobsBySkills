<template>
  <div class="signup-view container">
    <BaseCard class="signup-card">
      <h2>Registro</h2>
      
      <div v-if="error" class="error-box">
        {{ error }}
      </div>

      <form @submit.prevent="handleSignup">
        <InputField
          id="name"
          label="Nombre Completo"
          type="text"
          v-model="name"
          placeholder="Tu Nombre"
          required
        />
        <InputField
          id="email"
          label="Correo Electrónico"
          type="email"
          v-model="email"
          placeholder="tu@ejemplo.com"
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
        <InputField
          id="confirmPassword"
          label="Confirmar Contraseña"
          type="password"
          v-model="confirmPassword"
          placeholder="********"
          required
        />
        <BaseButton type="primary" @click="handleSignup">Registrarse</BaseButton>
      </form>
      <p class="alt-action">
        ¿Ya tienes cuenta? <router-link to="/login">Inicia Sesión</router-link>
      </p>
    </BaseCard>
  </div>
</template>

<script>
import InputField from '../components/InputField.vue';
import BaseButton from '../components/BaseButton.vue';
import BaseCard from '../components/BaseCard.vue';
import authStore from '../store/authStore';

export default {
  name: 'SignupView',
  components: {
    InputField,
    BaseButton,
    BaseCard,
  },
  data() {
    return {
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
      error: '',
      isLoading: false,
    };
  },
  methods: {
    async handleSignup() {
      if (this.password !== this.confirmPassword) {
        this.error = 'Las contraseñas no coinciden';
        return;
      }

      this.isLoading = true;
      this.error = '';

      try {
        const res = await fetch('/api/auth/register', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            firstName: this.name.split(' ')[0] || this.name, 
            lastName: this.name.split(' ').slice(1).join(' ') || 'User',
            email: this.email,
            password: this.password,
          }),
        });

        const data = await res.json();

        if (!res.ok) {
          throw new Error(data.error || 'Error al registrarse');
        }

        authStore.methods.login({
          id: data.id,
          name: data.name,
          email: data.email,
          userType: 'client'
        });

        this.$router.push('/');
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

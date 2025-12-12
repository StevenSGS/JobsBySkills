<template>
  <nav class="navbar">
    <div class="container navbar-container">
      <div class="navbar-left">
        <router-link to="/" class="navbar-brand">JobsBySkills</router-link>
        <nav class="nav-links">
          <template v-if="userType === 'admin'">
             <router-link :to="{ name: 'AdminHome' }" class="nav-link">Dashboard</router-link>
             <router-link :to="{ name: 'AdminUsers' }" class="nav-link">Usuarios</router-link>
             <router-link :to="{ name: 'AdminJobs' }" class="nav-link">Empleos</router-link>
             <router-link :to="{ name: 'AdminContent' }" class="nav-link">Contenido</router-link>
          </template>

          <template v-else-if="userType === 'company'">
            <router-link to="/company/requests" class="nav-link">Mis Solicitudes</router-link>
            <router-link to="/clients" class="nav-link">Para Clientes</router-link>
            <router-link to="/blog" class="nav-link">Blog</router-link>
            <router-link to="/about" class="nav-link">Acerca de</router-link>
          </template>

          <template v-else-if="userType === 'client'">
            <router-link to="/jobs" class="nav-link">Empleos</router-link>
            <router-link to="/companies" class="nav-link">Para Empresas</router-link>
            <router-link to="/blog" class="nav-link">Blog</router-link>
            <router-link to="/about" class="nav-link">Acerca de</router-link>
          </template>

          <template v-else>
            <router-link to="/" class="nav-link">Inicio</router-link>
            <router-link to="/jobs" class="nav-link">Empleos</router-link>
            <router-link to="/companies" class="nav-link">Para Empresas</router-link>
            <router-link to="/clients" class="nav-link">Para Clientes</router-link>
            <router-link to="/blog" class="nav-link">Blog</router-link>
            <router-link to="/about" class="nav-link">Acerca de</router-link>
          </template>
        </nav>
      </div>

      <div class="navbar-center">
        <div class="search-bar-nav">
          <input type="text" placeholder="Buscar empleos...">
          <BaseButton type="primary">Buscar</BaseButton>
        </div>
      </div>

      <div class="navbar-right">
        <button @click="toggleTheme" class="theme-switcher">
          <img v-if="isDarkMode" src="/icons/sun.svg" alt="Light Mode" />
          <img v-else src="/icons/moon.svg" alt="Dark Mode" />
        </button>

        <template v-if="isLoggedIn">
          <router-link :to="accountLink" class="account-link" v-if="userType !== 'admin'">
            <img src="/icons/account.svg" alt="Cuenta" class="account-icon" />
            <span>{{ accountName }}</span>
          </router-link>
          <div class="account-display" v-else>
            <img src="/icons/account.svg" alt="Admin" class="account-icon" />
            <span>{{ accountName }}</span>
          </div>
          <BaseButton type="secondary" @click="handleLogout">Cerrar Sesión</BaseButton>
        </template>
        <template v-else>
          <router-link to="/login">
            <BaseButton type="secondary">Iniciar Sesión</BaseButton>
          </router-link>
          <router-link to="/signup">
            <BaseButton type="primary">Registrarse</BaseButton>
          </router-link>
        </template>
      </div>
    </div>
  </nav>
</template>

<script>
import BaseButton from './BaseButton.vue';
import authStore from '../store/authStore';

export default {
  name: 'Navbar',
  components: {
    BaseButton,
  },
  data() {
    return {
      isDarkMode: false,
    };
  },
  computed: {
    authState() {
      return authStore.state;
    },
    authStoreState() {
      return authStore.state;
    },
    userType() {
      return authStore.state.userType;
    },
    isLoggedIn() {
      return authStore.state.isAuthenticated;
    },
    accountName() {
      if (this.userType === 'admin') {
        return 'Administrador';
      }
      return this.authState.userData?.name || this.authState.userData?.companyName || 'Usuario';
    },
    accountLink() {
      if (this.userType === 'company') {
        const companyId = this.authState.userData?.id || 1;
        return `/company/profile/${companyId}`;
      }
      return '/profile';
    },
  },
  mounted() {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
      this.isDarkMode = true;
      document.documentElement.classList.add('dark-theme');
    } else {
      this.isDarkMode = false;
      document.documentElement.classList.remove('dark-theme');
    }
  },
  methods: {
    toggleTheme() {
      this.isDarkMode = !this.isDarkMode;
      if (this.isDarkMode) {
        document.documentElement.classList.add('dark-theme');
        localStorage.setItem('theme', 'dark');
      } else {
        document.documentElement.classList.remove('dark-theme');
        localStorage.setItem('theme', 'light');
      }
    },
    handleLogout() {
      authStore.methods.logout();
      this.$router.push('/');
    }
  }
};
</script>

<style scoped>
.navbar {
  background-color: var(--color-card-bg);
  border-bottom: 1px solid var(--color-border);
  padding: 1rem 0;
  box-shadow: 0 2px 4px var(--color-card-shadow);
}

.navbar-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.navbar-left, .navbar-right {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  flex-shrink: 1;
}

.navbar-right {
  min-width: fit-content;
}

.navbar-center {
  flex-grow: 1;
  flex-shrink: 1;
  display: flex;
  justify-content: center;
  padding: 0 2rem;
}

.navbar-brand {
  font-weight: bold;
  font-size: 1.5rem;
  color: var(--color-text);
  text-decoration: none;
  white-space: nowrap;
  flex-shrink: 0;
}

.nav-links {
  display: flex;
  gap: 1.5rem;
  align-items: center;
  flex-shrink: 1;
}

.nav-link {
  font-weight: 500;
  color: var(--color-text);
  text-decoration: none;
  transition: color 0.2s;
  white-space: nowrap;
  flex-shrink: 0;
}

.nav-link:hover {
  color: var(--color-primary);
}

.search-bar-nav {
  display: flex;
  width: 100%;
  max-width: 400px;
  min-width: 250px;
}

.search-bar-nav input {
  width: 100%;
  padding: 0.5rem 1rem;
  border: 1px solid var(--color-border);
  border-radius: 8px 0 0 8px;
  font-size: 0.9rem;
  background-color: var(--color-background);
  color: var(--color-text);
}

.search-bar-nav .button-primary {
  border-radius: 0 8px 8px 0;
  padding: 0.5rem 1rem;
}

.theme-switcher {
  background: none;
  border: none;
  cursor: pointer;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--color-text);
  flex-shrink: 0;
}

.theme-switcher img {
  width: 100%;
  height: 100%;
}

.account-link, .account-display {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--color-text);
  text-decoration: none;
  font-weight: 500;
  white-space: nowrap;
  flex-shrink: 0;
}

.account-link:hover {
  color: var(--color-primary);
}

.account-icon {
  width: 24px;
  height: 24px;
  filter: invert(var(--color-text-filter-value, 0));
  flex-shrink: 0;
}
</style>

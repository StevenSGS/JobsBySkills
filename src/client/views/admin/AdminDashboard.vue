<template>
  <div class="admin-dashboard container">
    <div class="admin-sidebar">
      <h3>Panel de Control</h3>
      <ul class="admin-nav">
        <li>
          <router-link :to="{ name: 'AdminHome' }" exact-active-class="active">
            <i class="fas fa-chart-line"></i> Dashboard Principal
          </router-link>
        </li>
        <li>
          <router-link :to="{ name: 'AdminUsers' }" active-class="active">
            <i class="fas fa-users-cog"></i> Usuarios y Empresas
          </router-link>
        </li>
        <li>
          <router-link :to="{ name: 'AdminJobs' }" active-class="active">
            <i class="fas fa-briefcase"></i> Empleos y Solicitudes
          </router-link>
        </li>
        <li>
          <router-link :to="{ name: 'AdminContent' }" active-class="active">
            <i class="fas fa-newspaper"></i> Blog y Contenido
          </router-link>
        </li>
      </ul>
    </div>
    
    <div class="admin-content">
      <router-view :key="$route.fullPath"></router-view>
    </div>
  </div>
</template>

<script>
import BaseCard from '../../components/BaseCard.vue';

export default {
  name: 'AdminDashboard',
  components: {
    BaseCard
  }
};
</script>

<style scoped>
.admin-dashboard {
  display: flex;
  gap: 2rem;
  padding-top: 2rem;
  min-height: 80vh;
}

.admin-sidebar {
  width: 250px;
  flex-shrink: 0;
  background-color: var(--color-card-bg);
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px var(--color-card-shadow);
  height: fit-content;
  color: var(--color-text);
  border: 1px solid var(--color-border);
}

.admin-sidebar h3 {
  margin-bottom: 1.5rem;
  color: var(--color-primary);
  border-bottom: 2px solid var(--color-border);
  padding-bottom: 0.5rem;
}

.admin-nav {
  list-style: none;
  padding: 0;
}

.admin-nav li {
  margin-bottom: 0.5rem;
}

.admin-nav a {
  display: block;
  padding: 0.75rem 1rem;
  text-decoration: none;
  color: var(--color-text);
  border-radius: 4px;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.admin-nav a:hover,
.admin-nav .active {
  background-color: var(--color-primary);
  color: #FFFFFF; 
}

.admin-content {
  flex-grow: 1;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  padding: 1.5rem;
  background-color: var(--color-card-bg);
  color: var(--color-text);
  border: 1px solid var(--color-border);
}

.stat-icon {
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 1.5rem;
  color: white;
}

.stat-card.blue .stat-icon { background: #3498db; }
.stat-card.green .stat-icon { background: #2ecc71; }
.stat-card.purple .stat-icon { background: #9b59b6; }
.stat-card.orange .stat-icon { background: #e67e22; }

.stat-info h3 {
  font-size: 0.9rem;
  color: var(--color-text);
  opacity: 0.7;
  margin-bottom: 0.25rem;
}

.stat-number {
  font-size: 1.8rem;
  font-weight: bold;
  color: var(--color-text);
  margin-bottom: 0.25rem;
}

.stat-trend {
  font-size: 0.8rem;
  color: #2ecc71;
}

.recent-activity {
  background-color: var(--color-card-bg);
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px var(--color-card-shadow);
  color: var(--color-text);
  border: 1px solid var(--color-border);
}
</style>

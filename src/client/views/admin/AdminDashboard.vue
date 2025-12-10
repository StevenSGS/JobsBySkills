<template>
  <div class="admin-dashboard container">
    <div class="admin-sidebar">
      <h3>Panel de Control</h3>
      <ul class="admin-nav">
        <li>
          <a href="#" class="active"><i class="fas fa-chart-line"></i> Dashboard Principal</a>
        </li>
        <li>
          <a href="#"><i class="fas fa-users-cog"></i> Usuarios y Empresas</a>
        </li>
        <li>
          <a href="#"><i class="fas fa-briefcase"></i> Empleos y Solicitudes</a>
        </li>
        <li>
          <a href="#"><i class="fas fa-newspaper"></i> Blog y Contenido</a>
        </li>
      </ul>
    </div>
    
    <div class="admin-content">
      <h2 class="section-title">Vista General del Sistema</h2>
      
      <div class="stats-grid">
        <BaseCard class="stat-card blue">
          <div class="stat-icon"><i class="fas fa-users"></i></div>
          <div class="stat-info">
            <h3>Usuarios</h3>
            <p class="stat-number">1,245</p>
            <p class="stat-trend">+12% este mes</p>
          </div>
        </BaseCard>
        
        <BaseCard class="stat-card green">
          <div class="stat-icon"><i class="fas fa-building"></i></div>
          <div class="stat-info">
            <h3>Empresas</h3>
            <p class="stat-number">86</p>
            <p class="stat-trend">+5% este mes</p>
          </div>
        </BaseCard>
        
        <BaseCard class="stat-card purple">
          <div class="stat-icon"><i class="fas fa-briefcase"></i></div>
          <div class="stat-info">
            <h3>Empleos</h3>
            <p class="stat-number">342</p>
            <p class="stat-trend">+18% este mes</p>
          </div>
        </BaseCard>
        
        <BaseCard class="stat-card orange">
          <div class="stat-icon"><i class="fas fa-file-alt"></i></div>
          <div class="stat-info">
            <h3>Solicitudes</h3>
            <p class="stat-number">5,678</p>
            <p class="stat-trend">+24% este mes</p>
          </div>
        </BaseCard>
      </div>

      <div class="recent-activity">
        <h3>Actividad Reciente y Accesos Rápidos</h3>
        <p>Próximamente: CRUD completo para administración del sistema.</p>
      </div>

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
}

.admin-sidebar {
  width: 250px;
  flex-shrink: 0;
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  height: fit-content;
}

.admin-sidebar h3 {
  margin-bottom: 1.5rem;
  color: var(--color-primary);
  border-bottom: 2px solid #eee;
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
}

.admin-nav a:hover,
.admin-nav a.active {
  background-color: var(--color-secondary);
  color: white;
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
  color: #666;
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
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
</style>

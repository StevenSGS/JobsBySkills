<template>
  <div class="admin-home">
    <h2 class="section-title">Vista General del Sistema</h2>
      
      <div class="stats-grid">
        <BaseCard class="stat-card blue">
          <div class="stat-icon"><i class="fas fa-users"></i></div>
          <div class="stat-info">
            <h3>Usuarios</h3>
            <p class="stat-number">{{ stats.users }}</p>
            <p class="stat-trend">Registrados</p>
          </div>
        </BaseCard>
        
        <BaseCard class="stat-card green">
          <div class="stat-icon"><i class="fas fa-building"></i></div>
          <div class="stat-info">
            <h3>Empresas</h3>
            <p class="stat-number">{{ stats.companies }}</p>
            <p class="stat-trend">Registradas</p>
          </div>
        </BaseCard>
        
        <BaseCard class="stat-card purple">
          <div class="stat-icon"><i class="fas fa-briefcase"></i></div>
          <div class="stat-info">
            <h3>Empleos</h3>
            <p class="stat-number">{{ stats.jobs }}</p>
            <p class="stat-trend">Total publicados</p>
          </div>
        </BaseCard>
        
        <BaseCard class="stat-card orange">
          <div class="stat-icon"><i class="fas fa-file-alt"></i></div>
          <div class="stat-info">
            <h3>Posts (Blog)</h3>
            <p class="stat-number">{{ stats.posts }}</p>
            <p class="stat-trend">Publicaciones</p>
          </div>
        </BaseCard>
      </div>

      <div class="recent-activity">
        <h3>Accesos Rápidos</h3>
        <div class="quick-links">
          <router-link to="/admin/users" class="quick-link">
            <i class="fas fa-users"></i> Gestionar Usuarios y Empresas
          </router-link>
          <router-link to="/admin/jobs" class="quick-link">
            <i class="fas fa-briefcase"></i> Gestionar Empleos
          </router-link>
          <router-link to="/admin/content" class="quick-link">
            <i class="fas fa-file-alt"></i> Gestionar Contenido (Blog)
          </router-link>
        </div>
      </div>
  </div>
</template>

<script>
import BaseCard from '../../components/BaseCard.vue';
export default {
  name: 'AdminHome',
  components: { BaseCard },
  data() {
    return {
      stats: {
        users: 0,
        companies: 0,
        jobs: 0,
        posts: 0
      },
      isLoading: true
    };
  },
  async created() {
    try {
      const res = await fetch('/api/admin/stats');
      if (res.ok) {
        this.stats = await res.json();
      }
    } catch (error) {
      console.error('Error fetching admin stats:', error);
    } finally {
      this.isLoading = false;
    }
  }
};
</script>

<style scoped>
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
  background-color: var(--color-card-bg);
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px var(--color-card-shadow);
  color: var(--color-text);
  border: 1px solid var(--color-border);
}
</style>

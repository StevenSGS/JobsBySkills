<template>
  <div class="about-us-view container">
    <BaseCard>
      <h2>Sobre JobsBySkills</h2>
      <p>
        JobsBySkills es un proyecto diseñado para conectar a profesionales con las oportunidades laborales que mejor se ajustan a sus habilidades. En un mercado laboral en constante evolución, entendemos la importancia de una conexión precisa entre el talento y las empresas.
      </p>
      <p>
        Nuestra plataforma, desarrollada con Vue.js en el frontend y Node.js en el backend, busca simplificar el proceso de búsqueda de empleo, permitiendo a los usuarios destacar sus competencias y a las empresas encontrar el perfil ideal de manera eficiente.
      </p>
      <p>
        Este proyecto es una demostración de las capacidades de desarrollo web moderno, enfocándose en una experiencia de usuario intuitiva y un diseño limpio y profesional.
      </p>
      <p>
        ¡Esperamos que disfrutes explorando JobsBySkills!
      </p>
    </BaseCard>
  </div>
</template>

<script>
import BaseCard from '../components/BaseCard.vue';

export default {
  name: 'AboutUsView',
  components: {
    BaseCard,
  },
};
</script>

<style scoped>
.about-us-view {
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}

.about-us-view h2 {
  font-size: 2rem;
  margin-bottom: 1.5rem;
  text-align: center;
  color: var(--color-text);
}

.about-us-view p {
  margin-bottom: 1rem;
  line-height: 1.8;
  color: var(--color-text);
}
</style>

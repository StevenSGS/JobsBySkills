# JobsBySkills

## 📖 Sobre el Proyecto

JobsBySkills nace de la idea de simplificar y humanizar la búsqueda de empleo. En lugar de centrarse únicamente en títulos o experiencias previas, esta plataforma tiene como objetivo conectar a profesionales con empresas a través de lo que realmente importa: **las habilidades que poseen**.

El objetivo es crear un ecosistema donde los candidatos puedan mostrar su verdadero potencial y las empresas puedan encontrar al talento perfecto de una manera más eficiente y precisa.

Este repositorio contiene el proyecto **full-stack**, incluyendo la infraestructura, el backend y la base del frontend.

---

## ✨ Caracteristicas Actuales

El estado actual del proyecto es una base sólida y bien configurada, lista para que se construyan las funcionalidades principales.

- 🏗️ **Infraestructura como Código:** Todo el entorno, desde la base de datos hasta la aplicación, está definido y orquestado con **Docker**, permitiendo un despliegue consistente y sin complicaciones en cualquier máquina.

- ⚙️ **Backend Preparado:** Un servidor **Node.js + Express** está activo y conectado a la base de datos, sirviendo como el núcleo de la futura API.

- 🎨 **Frontend Interactivo:** Una interfaz de usuario con **Vue.js** y **Vite** está integrada, permitiendo un desarrollo visual y dinámico con recarga en caliente (hot-reloading).

- 🗃️ **Base de Datos Dinámica:** Al iniciar el entorno por primera vez, un menú interactivo permite elegir con qué conjunto de datos (por defecto o personalizados) inicializar la base de datos **SQL Server**.

- ♻️ **Ciclo de Vida Controlado:** Los scripts de inicio se encargan de todo el ciclo de vida de la aplicación: limpian sesiones anteriores, construyen los contenedores y los ejecutan. ¡Cero configuración manual!

- 🩺 **Endpoint de Diagnóstico:** Una ruta especial (`/api/db-test`) permite visualizar en tiempo real todo el esquema y contenido de la base de datos, facilitando enormemente el desarrollo y la depuración.

---

## 🛠️ Tecnologias Utilizadas

- **Frontend:** Vue.js, Vite
- **Backend:** Node.js, Express.js
- **Base de Datos:** Microsoft SQL Server
- **Contenedores:** Docker, Docker Compose
- **Lenguajes:** JavaScript, SQL

---

## 🚀 Hoja de Ruta

Este es el comienzo. La infraestructura está lista, pero el camino para convertir JobsBySkills en una aplicación completa apenas empieza.

### ✅ Lo que ya existe:

- [X] Servidor web básico.
- [X] Conexión robusta a la base de datos con reintentos.
- [X] Sistema de scripts para una inicialización de la base de datos seleccionable.
- [X] Entorno de desarrollo dockerizado.
- [X] Scripts de gestión para iniciar, reiniciar y detener el entorno.
- [X] Base del frontend con Vue.js y Vite integrada y lista para el desarrollo.

### 📝 Lo que falta (Próximos Pasos):

- [ ] **Desarrollo de la API REST:** Crear los endpoints para gestionar `Usuarios`, `Trabajos`, `Habilidades`, etc. (ej. `GET /jobs`, `POST /users/skills`).
- [ ] **Autenticación y Autorización:** Implementar un sistema de registro e inicio de sesión (ej. con JWT).
- [ ] **Desarrollo del Frontend:** Construir las diferentes vistas y componentes de la interfaz de usuario sobre la base ya establecida.
- [ ] **Lógica de "Matching":** Diseñar e implementar el algoritmo que conecte las habilidades de los usuarios con los requisitos de los trabajos.
- [ ] **Pruebas (Testing):** Añadir pruebas unitarias y de integración para asegurar la calidad del código.

---

## ⚡ Guia de Inicio Rapido

Para poner en marcha el prototipo del backend con integración de Vue.js como frontend:

1.  Asegúrate de tener **Docker Desktop** instalado y en ejecución.
2.  Ejecuta el script de inicio para tu sistema operativo:
    -   **Windows**: `scripts\start.bat`
    -   **Linux/macOS**: `bash ./scripts/start.sh`
3.  Sigue las instrucciones en pantalla para seleccionar el script de la base de datos.
4.  La aplicación estará activa en `http://localhost:3000`.
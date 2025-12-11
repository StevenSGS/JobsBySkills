# JobsBySkills

## 📖 Sobre el Proyecto

JobsBySkills nace de la idea de simplificar y humanizar la búsqueda de empleo. En lugar de centrarse únicamente en títulos o experiencias previas, esta plataforma tiene como objetivo conectar a profesionales con empresas a través de lo que realmente importa: **las habilidades que poseen**.

El objetivo es crear un ecosistema donde los candidatos puedan mostrar su verdadero potencial y las empresas puedan encontrar al talento perfecto de una manera más eficiente y precisa.

Este repositorio contiene el proyecto **full-stack**, incluyendo la infraestructura, el backend y la base del frontend.

---

## ✨ Caracteristicas Actuales

El estado actual del proyecto es una base sólida y bien configurada, lista para que se construyan las funcionalidades principales.

- 🏗️ **Infraestructura como Código:** Todo el entorno, desde la base de datos hasta la aplicación, está definido y orquestado con **Docker**, permitiendo un despliegue consistente y sin complicaciones en cualquier máquina.

- ⚙️ **Backend Preparado:** Un servidor **Node.js + Express** está activo, conectado a la base de datos y sirviendo API RESTful segura.

- 🔐 **Autenticación Completa:** Sistema de registro e inicio de sesión funcional para **Usuarios** y **Empresas**, con validaciones, manejo de sesiones y redirecciones basadas en roles (Admin/Cliente/Empresa).

- 🎨 **Frontend Interactivo:** La interfaz de usuario, desarrollada con **Vue.js** y **Vite**, es robusta y reactiva. Incluye dashboard administrativo, gestión de perfiles y navegación contextual.

- 🗃️ **Base de Datos Dinámica:** Al iniciar el entorno, un menú interactivo permite elegir con qué conjunto de datos inicializar la base de datos **SQL Server**.

- ♻️ **Ciclo de Vida Controlado:** Los scripts de inicio se encargan de todo el ciclo de vida de la aplicación. ¡Cero configuración manual!

---

## 🛠️ Tecnologias Utilizadas

- **Frontend:** Vue.js, Vite, Vue Router, Vuex (Store Pattern)
- **Backend:** Node.js, Express.js
- **Base de Datos:** Microsoft SQL Server
- **Contenedores:** Docker, Docker Compose
- **Lenguajes:** JavaScript, SQL

---

## 🚀 Hoja de Ruta

Este es el comienzo. La infraestructura está lista y la Fase 1 (Fundamentos) está completa.

### ✅ Lo que ya existe (Fase 1 Completada):

- [X] Servidor web y API base.
- [X] Conexión robusta a base de datos SQL Server.
- [X] **Sistema de Autenticación:** Registro y Login para Clientes y Empresas.
- [X] **Roles y Permisos:** Vistas y navegación diferenciada para Admin, Empresa y Cliente.
- [X] **Panel de Administración:** Estructura inicial del Dashboard administrativo.
- [X] **Gestión de Sesiones:** Persistencia y timeout por inactividad.
- [X] Frontend funcional con Vue.js, Vite y Vue-Router.

### 📝 Lo que falta (Próximos Pasos - Fase 2):

- [ ] **Gestión de Usuarios (CRUD Admin):** Permitir al admin editar/borrar usuarios.
- [ ] **Publicación de Empleos:** Funcionalidad para empresas.
- [ ] **Postulación a Empleos:** Funcionalidad para candidatos.
- [ ] **Lógica de "Matching":** Algoritmo que conecte habilidades con trabajos.
- [ ] **Pruebas (Testing):** Añadir pruebas unitarias y de integración.

---

## ⚡ Guia de Inicio Rapido

Para poner en marcha el prototipo del backend con integración de Vue.js como frontend:

1.  Asegúrate de tener **Docker Desktop** instalado y en ejecución.
2.  Ejecuta el script de inicio para tu sistema operativo:
    -   **Windows**: `scripts\start.bat`
    -   **Linux/macOS**: `bash ./scripts/start.sh`
3.  Sigue las instrucciones en pantalla para seleccionar el script de la base de datos.
4.  La aplicación estará activa en `http://localhost:3000`.
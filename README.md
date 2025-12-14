# JobsBySkills

## 📖 Sobre el Proyecto

JobsBySkills nace de la idea de simplificar y humanizar la búsqueda de empleo. En lugar de centrarse únicamente en títulos o experiencias previas, esta plataforma tiene como objetivo conectar a profesionales con empresas a través de lo que realmente importa: **las habilidades que poseen**.

El objetivo es crear un ecosistema donde los candidatos puedan mostrar su verdadero potencial y las empresas puedan encontrar al talento perfecto de una manera más eficiente y precisa. Con un conjunto de características robusto y una infraestructura sólida, el proyecto ha alcanzado una etapa de madurez funcional.

Este repositorio contiene el proyecto **full-stack**, incluyendo la infraestructura, el backend y la base del frontend.

---

## ✨ Caracteristicas Actuales

El proyecto cuenta con una base sólida y un conjunto completo de funcionalidades que lo hacen una plataforma funcional y lista para su uso.

- 🏗️ **Infraestructura como Código:** Todo el entorno, desde la base de datos hasta la aplicación, está definido y orquestado con **Docker**, permitiendo un despliegue consistente y sin complicaciones en cualquier máquina.

- ⚙️ **Backend Robusto:** Un servidor **Node.js + Express** está activo, conectado a la base de datos y sirviendo una API RESTful completa con operaciones CRUD para todas las entidades principales de la aplicación.

- 🔐 **Autenticación Completa:** Sistema de registro e inicio de sesión funcional para **Usuarios** y **Empresas**, con validaciones, manejo de sesiones y redirecciones basadas en roles (Admin/Cliente/Empresa).

- 🎨 **Frontend Interactivo y Administrativo:** La interfaz de usuario, desarrollada con **Vue.js** y **Vite**, es robusta y reactiva. Incluye un dashboard administrativo completo para la gestión de usuarios, empleos y contenido, además de perfiles de usuario y empresa.

- 📖 **Gestión de Contenido (Blog):** La plataforma incluye una sección de blog completamente funcional, permitiendo a los administradores crear, editar y eliminar artículos.

- 🗃️ **Base de Datos Dinámica:** Al iniciar el entorno, un menú interactivo permite elegir con qué conjunto de datos inicializar la base de datos **SQL Server**.

- ♻️ **Ciclo de Vida Controlado:** Los scripts de inicio se encargan de todo el ciclo de vida de la aplicación. ¡Cero configuración manual!

---

## 🛠️ Tecnologias Utilizadas

- **Frontend:** Vue.js, Vite, Vue Router, Vuex Store
- **Backend:** Node.js, Express.js
- **Base de Datos:** Microsoft SQL Server 2019
- **Contenedores:** Docker, Docker Compose
- **Lenguajes:** Batch, Bash, CSS, HTML, JavaScript, JSON, T-SQL

---

## 🚀 Fases del Desarrollo

El desarrollo del proyecto se completó a través de varias fases, culminando en una aplicación full-stack funcional.

### ✅ Fase 1: Fundamentos y Autenticación

- [X] Servidor web y API base.
- [X] Conexión robusta a base de datos SQL Server.
- [X] **Sistema de Autenticación:** Registro y Login para Clientes y Empresas.
- [X] **Roles y Permisos:** Vistas y navegación diferenciada para Admin, Empresa y Cliente.
- [X] **Panel de Administración:** Estructura inicial del Dashboard administrativo.
- [X] **Gestión de Sesiones:** Persistencia y timeout por inactividad.
- [X] Frontend funcional con Vue.js, Vite y Vue-Router.

### ✅ Fase 2: Gestión de Empleos y Usuarios

- [X] **Gestión de Usuarios (CRUD Admin):** El administrador puede editar y eliminar perfiles de usuarios y empresas.
- [X] **Publicación de Empleos:** Las empresas pueden crear y gestionar sus propias ofertas de trabajo.
- [X] **Búsqueda y Filtro de Empleos:** Los candidatos pueden buscar empleos por título, empresa o habilidad.
- [X] **Postulación a Empleos:** Los candidatos pueden aplicar a las ofertas de trabajo y ver el estado de sus postulaciones.

### ✅ Fase 3: Ecosistema de Contenido y Perfiles

- [X] **Gestión de Contenido (Blog):** CRUD completo para la creación y administración de artículos desde el panel de administrador.
- [X] **Perfiles Públicos:** Vistas de perfil para usuarios y empresas.
- [X] **Edición de Perfiles:** Los usuarios y empresas pueden editar la información de sus propios perfiles.
- [X] **Gestión de Habilidades:** El sistema permite la asociación dinámica de habilidades con ofertas de trabajo.
- [X] **Vista de Detalles del Empleo:** Una página dedicada para ver todos los detalles de una oferta de trabajo específica, incluyendo descripción, requisitos y habilidades.

---

## ⚡ Guia de Inicio Rapido

Para poner en marcha la aplicación:

1.  Asegúrate de tener **Docker Desktop** instalado y en ejecución.
2.  Ejecuta el script de inicio para tu sistema operativo:
    -   **Windows**: `scripts\start.bat`
    -   **Linux/macOS**: `bash ./scripts/start.sh`
3.  Sigue las instrucciones en pantalla para seleccionar el script de la base de datos (en el primer inicio).
4.  La aplicación estará activa en `http://localhost:3000`.

# JobsBySkills

## 📖 Sobre el Proyecto

JobsBySkills nace de la idea de simplificar y humanizar la búsqueda de empleo. En lugar de centrarse únicamente en títulos o experiencias previas, esta plataforma tiene como objetivo conectar a profesionales con empresas a través de lo que realmente importa: **las habilidades que poseen**.

El objetivo es crear un ecosistema donde los candidatos puedan mostrar su verdadero potencial y las empresas puedan encontrar al talento perfecto de una manera más eficiente y precisa.

Este repositorio contiene el **backend y la infraestructura base** del proyecto, diseñado para ser robusto, escalable y fácil de desplegar.

---

## ✨ Caracteristicas Actuales

El estado actual del proyecto es una base sólida y bien configurada, lista para que se construyan las funcionalidades principales.

- 🏗️ **Infraestructura como Codigo:** Todo el entorno, desde la base de datos hasta la aplicacion, está definido y orquestado con **Docker**, permitiendo un despliegue consistente y sin complicaciones en cualquier maquina.

- ⚙️ **Backend Preparado:** Un servidor **Node.js + Express** está activo y conectado a la base de datos, sirviendo como el nucleo de la futura API.

- 🗃️ **Base de Datos Dinamica:** Al iniciar el entorno por primera vez, un menu interactivo permite elegir con que conjunto de datos (por defecto o personalizados) inicializar la base de datos **SQL Server**.

- ♻️ **Ciclo de Vida Controlado:** Los scripts de inicio se encargan de todo el ciclo de vida de la aplicacion: limpian sesiones anteriores, construyen los contenedores y los ejecutan. ¡Cero configuracion manual!

- 🩺 **Endpoint de Diagnostico:** Una ruta especial (`/db-test`) permite visualizar en tiempo real todo el esquema y contenido de la base de datos, facilitando enormemente el desarrollo y la depuracion.

---

## 🛠️ Tecnologias Utilizadas

- **Backend:** Node.js, Express.js
- **Base de Datos:** Microsoft SQL Server
- **Contenedores:** Docker, Docker Compose
- **Lenguajes:** JavaScript, SQL

---

## 🚀 Hoja de Ruta

Este es el comienzo. La infraestructura está lista, pero el camino para convertir JobsBySkills en una aplicacion completa apenas empieza.

### ✅ Lo que ya existe:

- [X] Servidor web basico.
- [X] Conexion robusta a la base de datos con reintentos.
- [X] Sistema de scripts para una inicializacion de la base de datos seleccionable.
- [X] Entorno de desarrollo dockerizado.
- [X] Scripts de gestion para iniciar, reiniciar y detener el entorno.

### 📝 Lo que falta (Proximos Pasos):

- [ ] **Desarrollo de la API REST:** Crear los endpoints para gestionar `Usuarios`, `Trabajos`, `Habilidades`, etc. (ej. `GET /jobs`, `POST /users/skills`).
- [ ] **Autenticacion y Autorizacion:** Implementar un sistema de registro e inicio de sesion (ej. con JWT).
- [ ] **Desarrollo del Frontend:** Construir la interfaz de usuario (posiblemente con un framework como React, Vue o Svelte) que consuma la API.
- [ ] **Logica de "Matching":** Diseñar e implementar el algoritmo que conecte las habilidades de los usuarios con los requisitos de los trabajos.
- [ ] **Pruebas (Testing):** Añadir pruebas unitarias y de integracion para asegurar la calidad del codigo.

---

## ⚡ Guia de Inicio Rapido

Para poner en marcha el prototipo del backend:

1.  Asegurate de tener **Docker Desktop** instalado y en ejecucion.
2.  Ejecuta el script de inicio para tu sistema operativo:
    -   **Windows**: `.\scripts\start.bat`
    -   **Linux/macOS**: `bash ./scripts/start.sh`
3.  Sigue las instrucciones en pantalla para seleccionar el script de la base de datos.
4.  La aplicacion estara activa en `http://localhost:3000`.

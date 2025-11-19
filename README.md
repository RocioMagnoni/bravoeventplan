# Bravo Event Plan

Bienvenido al repositorio de **Bravo Event Plan**, una aplicación móvil para la gestión de eventos desarrollada con Flutter.

<p align="center">
  <img src="assets/images/logo.jpg" alt="Bravo Event Plan" width="250"/>
</p>

---

## ✨ Características Principales

La aplicación incluye las siguientes funcionalidades:

- **Gestión de Eventos**: Creación, edición y eliminación de eventos con seguimiento de estado (Próximo, En Curso, Finalizado).
- **Lista de Invitados**: Control de asistencia en tiempo real durante los eventos.
- **Galería de Contactos**: Una galería de tarjetas interactivas para gestionar contactos, con un sistema de ranking.
- **Módulo de Finanzas (Bóveda)**: Un contador de ganancias que agrega los beneficios de eventos finalizados y permite registrar ingresos manuales.
- **Reproductor de Música**: Un reproductor de audio integrado para listas de reproducción.
- **Función Espejo**: Utiliza la cámara frontal del dispositivo.
- **Checklist**: Módulo para gestionar una lista de tareas (To-Do).
- **Calendario de Eventos**: Una vista de calendario que resalta los días con eventos programados.
- **Notificaciones Push**: Integración con Firebase Cloud Messaging (FCM) para notificaciones.

---

## 🏗️ Arquitectura del Proyecto

El proyecto está construido siguiendo el patrón de diseño **BLoC (Business Logic Component)** para asegurar una clara separación entre la lógica de negocio y la interfaz de usuario.

La estructura principal del directorio `lib/` es la siguiente:

- **`/blocs`**: Contiene los componentes de lógica de negocio (BLoCs) para cada feature de la aplicación (`EventBloc`, `GalleryBloc`, `ContadorBloc`, etc.). Cada BLoC maneja su propio estado, reaccionando a eventos enviados desde la UI y emitiendo nuevos estados.
  - `_event.dart`: Define los eventos (acciones) que la UI puede enviar al BLoC.
  - `_state.dart`: Define los diferentes estados que la UI puede representar.
  - `_bloc.dart`: Contiene la lógica de negocio que procesa los eventos y produce nuevos estados.

- **`/data`**: Encargada de la gestión y el acceso a los datos.
  - **`/models`**: Contiene las clases de modelo de datos (`Event`, `Guest`, `Song`, `Task`). Estas clases definen la estructura de los datos e incluyen la lógica de serialización/deserialización (`fromSnapshot`, `toJson`).
  - **`/repositories`**: Actúan como intermediarios entre los BLoCs y las fuentes de datos. Abstraen el origen de los datos (en este caso, Firebase), permitiendo que la lógica de negocio no dependa directamente de la implementación de la base de datos.

- **`/view`**: Contiene todos los componentes de la interfaz de usuario (UI).
  - **`/pages`**: Las pantallas principales de la aplicación (`HomePage`, `EventsPageUnified`, `EventDetailsPage`, etc.). Son Widgets que se reconstruyen en función de los estados emitidos por los BLoCs.
  - **`/widgets`**: Componentes de UI reutilizables (`MainDrawer`, `JohnnyTipsCarousel`, `TicketClipper`) que se utilizan en múltiples pantallas para promover un código limpio y DRY (Don't Repeat Yourself).

- **`/services`**: Clases dedicadas a encapsular funcionalidades técnicas específicas y complejas, como la gestión de notificaciones push (`PushNotificationService`) o la inicialización de la cámara (`CameraService`).

---

## 🚀 Puesta en Marcha

Para ejecutar el proyecto, se necesita tener Flutter instalado y configurado.

1.  **Configurar Firebase**: Es necesario tener un proyecto de Firebase creado. Coloque el archivo de configuración `google-services.json` en el directorio `android/app/`.

2.  **Instalar Dependencias**: Abra una terminal en la raíz del proyecto y ejecute el siguiente comando:
    ```sh
    flutter pub get
    ```

3.  **Generar Iconos de la App**: Si se modifica el logo, ejecute el siguiente comando para generar los iconos de la aplicación para las distintas plataformas:
    ```sh
    flutter pub run flutter_launcher_icons:main
    ```

4.  **Ejecutar la Aplicación**:
    ```sh
    flutter run
    ```

---

## 📦 Dependencias Clave

Este proyecto utiliza las siguientes dependencias principales:

- `flutter_bloc`: Para la gestión de estado con el patrón BLoC.
- `cloud_firestore`: Para la comunicación con la base de datos Firestore.
- `firebase_core` & `firebase_messaging`: Para la integración con Firebase y las notificaciones push.
- `lottie`: Para la reproducción de animaciones de Adobe After Effects.
- `camera`: Para el acceso y control de la cámara del dispositivo.
- `just_audio`: Para el reproductor de audio.
- `flip_card`: Para el efecto de volteo en las tarjetas de la galería.
- `table_calendar`: Para la implementación del calendario.
- `intl`: Para el formateo de fechas y números.
- `flutter_launcher_icons`: Para la generación de los iconos de la aplicación.

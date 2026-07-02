# Tlahtolli 🗣️📙

**Tlahtolli** (del vocablo náhuatl: *palabra*, *lengua* o *discurso*) es un proyecto de aplicación móvil nativa desarrollado en **Flutter** para el sistema operativo Android. Su objetivo principal es servir como un puente lingüístico y cultural mediante la traducción bidireccional entre el idioma **Náhuatl** y el **Español**, incluyendo la transcripción fonética de los términos consultados.

Este proyecto ha sido desarrollado como propuesta para la evaluación del **Proyecto Ordinario (40%)** en la materia de *Programación de Dispositivos Móviles*.

## Características Principales

- **Traducción Bidireccional:** Soporte completo para flujos Español ↔ Náhuatl.
- **Transcripción Fonética:** Guía de pronunciación basada en caracteres fonéticos normalizados.
- **Funcionamiento Offline (Persistencia Local):** Base de datos relacional interna en SQLite para almacenar de forma persistente el historial de búsquedas y una sección de términos favoritos (esencial para zonas con baja conectividad).
- **Consumo Asíncrono de Datos:** Conexión remota a una API REST para la obtención y actualización de diccionarios en tiempo real en formato JSON.

## Arquitectura y Tecnologías

El proyecto implementa de manera estricta el patrón arquitectónico **MVVM (Model-View-ViewModel)** para garantizar una separación limpia entre la interfaz de usuario y la lógica de negocio.

- **Framework:** Flutter (Dart)
- **Base de Datos Local:** SQLite (`sqflite` package)
- **Consumo HTTP:** `http` / API REST JSON
- **Diseño UI/UX:** Paleta basada en la identidad institucional universitaria (`#670300`) combinada con acentos verde turquesa/jade prehispánico (`#26A69A`).

## Estructura de Carpetas (lib/)

```
lib/
│
├── main.dart                     # Punto de entrada de la aplicación
│
├── core/                         # Configuraciones globales y utilidades
│   ├── theme/
│   │   └── app_theme.dart        # Paleta de colores (#670300, #26A69A, #FFFDF9)
│   └── utils/
│       └── constants.dart        # URLs de la API y constantes de texto
│
├── data/                         # CAPA DE DATOS (Models, Providers, Repositories)
│   ├── database/
│   │   └── db_helper.dart        # Inicialización de SQflite y métodos CRUD
│   ├── models/
│   │   └── palabra_model.dart    # Mapeo de datos JSON y objetos de Base de Datos
│   ├── services/
│   │   └── api_service.dart      # Cliente HTTP para el consumo de la API REST
│   └── repositories/
│       └── traductor_repository.dart # Árbitro que decide si usar la API o la BD local
│
├── viewmodels/                   # CAPA DE LÓGICA DE NEGOCIO
│   └── traductor_viewmodel.dart  # Manejo del estado de la UI y lógica de traducción
│
└── views/                        # CAPA DE PRESENTACIÓN (Interfaces de usuario)
    ├── inicio/
    │   └── traductor_screen.dart # Pantalla principal con la caja de texto
    ├── detalle/
    │   └── resultado_screen.dart   # Muestra la palabra, fonética y botón favorito
    ├── favoritos/
    │   └── favoritos_screen.dart # Lista de palabras guardadas (Uso sin internet)
    ├── historial/
    │   └── historial_screen.dart # Historial cronológico de búsquedas
    └── widgets/
        └── custom_bottom_nav.dart # Barra de navegación compartida
```

---
*Periodo Escolar 2025-2026B.*
# Antigravity Academy - MVP ENTREGADO 🚀

La estructura base de la aplicación Flutter ha sido generada siguiendo la arquitectura de 4 capas.

## Componentes Implementados:
- **Core**: Sistema de diseño (colores, tipografía), Router (GoRouter), Tema.
- **Data**: Base de datos SQLite gestionada con migraciones, Repositorios para categorías y preguntas.
- **State Management**: Providers de Riverpod para gestionar el flujo del Quiz y datos.
- **Presentation**: 
  - Splash Screen con animación shimmer.
  - Onboarding dinámico de 3 pasos.
  - Home Screen con **Hero Animation** dirigida por scroll.
  - Vistas de categorías y Quiz interactivo.

## Próximos Pasos:
1. Copiar el contenido de `.tmp/outputs/antigravity_quiz/` a tu carpeta de proyecto final.
2. Asegurarte de que los assets en `assets/` estén correctamente vinculados en `pubspec.yaml`.
3. Ejecutar `flutter run`.

ENTORNO: Flutter 3.x | Riverpod | SQLite | GoRouter

# NEXT STEPS — IronTech NutriHierro

## 1) Auditoría rápida del estado actual (`main`)

### Qué existe hoy
- **Stack/base**: Flutter + Riverpod + GoRouter.
- **Estructura actual**:
  - `lib/core`: router, theme, widgets reutilizables.
  - `lib/features/nutrition`: catálogo de recetas por etapa (mock local).
  - `lib/features/profile`: registro de niño/a y ajustes (mock local).
  - `lib/features/tracking`: registro diario de ingestas (mock local en memoria).
- **Pantallas y navegación**:
  - Ruta inicial: `/profile-register`.
  - Shell con tabs: `/home` (nutrición), `/profile-settings` (ajustes), `/tracking` (registro).
- **Tema/UI**:
  - Tema centralizado con `ThemeData + ColorScheme` en `lib/theme/`.
  - Pantallas principales conectadas al tema (sin colores sueltos en UI principal).
- **Datos hardcodeados/mock**:
  - Recetas mock en `nutrition_repository_impl.dart`.
  - Perfiles y tracking con repositorios mock en memoria.
  - Dependencias Firebase están en `pubspec.yaml`, pero no hay integración activa en runtime.
- **Assets**:
  - Se usan rutas de imagen de ejemplo en modelos mock, pero no hay assets declarados en `pubspec.yaml`.

### Qué falta para llegar a los módulos objetivo
1. **Información confiable sobre anemia/anemia infantil**  
   - Falta pantalla UI y navegación para consumir/mostrar contenido educativo.
2. **Catálogo con recetas detalladas y fotos**  
   - Ya existe base de catálogo mock; falta detalle de receta completa, galería/imagen real y contenido nutricional más robusto.
3. **Cámara + combinaciones propias + guardado en DB personal**  
   - Hay dependencia `image_picker` y contratos base/mock para combinaciones, pero falta flujo UI de captura/subida y persistencia real.
4. **Síntomas y consecuencias**  
   - Falta módulo/pantalla dedicada y curaduría de contenido.

## 2) ¿Firebase ahora o después?

### Recomendación
**Prepararlo ahora, conectarlo después de cerrar flujo UI/base de dominio local.**

### Por qué
- Ya existe avance fuerte con repositorios mock y contratos: permite iterar rápido en UX sin bloquearse por backend.
- Conectar Firebase inmediatamente sin cerrar entidades/flujo puede provocar refactors repetidos en colecciones y reglas.
- Lo óptimo en esta etapa: cerrar primero contratos de dominio + pantallas clave; luego sustituir implementaciones local/mock por Firestore en los mismos contratos.

## 3) Siguientes pasos sugeridos (orden)

1. Crear pantallas de **Info** y **Síntomas/Consecuencias** usando datasource local.
2. Completar detalle de **Recetas** (pasos, porciones, foto, tips de absorción de hierro).
3. Implementar flujo **Cámara → preview → guardar combinación** en repositorio local.
4. Activar Firebase en una segunda iteración con contratos actuales y migración incremental.
5. Agregar tests de repositorios y casos de uso por feature antes de pasar a producción.

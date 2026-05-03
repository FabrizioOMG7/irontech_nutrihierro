# 🚀 Estructura de Imágenes - RESUMEN RÁPIDO

**Última actualización**: 1 de mayo de 2026

## 📂 Dónde Poner las Imágenes

### Para Recetas (Alimentos Recomendados)
Depende de la edad del bebé:

| Edad | Carpeta |
|------|---------|
| **0-5 meses** | `assets/images/recipes/age_lactancia/` |
| **6-8 meses** | `assets/images/recipes/age_papillas/` |
| **9-11 meses** | `assets/images/recipes/age_picados/` |
| **12-23 meses** | `assets/images/recipes/age_olla_familiar/` |
| **24+ meses** | `assets/images/recipes/age_escolar/` |

**Ejemplo**: Para una imagen de papilla (6-8 meses):
```
assets/images/recipes/age_papillas/papilla_avena.png
```

### Para Artículos (Información)
Organizado por tipo de contenido:

| Tipo | Carpeta |
|------|---------|
| Síntomas | `assets/images/info/symptoms/` |
| Prevención | `assets/images/info/prevention/` |
| Nutrición | `assets/images/info/nutrition/` |
| Beneficios | `assets/images/info/benefits/` |

**Ejemplo**: Para una imagen sobre síntomas:
```
assets/images/info/symptoms/palidez_labios.png
```

---

## 💻 Cómo Usar en el Código

### 1️⃣ Paso 1: Copiar la Imagen
```bash
cp ~/Descargas/mi_imagen.png assets/images/recipes/age_papillas/mi_imagen.png
```

### 2️⃣ Paso 2: Usar en el Modelo
```dart
Recipe(
  id: 'recipe_123',
  title: 'Mi Receta',
  imageUrl: 'assets/images/recipes/age_papillas/mi_imagen.png',
  // ... otros campos
)
```

### 3️⃣ Paso 3: Mostrar en Pantalla
```dart
// Opción A: Usar nuestro widget genérico (RECOMENDADO)
AppImageWidget(
  imageUrl: recipe.imageUrl,
  height: 200,
  width: 200,
)

// Opción B: Usar directamente
Image.asset(recipe.imageUrl, height: 200)
```

---

## 🎯 Archivos Clave Creados

| Archivo | Propósito |
|---------|-----------|
| [`pubspec.yaml`](../pubspec.yaml) | ✅ Actualizado con rutas de assets |
| [`lib/core/constants/image_paths.dart`](../lib/core/constants/image_paths.dart) | Constantes centralizadas de rutas |
| [`lib/core/widgets/app_image_widget.dart`](../lib/core/widgets/app_image_widget.dart) | Widget genérico para mostrar imágenes |
| [`lib/features/info/domain/anemia_info_article.dart`](../lib/features/info/domain/anemia_info_article.dart) | ✅ Actualizado con campo imageUrl |
| [`docs/ESTRUCTURA_IMAGENES.md`](./ESTRUCTURA_IMAGENES.md) | Guía completa (detallada) |
| [`docs/GUIA_IMPLEMENTACION_IMAGENES.md`](./GUIA_IMPLEMENTACION_IMAGENES.md) | Ejemplos prácticos (código real) |

---

## 📝 Estructura Final del Proyecto

```
assets/
└── images/
    ├── recipes/
    │   ├── age_lactancia/      ← Coloca imágenes de 0-5 meses aquí
    │   ├── age_papillas/       ← Coloca imágenes de 6-8 meses aquí
    │   ├── age_picados/        ← Coloca imágenes de 9-11 meses aquí
    │   ├── age_olla_familiar/  ← Coloca imágenes de 12-23 meses aquí
    │   └── age_escolar/        ← Coloca imágenes de 24+ meses aquí
    │
    └── info/
        ├── symptoms/           ← Imágenes sobre síntomas
        ├── prevention/         ← Imágenes sobre prevención
        ├── nutrition/          ← Imágenes nutricionales
        └── benefits/           ← Imágenes de beneficios
```

---

## 🔧 Próximos Pasos

1. **Obtener las imágenes**: Descarga o crea imágenes PNG para tus recetas y artículos
2. **Colocar en carpetas**: Copia las imágenes en el directorio correspondiente
3. **Actualizar modelos**: Agrega la ruta `imageUrl` a tus objetos Recipe y AnemiaInfoArticle
4. **Mostrar en UI**: Usa `AppImageWidget` o `Image.asset()` en tus widgets
5. **Probar**: Ejecuta `flutter run` para verificar que todo funciona

---

## 📚 Documentos Disponibles

- **`ESTRUCTURA_IMAGENES.md`**: Guía completa con todos los detalles
- **`GUIA_IMPLEMENTACION_IMAGENES.md`**: Ejemplos prácticos con código real
- **Este documento**: Resumen rápido para empezar

---

## ❓ Preguntas Frecuentes

**P: ¿Puedo usar URLs remotas (Firebase Storage)?**
R: Sí, totalmente. Usa la extensión `CachedNetworkImage` que ya está en el proyecto.

**P: ¿Qué tamaño deben tener las imágenes?**
R: Recetas: 800x600px. Artículos: 1200x600px. Máximo: 200-300KB.

**P: ¿Necesito actualizar algo después de agregar imágenes?**
R: Solo si creas nuevas carpetas. El `pubspec.yaml` está configurado para incluir todas las subcarpetas.

**P: ¿Puedo mezclar assets locales y URLs remotas?**
R: Sí, el widget `AppImageWidget` detecta automáticamente si es local o remota.

---

¿Necesitas ayuda con algo específico? Consulta las guías detalladas o pregúntame directamente.

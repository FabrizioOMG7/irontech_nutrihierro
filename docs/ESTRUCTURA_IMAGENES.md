# 📸 Estructura de Imágenes - NutriHierro

Guía completa sobre dónde colocar, cómo organizar y referenciar imágenes en el proyecto.

---

## 📁 Estructura de Carpetas

```
irontech_nutrihierro/
├── assets/
│   └── images/
│       ├── recipes/                          # Imágenes de alimentos/recetas
│       │   ├── age_lactancia/               # 0-5 meses (lactancia exclusiva)
│       │   ├── age_papillas/                # 6-8 meses
│       │   ├── age_picados/                 # 9-11 meses
│       │   ├── age_olla_familiar/           # 12-23 meses
│       │   └── age_escolar/                 # 24+ meses
│       │
│       └── info/                             # Imágenes informativas sobre anemia
│           ├── symptoms/                    # Síntomas de anemia
│           ├── prevention/                  # Prevención
│           ├── nutrition/                   # Información nutricional
│           └── benefits/                    # Beneficios de alimentos
└── [resto de carpetas del proyecto]
```

---

## 🍽️ RECETAS - Dónde Colocar Imágenes

### Estructura
Each recipe image should be named using the pattern: `{recipe-id}.png` or `{recipe-name-slug}.png`

**Ubicaciones exactas:**

| Edad | Ruta Completa | Ejemplo | Formato |
|------|---------------|---------|---------|
| **0-5 meses** (Lactancia) | `assets/images/recipes/age_lactancia/` | `pure_de_zapallo.png` | PNG/JPG |
| **6-8 meses** (Papillas) | `assets/images/recipes/age_papillas/` | `papilla_hierro.png` | PNG/JPG |
| **9-11 meses** (Picados) | `assets/images/recipes/age_picados/` | `picado_pollo.png` | PNG/JPG |
| **12-23 meses** (Olla Familiar) | `assets/images/recipes/age_olla_familiar/` | `olla_familiar_carne.png` | PNG/JPG |
| **24+ meses** (Escolar) | `assets/images/recipes/age_escolar/` | `ensalada_hierro.png` | PNG/JPG |

### Convención de Nombres
```
- Usar snake_case: pure_de_zapallo.png
- Describir el contenido: no usar numeros aleatorios
- Máximo 50 caracteres: nombre_receta.png
```

### Cómo Referenciar en Recipe

**Opción 1: Asset Local (Recomendado para imágenes estáticas)**
```dart
Recipe(
  id: 'recipe_001',
  title: 'Puré de Zapallo',
  description: 'Rico en beta-carotenos y hierro',
  imageUrl: 'assets/images/recipes/age_papillas/pure_de_zapallo.png',
  ironContent: 2,
  targetAge: AgeCategory.papillas,
  ingredients: ['Zapallo', 'Agua'],
  preparationSteps: ['Cocinar', 'Procesar'],
)
```

**Opción 2: Firebase Storage (Para imágenes dinámicas/actualizables)**
```dart
Recipe(
  id: 'recipe_002',
  title: 'Papilla de Hierro',
  imageUrl: 'https://firebasestorage.googleapis.com/b/your-bucket/recipes/papilla_hierro.png',
  // ... resto de campos
)
```

---

## 📰 INFORMACIÓN (ARTÍCULOS) - Dónde Colocar Imágenes

### Estructura
```
assets/images/info/
├── symptoms/              # Síntomas de anemia infantil
├── prevention/            # Estrategias de prevención
├── nutrition/             # Guías nutricionales
└── benefits/              # Beneficios de alimentos específicos
```

### Ubicaciones Exactas

| Tipo de Contenido | Ruta | Ejemplo |
|-------------------|------|---------|
| Síntomas | `assets/images/info/symptoms/` | `palideez_labios.png` |
| Prevención | `assets/images/info/prevention/` | `rutina_alimenticia.png` |
| Nutrición | `assets/images/info/nutrition/` | `fuentes_hierro.png` |
| Beneficios | `assets/images/info/benefits/` | `leche_fortificada.png` |

### Cómo Referenciar en AnemiaInfoArticle

```dart
AnemiaInfoArticle(
  id: 'article_001',
  title: 'Síntomas de Anemia Infantil',
  content: 'Los síntomas incluyen...',
  audience: 'parents',  // 'parents' | 'health_workers' | 'general'
  imageUrl: 'assets/images/info/symptoms/palideez_labios.png',
  description: 'Guía visual de síntomas comunes',
  tags: ['síntomas', 'diagnóstico'],
)
```

---

## 💡 Cómo Mostrar las Imágenes en la UI

### Para Assets Locales (Rutas que comienzan con `assets/`)

#### Opción 1: Image.asset (Mejor para assets)
```dart
Image.asset(
  'assets/images/recipes/age_papillas/pure_de_zapallo.png',
  height: 200,
  width: 200,
  fit: BoxFit.cover,
)
```

#### Opción 2: CachedNetworkImage (Para Firebase Storage)
```dart
import 'package:cached_network_image/cached_network_image.dart';

CachedNetworkImage(
  imageUrl: recipe.imageUrl,
  height: 200,
  width: 200,
  fit: BoxFit.cover,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

#### Opción 3: Widget Genérico (Recomendado)
```dart
Widget _buildRecipeImage(String imageUrl) {
  if (imageUrl.startsWith('assets/')) {
    return Image.asset(
      imageUrl,
      height: 200,
      fit: BoxFit.cover,
    );
  } else {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
```

---

## 📋 Checklist para Agregar Imágenes

### Para una Nueva Receta:
- [ ] Crear archivo de imagen: `assets/images/recipes/age_{categoria}/{nombre_receta}.png`
- [ ] Dimension recomendada: **800x600px** (relación 4:3)
- [ ] Optimizar tamaño: **máx 200KB** (usar herramientas online)
- [ ] Agregar field `imageUrl` al objeto Recipe: `'assets/images/recipes/age_papillas/pure_de_zapallo.png'`
- [ ] Probar que se muestre correctamente en la UI

### Para un Nuevo Artículo:
- [ ] Decidir subcategoría: symptoms, prevention, nutrition, o benefits
- [ ] Crear archivo: `assets/images/info/{subcategoria}/{nombre}.png`
- [ ] Dimension recomendada: **1200x600px** (relación 2:1)
- [ ] Optimizar tamaño: **máx 300KB**
- [ ] Agregar field `imageUrl` a AnemiaInfoArticle
- [ ] Agregar tags relevantes para búsqueda

---

## 🔄 Flujo Completo: De Imagen a Pantalla

### Paso 1: Agregar la Imagen Física
```bash
# Copiar archivo PNG a la carpeta correspondiente
cp mi_imagen.png assets/images/recipes/age_papillas/mi_receta.png
```

### Paso 2: Actualizar el Modelo
```dart
// En tu fuente de datos o repository
Recipe(
  id: 'recipe_123',
  title: 'Mi Receta',
  imageUrl: 'assets/images/recipes/age_papillas/mi_receta.png',  // ← Aquí va la ruta
  // ... resto de campos
)
```

### Paso 3: Mostrar en UI
```dart
// En tu widget de presentación
Image.asset(
  recipe.imageUrl,  // 'assets/images/recipes/age_papillas/mi_receta.png'
  height: 200,
  fit: BoxFit.cover,
)
```

---

## 🎨 Recomendaciones de Diseño

### Dimensiones Recomendadas
- **Recetas**: 800x600px (4:3) o 600x600px (cuadrada)
- **Artículos**: 1200x600px (2:1) o 600x600px
- **Thumbnails**: 400x300px

### Formato de Archivo
- ✅ PNG (con transparencia de fondo)
- ✅ JPG (fotos de alimentos)
- ❌ Evitar: WebP, SVG, GIF animado

### Tamaño de Archivo
- Máximo para recetas: **200KB**
- Máximo para artículos: **300KB**
- Herramienta recomendada: **TinyPNG** o ImageMagick

### Optimización
```bash
# Comando para comprimir imágenes (Linux/Mac)
mogrify -strip -interlace Plane -quality 85% *.png
```

---

## 🚀 Variable de Entorno para Rutas (Opcional)

Puedes crear constantes globales para evitar repetir rutas:

```dart
// lib/core/constants/image_paths.dart

class ImagePaths {
  // Rutas base
  static const String _recipesBase = 'assets/images/recipes';
  static const String _infoBase = 'assets/images/info';
  
  // Categorías de recetas
  static const String lactancia = '$_recipesBase/age_lactancia';
  static const String papillas = '$_recipesBase/age_papillas';
  static const String picados = '$_recipesBase/age_picados';
  static const String ollaFamiliar = '$_recipesBase/age_olla_familiar';
  static const String escolar = '$_recipesBase/age_escolar';
  
  // Categorías de info
  static const String symptoms = '$_infoBase/symptoms';
  static const String prevention = '$_infoBase/prevention';
  static const String nutrition = '$_infoBase/nutrition';
  static const String benefits = '$_infoBase/benefits';
}
```

**Uso:**
```dart
Recipe(
  imageUrl: '${ImagePaths.papillas}/pure_de_zapallo.png',
)
```

---

## ✨ Resumen Rápido

| ¿Qué quiero hacer? | Ruta | Tipo |
|--------------------|------|------|
| Agregar imagen de receta (bebé 6-8m) | `assets/images/recipes/age_papillas/nombre.png` | Local Asset |
| Agregar imagen de artículo sobre síntomas | `assets/images/info/symptoms/nombre.png` | Local Asset |
| Usar Firebase Storage (dinámico) | `https://firebasestorage.googleapis.com/...` | Remote URL |
| Mostrar en pantalla | `Image.asset()` o `CachedNetworkImage()` | Widget |

---

**Última actualización**: 1 de mayo de 2026

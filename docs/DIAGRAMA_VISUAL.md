# 🗺️ Mapa Visual - Sistema de Imágenes en NutriHierro

Diagrama completo de cómo fluye todo desde colocar la imagen hasta verla en pantalla.

---

## 📊 Flujo General

```
┌─────────────────────────────────────────────────────────────┐
│ 1. TÚ COLOCAS LA IMAGEN                                     │
│    Carpeta: assets/images/recipes/age_papillas/             │
│    Archivo: papilla_avena.png                               │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. REFERENCIA LA IMAGEN EN EL MODELO                       │
│    Recipe(                                                   │
│      imageUrl: 'assets/images/recipes/age_papillas/...',    │
│    )                                                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. WIDGET MUESTRA LA IMAGEN                                │
│    AppImageWidget(                                           │
│      imageUrl: recipe.imageUrl,                             │
│    )                                                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. RESULTADO EN PANTALLA                                    │
│    [Imagen bonita de papilla]                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Mapa de Carpetas

```
proyecto/
│
├── assets/
│   └── images/
│       ├── recipes/              ← Para alimentos recomendados
│       │   ├── age_lactancia/    └─→ 0-5 meses
│       │   ├── age_papillas/     └─→ 6-8 meses
│       │   ├── age_picados/      └─→ 9-11 meses
│       │   ├── age_olla_familiar/└─→ 12-23 meses
│       │   └── age_escolar/      └─→ 24+ meses
│       │
│       └── info/                 ← Para artículos educativos
│           ├── symptoms/         └─→ Síntomas de anemia
│           ├── prevention/       └─→ Cómo prevenir
│           ├── nutrition/        └─→ Guías nutricionales
│           └── benefits/         └─→ Beneficios de alimentos
│
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   └── image_paths.dart  ← Rutas centralizadas
│   │   └── widgets/
│   │       └── app_image_widget.dart  ← Widget genérico
│   │
│   └── features/
│       ├── nutrition/
│       │   ├── domain/
│       │   │   └── recipe.dart   ← Modelo (con imageUrl)
│       │   └── presentation/
│       │       └── recipe_card.dart  ← Mostrar imagen
│       │
│       └── info/
│           ├── domain/
│           │   └── anemia_info_article.dart ← Modelo
│           └── presentation/
│               └── article_detail_screen.dart ← Mostrar
│
├── docs/
│   ├── IMAGENES_QUICK_START.md   ← Comienza aquí
│   ├── ESTRUCTURA_IMAGENES.md    ← Detallada
│   └── GUIA_IMPLEMENTACION_IMAGENES.md  ← Ejemplos prácticos
│
└── pubspec.yaml                  ← Assets configurados ✅
```

---

## 🔗 Conexiones Clave

```
┌──────────────────┐
│ Imagen Física    │  papilla_avena.png
├──────────────────┤
│ Ruta en Assets   │  assets/images/recipes/age_papillas/papilla_avena.png
└──────────┬───────┘
           │
           ├─────────────────────────────────┐
           │                                 │
           ▼                                 ▼
    ┌─────────────────┐          ┌─────────────────────┐
    │ En el Modelo    │          │ En Constantes       │
    │ Recipe          │          │ ImagePaths          │
    ├─────────────────┤          ├─────────────────────┤
    │imageUrl: '...'  │          │recipeAgeCategorias  │
    │                 │          │Papillas: '...'      │
    └────────┬────────┘          └──────────┬──────────┘
             │                              │
             └──────────────┬───────────────┘
                            │
                            ▼
                ┌───────────────────────┐
                │ En el Widget (UI)    │
                ├───────────────────────┤
                │ AppImageWidget(       │
                │   imageUrl: '...'     │
                │ )                     │
                └───────────┬───────────┘
                            │
                ┌───────────▼───────────┐
                │ Detecta si es Local   │
                │ o Remoto             │
                └───────────┬───────────┘
                            │
                ┌───────────┼───────────┐
                │           │           │
                ▼           ▼           ▼
            ┌──────┐   ┌──────────┐   ┌─────────┐
            │Local │   │ Firebase │   │ Error   │
            │Asset │   │ Storage  │   │ Widget  │
            │.┌───┐│   │┌────────┐│   │┌──────┐ │
            ││Img ││   ││ Loading ││   ││🖼️     │ │
            │└───┘│   │└────────┘│   │└──────┘ │
            └──────┘   └──────────┘   └─────────┘
```

---

## 📋 Guía Según El Tipo de Contenido

### Para RECETAS (Alimentos)

```
Colocar Imagen
     │
     ├─→ ¿Qué edad es?
     │   ├─→ 0-5 meses: age_lactancia/
     │   ├─→ 6-8 meses: age_papillas/
     │   ├─→ 9-11 meses: age_picados/
     │   ├─→ 12-23 meses: age_olla_familiar/
     │   └─→ 24+ meses: age_escolar/
     │
     ├─→ Crear Recipe
     │   └─→ imageUrl: 'assets/images/recipes/age_XX/...'
     │
     └─→ Mostrar en RecipeCard
         └─→ AppImageWidget(imageUrl: recipe.imageUrl)
```

### Para ARTÍCULOS (Información)

```
Colocar Imagen
     │
     ├─→ ¿Qué tipo de contenido?
     │   ├─→ Síntomas: symptoms/
     │   ├─→ Prevención: prevention/
     │   ├─→ Nutrición: nutrition/
     │   └─→ Beneficios: benefits/
     │
     ├─→ Crear AnemiaInfoArticle
     │   └─→ imageUrl: 'assets/images/info/XX/...'
     │
     └─→ Mostrar en ArticleDetailScreen
         └─→ AppImageWidget(imageUrl: article.imageUrl)
```

---

## 🎯 Decisiones por Paso

### ¿Dónde colocar la imagen?

```
¿Es una receta/alimento?
  ├─→ SÍ: Carpeta de recetas
  │   └─→ assets/images/recipes/age_[categoria]/
  │
  └─→ NO: ¿Es un artículo educativo?
      └─→ SÍ: Carpeta de información
          └─→ assets/images/info/[tipo]/
```

### ¿Cómo mostrar la imagen?

```
¿Necesitas que se actualice dinámicamente?
  ├─→ NO (es estática): Usa assets locales
  │   └─→ AppImageWidget(imageUrl: 'assets/images/...')
  │
  └─→ SÍ (cambios frecuentes): Usa Firebase Storage
      └─→ AppImageWidget(imageUrl: 'https://firebasestorage...')
```

---

## 🔄 Ciclo de Vida de una Imagen

```
1. CREACIÓN
   └─→ Tu creas/descargas la imagen: papilla.png

2. COLOCACIÓN
   └─→ La copias a la carpeta: assets/images/recipes/age_papillas/

3. PUBLICACIÓN
   └─→ Agregar a pubspec.yaml: ✅ (ya está hecho)

4. REFERENCIA
   └─→ Agregar al modelo: Recipe(imageUrl: 'assets/...')

5. PRESENTACIÓN
   └─→ Mostrar en UI: AppImageWidget(imageUrl: '...')

6. CARGA
   ├─→ Flutter carga el asset
   ├─→ Widget detecta que es local
   └─→ Usa Image.asset()

7. VISUALIZACIÓN
   └─→ Usuario ve la imagen en pantalla ✨
```

---

## 💡 Casos de Uso Comunes

### Caso 1: Agregar imagen de nueva receta

```
Tengo una imagen nueva de papilla

1. Renombro: papilla_frutas.png
2. Coloco: assets/images/recipes/age_papillas/papilla_frutas.png
3. Actualizo Recipe:
   Recipe(
     id: 'rec_pap_frutas',
     imageUrl: 'assets/images/recipes/age_papillas/papilla_frutas.png',
   )
4. Uso en widget:
   AppImageWidget(imageUrl: recipe.imageUrl, height: 200)
```

### Caso 2: Agregar imagen a artículo existente

```
El artículo "Síntomas de Anemia" no tenía imagen

1. Obtengo/creo imagen: sintomas.png
2. Coloco: assets/images/info/symptoms/sintomas.png
3. Actualizo AnemiaInfoArticle:
   AnemiaInfoArticle(
     id: 'art_sintomas_001',
     imageUrl: 'assets/images/info/symptoms/sintomas.png',
   )
4. Mostrar en pantalla:
   AppImageWidget(imageUrl: article.imageUrl, height: 250)
```

### Caso 3: Mezclar assets locales con Firebase

```
Empezar con imágenes locales, migrar a Firebase después

// Fase 1: Assets locales
Recipe(imageUrl: 'assets/images/recipes/.../imagen.png')

// Fase 2: Migrar a Firebase
Recipe(imageUrl: 'https://firebasestorage.googleapis.com/.../imagen.png')

// El widget maneja ambas automáticamente ✅
AppImageWidget(imageUrl: recipe.imageUrl)  // Funciona en ambos casos
```

---

## 🚀 Resumen Visual: De Principio a Fin

```
TÚ COLOCAS IMAGEN
       │
       ▼
┌─────────────────────────────┐
│ assets/images/recipes/      │
│ age_papillas/               │
│ papilla_avena.png ✅        │
└────┬────────────────────────┘
     │
     │ [imageUrl -> referencia a la ruta]
     │
     ▼
┌─────────────────────────────┐
│ Recipe {                    │
│  imageUrl: 'assets/...'  ✅ │
│ }                           │
└────┬────────────────────────┘
     │
     │ [recipe.imageUrl -> pasa al widget]
     │
     ▼
┌─────────────────────────────┐
│ AppImageWidget(             │
│  imageUrl: recipe.imageUrl  │
│ ) ✅                        │
└────┬────────────────────────┘
     │
     │ [detecta que es local]
     │
     ▼
┌─────────────────────────────┐
│ Image.asset(                │
│  'assets/images/...'        │
│ ) ✅                        │
└────┬────────────────────────┘
     │
     ▼
┌─────────────────────────────┐
│ PANTALLA DEL USUARIO        │
│ [Imagen hermosa] ✨        │
└─────────────────────────────┘
```

---

## 📞 Cheat Sheet Rápido

```
┌──────────┬──────────────────────────────┬─────────────────────────┐
│ Tipo     │ Ubicación                    │ Código                  │
├──────────┼──────────────────────────────┼─────────────────────────┤
│ Papillas │ age_papillas/                │ 'assets/images/recipes/ │
│ (6-8m)   │ nombre.png                   │ age_papillas/nombre.png'│
├──────────┼──────────────────────────────┼─────────────────────────┤
│ Síntomas │ info/symptoms/               │ 'assets/images/info/    │
│ Artículo │ nombre.png                   │ symptoms/nombre.png'    │
├──────────┼──────────────────────────────┼─────────────────────────┤
│ Widget   │ AppImageWidget()             │ AppImageWidget(         │
│ Mostrar  │ (detecta local/remota automá)│ imageUrl: '...')        │
└──────────┴──────────────────────────────┴─────────────────────────┘
```

---

¿Necesitas más claridad sobre algún punto? Revisa los documentos detallados o pregúntame.

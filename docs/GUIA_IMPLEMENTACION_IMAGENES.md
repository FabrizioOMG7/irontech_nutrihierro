# 🎯 Guía de Implementación - Imágenes en NutriHierro

Ejemplos prácticos paso a paso sobre cómo usar las imágenes en tu código.

---

## 📚 Tabla de Contenidos
1. [Recetas con Imágenes](#recetas-con-imágenes)
2. [Artículos con Imágenes](#artículos-con-imágenes)
3. [Widgets para Mostrar Imágenes](#widgets-para-mostrar-imágenes)
4. [Datos de Ejemplo Prácticos](#datos-de-ejemplo-prácticos)

---

## 🍽️ Recetas con Imágenes

### Paso 1: Colocar la Imagen Física

```bash
# Copiar una imagen PNG a la carpeta de papillas (6-8 meses)
cp ~/Descargas/papilla_avena.png \
  assets/images/recipes/age_papillas/papilla_avena.png
```

### Paso 2: Crear el Objeto Recipe

```dart
// Opción A: Con Asset Local (Recomendado)
final papillaAvena = Recipe(
  id: 'recipe_papilla_avena_001',
  title: 'Papilla de Avena y Plátano',
  description: 'Papilla suave y nutritiva, perfecta para iniciar la alimentación complementaria',
  imageUrl: 'assets/images/recipes/age_papillas/papilla_avena.png',  // ← Asset local
  ironContent: 3,
  targetAge: AgeCategory.papillas,
  ingredients: ['Avena', 'Plátano maduro', 'Leche materna/fórmula'],
  preparationSteps: [
    'Cocinar avena en agua durante 15 minutos',
    'Agregar plátano picado',
    'Procesar hasta lograr consistencia suave',
    'Servir tibio',
  ],
  ironContribution: 'La avena aporta hierro no-hémico',
);

// Opción B: Con Firebase Storage (Para actualizar dinámicamente)
final papillaAvenaRemota = Recipe(
  id: 'recipe_papilla_avena_002',
  title: 'Papilla de Avena y Plátano (Versión Cloud)',
  description: 'Con imagen alojada en Firebase',
  imageUrl: 'https://firebasestorage.googleapis.com/b/irontech-nutrihierro/recipes/papilla_avena.png',
  ironContent: 3,
  targetAge: AgeCategory.papillas,
  // ... resto de campos
);
```

### Paso 3: Usar en el Widget (Presentación)

```dart
// lib/features/nutrition/presentation/widgets/recipe_card.dart

import 'package:flutter/material.dart';
import 'package:irontech_nutrihierro/core/widgets/app_image_widget.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ★ Mostrar la imagen usando nuestro widget genérico
          AppImageWidget(
            imageUrl: recipe.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.description,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Chip(
                  label: Text('${recipe.ironContent}mg de hierro'),
                  backgroundColor: Colors.orange[100],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📰 Artículos con Imágenes

### Paso 1: Colocar la Imagen

```bash
# Imagen sobre síntomas de anemia
cp ~/Descargas/sintomas_palidez.png \
  assets/images/info/symptoms/sintomas_palidez.png
```

### Paso 2: Crear el Objeto AnemiaInfoArticle

```dart
// En tu fuente de datos (repository o firebas firestore)
final articuloSintomas = AnemiaInfoArticle(
  id: 'article_sintomas_001',
  title: 'Síntomas Visibles de Anemia en Infantes',
  content: '''
## ¿Cómo identificar si tu hijo tiene anemia?

La anemia infantil presenta síntomas claros:

### Palidez
- En labios, encías y párpados
- Pérdida de color en las mejillas

### Comportamental
- Apatía y falta de interés
- Menor disposición para jugar
- Fácil fatiga

### Otros Signos
- Taquicardia (corazón acelerado)
- Dificultad para respirar con esfuerzo
  ''',
  audience: 'parents',  // Audiencia: padres
  imageUrl: 'assets/images/info/symptoms/sintomas_palidez.png',  // ← Asset local
  description: 'Guía visual de los síntomas más comunes de anemia infantil',
  tags: ['síntomas', 'diagnóstico', 'palidez', 'infantil'],
  createdAt: DateTime.now(),
);
```

### Paso 3: Usar en el Widget

```dart
// lib/features/info/presentation/screens/article_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:irontech_nutrihierro/core/widgets/app_image_widget.dart';

class ArticleDetailScreen extends StatelessWidget {
  final AnemiaInfoArticle article;

  const ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ★ Mostrar imagen del artículo
            AppImageWidget(
              imageUrl: article.imageUrl ?? 'assets/images/default.png',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Contenido en Markdown
                  MarkdownBody(data: article.content),
                  const SizedBox(height: 16),
                  // Mostrar tags
                  if (article.tags != null && article.tags!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: article.tags!
                          .map((tag) => Chip(label: Text(tag)))
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Widgets para Mostrar Imágenes

### Opción 1: Widget Genérico (Recomendado)

```dart
import 'package:irontech_nutrihierro/core/widgets/app_image_widget.dart';

// Uso simple
AppImageWidget(
  imageUrl: recipe.imageUrl,
  height: 200,
  width: 200,
  fit: BoxFit.cover,
)

// Con bordes redondeados
AppImageWidget(
  imageUrl: article.imageUrl ?? 'assets/images/default.png',
  height: 250,
  borderRadius: BorderRadius.circular(16),
  fit: BoxFit.cover,
)
```

### Opción 2: Extensión (Sintaxis Simplificada)

```dart
// ★ Requiere: import 'package:irontech_nutrihierro/core/widgets/app_image_widget.dart';

recipe.imageUrl.toAppImage(
  height: 200,
  width: 200,
  borderRadius: BorderRadius.circular(8),
)
```

### Opción 3: Usando Constantes

```dart
import 'package:irontech_nutrihierro/core/constants/image_paths.dart';

// Construcción de rutas
final papillaPath = ImagePaths.buildRecipePath(
  'age_papillas',
  'papilla_avena.png'
);

AppImageWidget(imageUrl: papillaPath, height: 200)

// Con método auxiliar
final categoryPath = ImagePaths.getRecipeCategoryPath(7); // 7 meses
final fullPath = '$categoryPath/papilla_avena.png';
```

---

## 📊 Datos de Ejemplo Prácticos

### Ejemplo Completo 1: Sistema de Recetas con Imágenes

```dart
// lib/features/nutrition/data/recipes_data.dart

import 'package:irontech_nutrihierro/core/constants/image_paths.dart';
import 'package:irontech_nutrihierro/features/nutrition/domain/recipe.dart';

/// Base de datos de ejemplo con imágenes
final kRecetasEjemplo = <Recipe>[
  // LACTANCIA EXCLUSIVA (0-5 meses)
  Recipe(
    id: 'rec_lactancia_001',
    title: 'Leche Materna (Óptima)',
    description: 'La mejor fuente de hierro para recién nacidos',
    imageUrl: '${ImagePaths.recipeAgeCategoriasLactancia}/leche_materna.png',
    ironContent: 0, // El hierro viene de la leche
    targetAge: AgeCategory.lactanciaExclusiva,
    ingredients: const [],
    preparationSteps: const [],
  ),

  // PAPILLAS (6-8 meses)
  Recipe(
    id: 'rec_papillas_001',
    title: 'Papilla de Avena y Plátano',
    description: 'Inicio perfecto de la alimentación complementaria',
    imageUrl: '${ImagePaths.recipeAgeCategoriasPapillas}/papilla_avena.png',
    ironContent: 3,
    targetAge: AgeCategory.papillas,
    ingredients: const [
      'Avena integral',
      'Plátano maduro',
      'Leche materna/fórmula',
    ],
    preparationSteps: const [
      'Cocinar avena en agua',
      'Agregar plátano',
      'Procesar',
    ],
    ironContribution: 'Avena y plátano: 3mg de hierro',
  ),

  Recipe(
    id: 'rec_papillas_002',
    title: 'Papilla de Hierro (Carne + Vegetales)',
    description: 'Papilla más concentrada en hierro hémico',
    imageUrl: '${ImagePaths.recipeAgeCategoriasPapillas}/papilla_carne.png',
    ironContent: 5,
    targetAge: AgeCategory.papillas,
    ingredients: const [
      'Carne molida (res)',
      'Zanahoria',
      'Agua',
    ],
    preparationSteps: const [
      'Cocinar carne hasta blandura',
      'Agregar zanahoria',
      'Procesar bien',
    ],
    ironContribution: 'Carne roja: 5mg de hierro hémico',
  ),

  // PICADOS (9-11 meses)
  Recipe(
    id: 'rec_picados_001',
    title: 'Picado de Pollo y Espinacas',
    description: 'Hierro hémico + hierro no-hémico',
    imageUrl: '${ImagePaths.recipeAgeCategoriasPicados}/picado_pollo.png',
    ironContent: 4,
    targetAge: AgeCategory.picados,
    ingredients: const [
      'Pechuga de pollo',
      'Espinacas frescas',
      'Aceite de oliva',
    ],
    preparationSteps: const [
      'Cocinar y picar pollo',
      'Agregar espinacas',
      'Servir en pequeños trozos',
    ],
    ironContribution: 'Pollo + espinacas: 4mg hierro',
  ),

  // OLLA FAMILIAR (12-23 meses)
  Recipe(
    id: 'rec_olla_001',
    title: 'Olla Familiar: Carne, Papa y Nabo',
    description: 'Comida familiar adaptada para bebés mayoresde 12 meses',
    imageUrl: '${ImagePaths.recipeAgeCategoriasOllaFamiliar}/olla_familiar.png',
    ironContent: 6,
    targetAge: AgeCategory.ollaFamiliar,
    ingredients: const [
      'Carne de res',
      'Papas',
      'Nabo',
      'Caldo casero',
    ],
    preparationSteps: const [
      'Preparar caldo con carne',
      'Agregar vegetales',
      'Cocinar hasta blando',
      'Servir en trozos apropiados',
    ],
    ironContribution: 'Carne + vegetales: 6mg hierro',
  ),

  // ESCOLAR (24+ meses)
  Recipe(
    id: 'rec_escolar_001',
    title: 'Almuerzo Escolar: Lentejas Guisadas',
    description: 'Proteína vegetal rica en hierro',
    imageUrl: '${ImagePaths.recipeAgeCategoriasEscolar}/lentejas.png',
    ironContent: 7,
    targetAge: AgeCategory.escolar,
    ingredients: const [
      'Lentejas rojas',
      'Tomate',
      'Cebolla',
      'Ajo',
      'Aceite de oliva',
    ],
    preparationSteps: const [
      'Cocinar lentejas',
      'Preparar sofrito de cebolla y ajo',
      'Agregar tomate',
      'Mezclar con lentejas cocidas',
    ],
    ironContribution: 'Lentejas: 7mg hierro no-hémico',
  ),
];
```

### Ejemplo Completo 2: Artículos sobre Anemia

```dart
// lib/features/info/data/articles_data.dart

import 'package:irontech_nutrihierro/core/constants/image_paths.dart';
import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';

final kArticulosEjemplo = <AnemiaInfoArticle>[
  AnemiaInfoArticle(
    id: 'art_sintomas_001',
    title: 'Síntomas Visibles de Anemia Infantil',
    description: 'Aprende a identificar si tu hijo puede tener anemia',
    imageUrl: '${ImagePaths.infoSymptoms}/sintomas_palidez.png',
    content: '''
# Síntomas de Anemia en Infantes

## Señales Visibles
- Palidez en labios y encías...
    ''',
    audience: 'parents',
    tags: const ['síntomas', 'palidez', 'diagnóstico'],
    createdAt: DateTime(2026, 5, 1),
  ),

  AnemiaInfoArticle(
    id: 'art_prevención_001',
    title: 'Cómo Prevenir la Anemia',
    description: 'Estrategias nutricionales efectivas',
    imageUrl: '${ImagePaths.infoPrevention}/rutina_alimenticia.png',
    content: '''
# Prevención de Anemia

## 5 Pilares
1. Alimentos ricos en hierro...
    ''',
    audience: 'parents',
    tags: const ['prevención', 'nutrición', 'hierro'],
    createdAt: DateTime(2026, 5, 1),
  ),
];
```

---

## 🔄 Flujo Completo en una Vista

```dart
// Ejemplo de un screen que usa todo junto

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/widgets/app_image_widget.dart';
import 'package:irontech_nutrihierro/core/constants/image_paths.dart';

final selectedRecipesProvider = StateProvider<List<Recipe>>((ref) => []);

class RecipesListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(selectedRecipesProvider);

    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return ListTile(
          leading: AppImageWidget(
            imageUrl: recipe.imageUrl,
            height: 80,
            width: 80,
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(recipe.title),
          subtitle: Text(recipe.description),
          trailing: Chip(
            label: Text('${recipe.ironContent}mg Fe'),
          ),
        );
      },
    );
  }
}
```

---

## ✅ Checklist de Integración

- [ ] Crear carpetas en `assets/images/`
- [ ] Actualizar `pubspec.yaml` con las rutas de assets
- [ ] Copiar archivo de constantes `image_paths.dart`
- [ ] Copiar widget `app_image_widget.dart`
- [ ] Actualizar modelos (`Recipe`, `AnemiaInfoArticle`)
- [ ] Crear datos de ejemplo con imágenes
- [ ] Implementar widgets de presentación
- [ ] Probar carga de imágenes locales y remotas
- [ ] Ejecutar `flutter pub get`
- [ ] Verificar en el emulador

---

**Última actualización**: 1 de mayo de 2026

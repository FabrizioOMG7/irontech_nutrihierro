# 🔧 PLAN DE ACTUALIZACIÓN DE CÓDIGO

**Exactamente qué cambiaré en el código cuando tengas las imágenes**

---

## 📌 ARCHIVO A ACTUALIZAR

**Ubicación**: `lib/features/nutrition/data/nutrition_repository_impl.dart`

---

## 🔄 CAMBIOS QUE HARÉ (ORDEN EXACTO)

### CAMBIO #1: Receta ID 1 (Papilla de Sangrecita)

**ANTES (Actual)**:
```dart
Recipe(
  id: '1',
  title: 'Papilla de Sangrecita',
  description: 'Rica en hierro, ideal para empezar la alimentación complementaria. Combínala con un chorrito de limón.',
  imageUrl: 'assets/images/papilla.png',  ← AQUÍ (ruta genérica)
  ironContent: 15,
  targetAge: AgeCategory.papillas,
  //... resto
)
```

**DESPUÉS (Nuevo)**:
```dart
Recipe(
  id: '1',
  title: 'Papilla de Sangrecita',
  description: 'Rica en hierro, ideal para empezar la alimentación complementaria. Combínala con un chorrito de limón.',
  imageUrl: 'assets/images/recipes/age_papillas/papilla_sangrecita.png',  ← ACTUALIZADO
  ironContent: 15,
  targetAge: AgeCategory.papillas,
  //... resto
)
```

**CAMBIO**: `'assets/images/papilla.png'` → `'assets/images/recipes/age_papillas/papilla_sangrecita.png'`

---

### CAMBIO #2: Receta ID 2 (Puré de Hígado con Zanahoria)

**ANTES**:
```dart
Recipe(
  id: '2',
  title: 'Puré de Hígado con Zanahoria',
  description: 'Suave y dulce, perfecto para la digestión del bebé en sus primeros meses comiendo sólidos.',
  imageUrl: 'assets/images/higado.png',  ← AQUÍ
  ironContent: 12,
  targetAge: AgeCategory.papillas,
  //... resto
)
```

**DESPUÉS**:
```dart
Recipe(
  id: '2',
  title: 'Puré de Hígado con Zanahoria',
  description: 'Suave y dulce, perfecto para la digestión del bebé en sus primeros meses comiendo sólidos.',
  imageUrl: 'assets/images/recipes/age_papillas/pure_higado_zanahoria.png',  ← ACTUALIZADO
  ironContent: 12,
  targetAge: AgeCategory.papillas,
  //... resto
)
```

**CAMBIO**: `'assets/images/higado.png'` → `'assets/images/recipes/age_papillas/pure_higado_zanahoria.png'`

---

### CAMBIO #3: Receta ID 3 (Picadito de Bazo con Lentejas)

**ANTES**:
```dart
Recipe(
  id: '3',
  title: 'Picadito de Bazo con Lentejas',
  description: 'Textura ideal para aprender a masticar. Alto impacto contra la anemia.',
  imageUrl: 'assets/images/bazo.png',  ← AQUÍ
  ironContent: 18,
  targetAge: AgeCategory.picados,
  //... resto
)
```

**DESPUÉS**:
```dart
Recipe(
  id: '3',
  title: 'Picadito de Bazo con Lentejas',
  description: 'Textura ideal para aprender a masticar. Alto impacto contra la anemia.',
  imageUrl: 'assets/images/recipes/age_picados/picadito_bazo_lentejas.png',  ← ACTUALIZADO
  ironContent: 18,
  targetAge: AgeCategory.picados,
  //... resto
)
```

**CAMBIO**: `'assets/images/bazo.png'` → `'assets/images/recipes/age_picados/picadito_bazo_lentejas.png'`

---

### CAMBIO #4: Receta ID 4 (Guiso Familiar con Pescado Oscuro)

**ANTES**:
```dart
Recipe(
  id: '4',
  title: 'Guiso familiar con Pescado Oscuro',
  description: 'El niño ya puede comer de la olla familiar. El bonito o jurel son excelentes opciones.',
  imageUrl: 'assets/images/pescado.png',  ← AQUÍ
  ironContent: 10,
  targetAge: AgeCategory.ollaFamiliar,
  //... resto
)
```

**DESPUÉS**:
```dart
Recipe(
  id: '4',
  title: 'Guiso familiar con Pescado Oscuro',
  description: 'El niño ya puede comer de la olla familiar. El bonito o jurel son excelentes opciones.',
  imageUrl: 'assets/images/recipes/age_olla_familiar/guiso_pescado_oscuro.png',  ← ACTUALIZADO
  ironContent: 10,
  targetAge: AgeCategory.ollaFamiliar,
  //... resto
)
```

**CAMBIO**: `'assets/images/pescado.png'` → `'assets/images/recipes/age_olla_familiar/guiso_pescado_oscuro.png'`

---

### CAMBIO #5: Receta ID 5 (Arroz Tapado con Hígado y Lentejas)

**ANTES**:
```dart
Recipe(
  id: '5',
  title: 'Arroz tapado con hígado y lentejas',
  description: 'Receta para niños con buena aceptación. Acompaña con ensalada de tomate para sumar vitamina C.',
  imageUrl: 'assets/images/arroz_tapado.png',  ← AQUÍ
  ironContent: 14,
  targetAge: AgeCategory.escolar,
  //... resto
)
```

**DESPUÉS**:
```dart
Recipe(
  id: '5',
  title: 'Arroz tapado con hígado y lentejas',
  description: 'Receta para niños con buena aceptación. Acompaña con ensalada de tomate para sumar vitamina C.',
  imageUrl: 'assets/images/recipes/age_escolar/arroz_tapado_higado_lentejas.png',  ← ACTUALIZADO
  ironContent: 14,
  targetAge: AgeCategory.escolar,
  //... resto
)
```

**CAMBIO**: `'assets/images/arroz_tapado.png'` → `'assets/images/recipes/age_escolar/arroz_tapado_higado_lentejas.png'`

---

### CAMBIO #6: Receta ID 6 (Tortilla de Sangrecita con Quinua)

**ANTES**:
```dart
Recipe(
  id: '6',
  title: 'Tortilla de sangrecita con quinua',
  description: 'Opción práctica para lonchera o cena, con hierro de alta biodisponibilidad.',
  imageUrl: 'assets/images/tortilla_sangrecita.png',  ← AQUÍ
  ironContent: 16,
  targetAge: AgeCategory.escolar,
  //... resto
)
```

**DESPUÉS**:
```dart
Recipe(
  id: '6',
  title: 'Tortilla de sangrecita con quinua',
  description: 'Opción práctica para lonchera o cena, con hierro de alta biodisponibilidad.',
  imageUrl: 'assets/images/recipes/age_escolar/tortilla_sangrecita_quinua.png',  ← ACTUALIZADO
  ironContent: 16,
  targetAge: AgeCategory.escolar,
  //... resto
)
```

**CAMBIO**: `'assets/images/tortilla_sangrecita.png'` → `'assets/images/recipes/age_escolar/tortilla_sangrecita_quinua.png'`

---

## 📊 RESUMEN DE CAMBIOS

| # | imageUrl ACTUAL | imageUrl NUEVO |
|----|---|---|
| 1 | `assets/images/papilla.png` | `assets/images/recipes/age_papillas/papilla_sangrecita.png` |
| 2 | `assets/images/higado.png` | `assets/images/recipes/age_papillas/pure_higado_zanahoria.png` |
| 3 | `assets/images/bazo.png` | `assets/images/recipes/age_picados/picadito_bazo_lentejas.png` |
| 4 | `assets/images/pescado.png` | `assets/images/recipes/age_olla_familiar/guiso_pescado_oscuro.png` |
| 5 | `assets/images/arroz_tapado.png` | `assets/images/recipes/age_escolar/arroz_tapado_higado_lentejas.png` |
| 6 | `assets/images/tortilla_sangrecita.png` | `assets/images/recipes/age_escolar/tortilla_sangrecita_quinua.png` |

---

## 🔒 LO QUE NO CAMBIARÉ

```dart
// ESTOS CAMPOS PERMANECEN IGUAL:
id: '1',                    // ← No cambia
title: 'Papilla de...',     // ← No cambia
description: '...',         // ← No cambia
ironContent: 15,            // ← No cambia
targetAge: AgeCategory...,  // ← No cambia
ingredients: [...],         // ← No cambia
preparationSteps: [...],    // ← No cambia
ironContribution: '...',    // ← No cambia
```

**Solo cambio el `imageUrl`** ✅

---

## ✅ PROCESO COMPLETO

```
1. TÚ DESCARGAS 6 imágenes
   └─→ Nombres exactos según la lista

2. TÚ ORGANIZAS en ~/Descargas/

3. TÚ AVÍSAS: "Listo, tengo las imágenes"

4. YO HAGO (automáticamente):
   ├─→ Copiar cada imagen a su carpeta exacta
   ├─→ Actualizar 6 líneas imageUrl en el código
   ├─→ Ejecutar `flutter pub get`
   └─→ Verificar que funciona

5. RESULTADO: Recetas con imágenes funcionando ✨
```

---

## 📝 CONFIRMACIÓN

Cuando tengas las imágenes listas y me avises, **yo haré**:

```bash
# 1. Copiar imágenes
cp ~/Descargas/papilla_sangrecita.png \
   assets/images/recipes/age_papillas/papilla_sangrecita.png

cp ~/Descargas/pure_higado_zanahoria.png \
   assets/images/recipes/age_papillas/pure_higado_zanahoria.png

# ... (y así para las 6)

# 2. Actualizar código automáticamente
# (Reemplazar 6 líneas imageUrl)

# 3. Verificar
flutter pub get
flutter run
```

---

**¿LISTA?** 🚀

1. Busca las 6 imágenes según `LISTA_DESCARGAS_IMAGENES.md`
2. Colócalas en `~/Descargas/`
3. Avísame cuando estén listas
4. Yo haré todo el resto automáticamente

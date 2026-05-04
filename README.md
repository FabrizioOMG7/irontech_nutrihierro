# irontech_nutrihierro

App móvil IronTech NutriHierro para prevención de anemia infantil.

## Generar APK (release)

1. Crea el keystore (no lo subas al repo):
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   Este comando crea el archivo en `android/app/upload-keystore.jks`.
2. Copia el ejemplo de propiedades y ajusta las credenciales:
   ```bash
   cp android/key.properties.example android/key.properties
   ```
   La ruta `storeFile` se interpreta relativa a la carpeta `android/`.
3. Compila el APK:
   ```bash
   flutter build apk --release
   ```
4. El APK generado queda en:
   `build/app/outputs/flutter-apk/app-release.apk`

Para descargarlo, copia solo el APK generado (`build/app/outputs/flutter-apk/app-release.apk`) a tu PC/Drive.
Si necesitas compartirlo, comparte el APK por un canal seguro.
No compartas el keystore.
Si quieres instalarlo en un dispositivo, usa:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## UI/UX

- El tema centralizado (`lib/theme/app_theme.dart`) usa tipografía de `google_fonts` para mantener estilo consistente entre pantallas.

## Documentación de próximos pasos

- Auditoría y plan de arquitectura: `docs/NEXT_STEPS.md`
- Preparación para Firebase (sin conexión activa): `docs/FIREBASE_PREPARATION.md`

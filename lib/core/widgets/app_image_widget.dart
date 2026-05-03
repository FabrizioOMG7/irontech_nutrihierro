/// lib/core/widgets/app_image_widget.dart
///
/// Widget genérico para mostrar imágenes que soporta tanto assets locales
/// como URLs remotas de Firebase Storage automáticamente.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:irontech_nutrihierro/core/constants/image_paths.dart';

/// Widget genérico que maneja automáticamente:
/// - Assets locales: Image.asset()
/// - URLs remotas: CachedNetworkImage()
class AppImageWidget extends StatelessWidget {
  final String imageUrl;           // Ruta local (assets/...) o URL remota
  final double? height;            // Altura en píxeles
  final double? width;             // Ancho en píxeles
  final BoxFit fit;                // Cómo se ajusta la imagen
  final BorderRadius? borderRadius;// Radio de esquinas redondeadas
  final BoxBorder? border;         // Borde de la imagen
  final Color? backgroundColor;    // Color de fondo mientras carga

  const AppImageWidget({
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Detectar si es un asset local o URL remota
    final isLocal = ImagePaths.isLocalAsset(imageUrl);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[200],
        borderRadius: borderRadius,
        border: border,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: isLocal ? _buildLocalImage() : _buildRemoteImage(),
      ),
    );
  }

  /// Construye la imagen local usando Image.asset()
  Widget _buildLocalImage() {
    return Image.asset(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _errorWidget('Imagen no encontrada');
      },
    );
  }

  /// Construye la imagen remota usando CachedNetworkImage()
  Widget _buildRemoteImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) => _loadingWidget(),
      errorWidget: (context, url, error) {
        return _errorWidget('Error al cargar imagen');
      },
    );
  }

  /// Widget mostrado mientras la imagen está cargando
  Widget _loadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.blue[400] ?? Colors.blue,
        ),
      ),
    );
  }

  /// Widget mostrado cuando hay error al cargar la imagen
  Widget _errorWidget(String message) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.grey[600], size: 48),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Extensión para simplificar el uso en vistas
extension AppImageExt on String {
  /// Permite usar: 'assets/images/recipes/age_papillas/imagen.png'.toAppImage()
  Widget toAppImage({
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return AppImageWidget(
      imageUrl: this,
      height: height,
      width: width,
      fit: fit,
      borderRadius: borderRadius,
    );
  }
}

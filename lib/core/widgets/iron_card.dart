import 'package:flutter/material.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/app_image_widget.dart';

class IronCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl; // URL de la imagen (asset o remota)
  final Widget? trailingWidget; // Espacio flexible para etiquetas o íconos

  const IronCard({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen o placeholder
          if (imageUrl != null && imageUrl!.isNotEmpty)
            AppImageWidget(
              imageUrl: imageUrl!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            )
          else
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              ),
              child: Icon(
                Icons.image,
                size: 50,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    if (trailingWidget != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      trailingWidget!,
                    ]
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

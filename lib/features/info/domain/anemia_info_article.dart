/// Entidad que representa un artículo educativo sobre anemia
/// Puede incluir imágenes locales (assets) o remotas (Firebase Storage)
class AnemiaInfoArticle {
  final String id;
  final String title;
  final String content;           // Texto del artículo (HTML o Markdown)
  final String audience;          // 'parents' | 'health_workers' | 'general'
  final String? imageUrl;         // URL de Firebase Storage o ruta local en assets
  final String? description;      // Descripción corta del artículo
  final DateTime? createdAt;      // Fecha de creación
  final List<String>? tags;       // Tags para categorizar artículos

  const AnemiaInfoArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.audience,
    this.imageUrl,
    this.description,
    this.createdAt,
    this.tags,
  });
}

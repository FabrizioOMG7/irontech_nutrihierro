import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';

class LocalAnemiaInfoDataSource {
  Future<List<AnemiaInfoArticle>> getArticles() async {
    return const [
      AnemiaInfoArticle(
        id: 'info_1',
        title: '¿Qué es la anemia infantil?',
        content:
            'La anemia infantil es una condición en la que baja la hemoglobina y puede afectar el desarrollo cognitivo y físico.',
        audience: 'familias',
      ),
      AnemiaInfoArticle(
        id: 'info_2',
        title: 'Síntomas frecuentes',
        content:
            'Cansancio, palidez, pérdida de apetito e irritabilidad pueden ser señales de alerta.',
        audience: 'familias',
      ),
    ];
  }
}

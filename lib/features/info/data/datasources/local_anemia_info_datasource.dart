import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';

class LocalAnemiaInfoDataSource {
  Future<List<AnemiaInfoArticle>> getArticles() async {
    return const [
      AnemiaInfoArticle(
        id: 'info_1',
        title: 'Anemia: concepto básico',
        content:
            'La anemia ocurre cuando la hemoglobina está baja y el cuerpo no transporta suficiente oxígeno. Una alimentación rica en hierro, vitamina C y controles médicos ayuda a prevenirla.',
        audience: 'familias',
      ),
      AnemiaInfoArticle(
        id: 'info_2',
        title: 'Anemia infantil',
        content:
            'En niños puede impactar crecimiento, aprendizaje y defensas. Es importante reforzar alimentos con hierro desde la alimentación complementaria y seguir indicaciones del centro de salud.',
        audience: 'familias',
      ),
      AnemiaInfoArticle(
        id: 'info_3',
        title: 'Síntomas y consecuencias',
        content:
            'Síntomas frecuentes: palidez, cansancio, irritabilidad y poco apetito. Si no se corrige a tiempo, puede afectar el desarrollo cognitivo y motor.',
        audience: 'familias',
      ),
    ];
  }
}

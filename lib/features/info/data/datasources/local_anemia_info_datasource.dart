import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';

class LocalAnemiaInfoDataSource {
  Future<List<AnemiaInfoArticle>> getArticles() async {
    return const [
      AnemiaInfoArticle(
        id: 'info_1',
        title: '¿Qué es la anemia?',
        content:
            'La anemia aparece cuando la hemoglobina está baja y el cuerpo transporta menos oxígeno.\n\n'
            '¿Por qué importa?\n'
            '• El niño puede cansarse más rápido.\n'
            '• Puede tener menos apetito o menor interés en jugar.\n'
            '• Puede afectar su desarrollo si no se corrige a tiempo.\n\n'
            'Qué hacer en casa:\n'
            '• Mantener controles de crecimiento y hemoglobina.\n'
            '• Ofrecer alimentos ricos en hierro todos los días.\n'
            '• Seguir la indicación médica sobre suplementos cuando corresponda.',
        audience: 'familias',
      ),
      AnemiaInfoArticle(
        id: 'info_2',
        title: 'Anemia infantil',
        content:
            'En bebés y niños pequeños, la anemia puede impactar el crecimiento, el aprendizaje y las defensas.\n\n'
            'Señales de riesgo:\n'
            '• Alimentación baja en hierro por varios días.\n'
            '• Bajo consumo de carnes, sangrecita o menestras.\n'
            '• Falta de seguimiento en controles de salud.\n\n'
            'Recomendación clave:\n'
            '• Desde la alimentación complementaria, incluir hierro en preparaciones diarias.\n'
            '• Combinar con frutas ricas en vitamina C para mejorar absorción.',
        audience: 'familias',
      ),
      AnemiaInfoArticle(
        id: 'info_3',
        title: 'Síntomas y consecuencias',
        content:
            'Síntomas frecuentes:\n'
            '• Palidez en piel o labios.\n'
            '• Cansancio, irritabilidad o sueño excesivo.\n'
            '• Poco apetito.\n\n'
            'Consecuencias si no se trata:\n'
            '• Menor atención y aprendizaje.\n'
            '• Retraso en desarrollo motor y cognitivo.\n'
            '• Mayor susceptibilidad a infecciones.',
        audience: 'familias',
      ),
      AnemiaInfoArticle(
        id: 'info_4',
        title: 'Prevención diaria en casa',
        content:
            'Rutina simple de prevención:\n'
            '• Planificar al menos una comida rica en hierro cada día.\n'
            '• Evitar reemplazar comidas por solo líquidos sin nutrientes.\n'
            '• Asistir a controles pediátricos y seguir el plan del centro de salud.\n\n'
            'Tip práctico:\n'
            '• Sirve porciones pequeñas y frecuentes si el niño tiene poco apetito.',
        audience: 'familias',
      ),
      AnemiaInfoArticle(
        id: 'info_5',
        title: 'Recomendaciones alimentarias básicas',
        content:
            'Opciones útiles:\n'
            '• Sangrecita, hígado de pollo, bazo.\n'
            '• Pescado, carne de res y menestras.\n'
            '• Verduras de hoja verde como complemento.\n\n'
            'Mejor absorción de hierro:\n'
            '• Añadir vitamina C (naranja, mandarina, limón).\n'
            '• Evitar té o café cerca de las comidas del niño.',
        audience: 'familias',
      ),
    ];
  }
}

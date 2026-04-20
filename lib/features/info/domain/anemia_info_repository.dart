import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';

abstract class AnemiaInfoRepository {
  Future<List<AnemiaInfoArticle>> getArticles();
}

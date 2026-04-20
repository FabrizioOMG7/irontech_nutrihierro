import 'package:irontech_nutrihierro/features/info/data/datasources/local_anemia_info_datasource.dart';
import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';
import 'package:irontech_nutrihierro/features/info/domain/anemia_info_repository.dart';

class LocalAnemiaInfoRepository implements AnemiaInfoRepository {
  final LocalAnemiaInfoDataSource datasource;

  LocalAnemiaInfoRepository({required this.datasource});

  @override
  Future<List<AnemiaInfoArticle>> getArticles() {
    return datasource.getArticles();
  }
}

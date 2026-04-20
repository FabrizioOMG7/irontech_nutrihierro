import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/features/info/data/datasources/local_anemia_info_datasource.dart';
import 'package:irontech_nutrihierro/features/info/data/repositories/local_anemia_info_repository.dart';
import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';
import 'package:irontech_nutrihierro/features/info/domain/anemia_info_repository.dart';

final anemiaInfoRepositoryProvider = Provider<AnemiaInfoRepository>((ref) {
  return LocalAnemiaInfoRepository(datasource: LocalAnemiaInfoDataSource());
});

final anemiaInfoArticlesProvider = FutureProvider<List<AnemiaInfoArticle>>((
  ref,
) async {
  return ref.read(anemiaInfoRepositoryProvider).getArticles();
});

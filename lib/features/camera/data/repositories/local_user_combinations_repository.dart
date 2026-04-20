import 'package:irontech_nutrihierro/core/models/user_combination.dart';
import 'package:irontech_nutrihierro/features/camera/data/datasources/local_user_combinations_datasource.dart';
import 'package:irontech_nutrihierro/features/camera/domain/user_combinations_repository.dart';

class LocalUserCombinationsRepository implements UserCombinationsRepository {
  final LocalUserCombinationsDataSource datasource;

  LocalUserCombinationsRepository({required this.datasource});

  @override
  Future<List<UserCombination>> getByUser(String userId) {
    return datasource.getByUser(userId);
  }

  @override
  Future<void> save(UserCombination combination) {
    return datasource.save(combination);
  }
}

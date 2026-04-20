import 'package:irontech_nutrihierro/core/models/user_combination.dart';

abstract class UserCombinationsRepository {
  Future<List<UserCombination>> getByUser(String userId);
  Future<void> save(UserCombination combination);
}

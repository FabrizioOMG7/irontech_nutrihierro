import 'package:irontech_nutrihierro/core/models/user_combination.dart';

abstract class UserLibraryRepository {
  Future<List<UserCombination>> getUserSavedCombinations(String userId);
}

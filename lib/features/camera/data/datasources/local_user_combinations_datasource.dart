import 'package:irontech_nutrihierro/core/models/user_combination.dart';

class LocalUserCombinationsDataSource {
  final List<UserCombination> _db = [];

  Future<List<UserCombination>> getByUser(String userId) async {
    return _db.where((item) => item.userId == userId).toList();
  }

  Future<void> save(UserCombination combination) async {
    _db.removeWhere((item) => item.id == combination.id);
    _db.add(combination);
  }
}

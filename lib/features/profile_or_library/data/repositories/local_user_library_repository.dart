import 'package:irontech_nutrihierro/core/models/user_combination.dart';
import 'package:irontech_nutrihierro/features/camera/domain/user_combinations_repository.dart';
import 'package:irontech_nutrihierro/features/profile_or_library/domain/user_library_repository.dart';

class LocalUserLibraryRepository implements UserLibraryRepository {
  final UserCombinationsRepository combinationsRepository;

  LocalUserLibraryRepository({required this.combinationsRepository});

  @override
  Future<List<UserCombination>> getUserSavedCombinations(String userId) {
    return combinationsRepository.getByUser(userId);
  }
}

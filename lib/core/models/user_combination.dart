class UserCombination {
  final String id;
  final String userId;
  final List<String> foodIds;
  final String? note;
  final String? localImagePath;
  final DateTime createdAt;

  const UserCombination({
    required this.id,
    required this.userId,
    required this.foodIds,
    required this.createdAt,
    this.note,
    this.localImagePath,
  });
}

class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> foodIds;
  final List<String> preparationSteps;
  final String imageAsset;
  final String targetStage;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.foodIds,
    required this.preparationSteps,
    required this.imageAsset,
    required this.targetStage,
  });
}

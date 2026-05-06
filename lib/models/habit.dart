class Habit {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final bool isCompleted;
  final String imageAsset;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    this.isCompleted = false,
    this.imageAsset = 'assets/meditation.png',
  });

  Habit copyWith({bool? isCompleted}) {
    return Habit(
      id: id,
      title: title,
      description: description,
      category: category,
      duration: duration,
      isCompleted: isCompleted ?? this.isCompleted,
      imageAsset: imageAsset,
    );
  }
}
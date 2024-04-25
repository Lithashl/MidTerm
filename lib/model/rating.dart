final String tableRating = 'rating';

class RatingFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, time
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
  static final Int = 'starCount';
}

class Rating {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Rating({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Rating copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Rating(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Rating fromJson(Map<String, Object?> json) => Rating(
    id: json[RatingFields.id] as int?,
    isImportant: json[RatingFields.isImportant] == 1,
    number: json[RatingFields.number] as int,
    title: json[RatingFields.title] as String,
    description: json[RatingFields.description] as String,
    createdTime: DateTime.parse(json[RatingFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    RatingFields.id: id,
    RatingFields.title: title,
    RatingFields.isImportant: isImportant ? 1 : 0,
    RatingFields.number: number,
    RatingFields.description: description,
    RatingFields.time: createdTime.toIso8601String(),
  };
}

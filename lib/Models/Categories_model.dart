class Categories {
  late final int id;
  final String name;
  final String description;

  Categories({required this.id, required this.name, required this.description});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
        id: json['id'],
        name: json['name'],
        description: json['description']);
  }

  Object? toJson() {
    return null;
  }
}

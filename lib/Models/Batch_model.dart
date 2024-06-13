class Batch{

  late final int id;
  late final int year;

  Batch({
    required this.id,
    required this.year
});

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'],
      year:json['year']
    );
  }

  Object? toJson() {
    return null;
  }

}
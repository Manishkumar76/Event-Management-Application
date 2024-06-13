class Department {
  late final int id;
  final String dep_name;


  Department({required this.id, required this.dep_name, });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
        id: json['id'], dep_name: json['dep_name']);
  }

  Object? toJson() {
    return null;
  }
}

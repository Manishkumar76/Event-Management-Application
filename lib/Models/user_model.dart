class User {
  int id;
  String profileImage;
  String name;
  String email;
  String verifyEmail; // Use camelCase for Dart convention
  String token;
  String password;
  String rollNo; // Use camelCase for Dart convention
  String userType; // Use camelCase for Dart convention
  String gender;
  int departmentId;
  String phone;
  int age;
  int batchId;

  User({
    required this.id,
    required this.profileImage,
    required this.name,
    required this.email,
    required this.verifyEmail,
    required this.token,
    required this.password,
    required this.rollNo,
    required this.userType,
    required this.gender,
    required this.departmentId,
    required this.phone,
    required this.age,
    required this.batchId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_image': profileImage,
      'name': name,
      'email': email,
      'verify_email': verifyEmail,
      'token': token,
      'password': password,
      'roll_no': rollNo,
      'user_type': userType,
      'gender': gender,
      'department_id': departmentId,
      'phone': phone,
      'age': age,
      'batch_id': batchId,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // Assign default value if null
      profileImage: json['profile_image'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      rollNo: json['roll_no'] ?? '',
      userType: json['user_type'] ?? '',
      gender: json['gender'] ?? '',
      departmentId: json['department_id'] ?? 0, // Assign default value if null
      phone: json['phone'] ?? '',
      age: json['age'] ?? 0, // Assign default value if null
      batchId: json['batch_id'] ?? 0,
      verifyEmail: '',
      token: '', // Assign default value if null
    );
  }

}

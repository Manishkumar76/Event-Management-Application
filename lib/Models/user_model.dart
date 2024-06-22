class User {
  int id;
  String profileImage;
  String name;
  String email;
  String password;
  String rollNo;
  String userType;
  String gender;
  String phone;
  int age;
  int departmentId;
  int batchId;

  User({
    required this.id,
    required this.profileImage,
    required this.name,
    required this.email,
    required this.password,
    required this.rollNo,
    required this.userType,
    required this.gender,
    required this.phone,
    required this.age,
    required this.departmentId,
    required this.batchId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_image': profileImage,
      'name': name,
      'email': email,
      'password': password,
      'roll_no': rollNo,
      'user_type': userType,
      'gender': gender,
      'phone': phone,
      'age': age,
      'department_id': departmentId,
      'batch_id': batchId,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      profileImage: json['profile_image'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      rollNo: json['roll_no'],
      userType: json['user_type'],
      gender: json['gender'],
      phone: json['phone'],
      age: json['age'],
      departmentId: json['department_id'],
      batchId: json['batch_id'],
    );
  }
}

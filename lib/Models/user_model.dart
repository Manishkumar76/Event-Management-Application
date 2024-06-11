class User {
  final int id;
  final String profileImage;
  final String name;
  final String email;
  final String password;
  final String rollNo;
  final String userType;
  final String gender;
  final String phone;
  final int age;

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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      profileImage: json['profile_image'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      rollNo: json['roll_no'],
      userType: json['usertype'],
      gender: json['gender'],
      phone: json['phone'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_image': profileImage,
      'name': name,
      'email': email,
      'password': password,
      'roll_no': rollNo,
      'usertype': userType,
      'gender': gender,
      'phone': phone,
      'age': age,
    };
  }
}

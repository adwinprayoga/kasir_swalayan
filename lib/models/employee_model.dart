// File: lib/models/employee_model.dart
class Employee {
  final int? id;
  final String name;
  final String username;
  final String password;

  Employee({
    this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
    );
  }
}
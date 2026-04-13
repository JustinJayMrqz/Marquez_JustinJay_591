class Student {
  final String id;
  final String name;
  final int age;
  final double gpa;

  Student({
    required this.age,
    required this.name,
    required this.id,
    required this.gpa,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      gpa: (map['gpa'] as num).toDouble(),
    );
  }

  Map< String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age, 'gpa': gpa};
  }
}



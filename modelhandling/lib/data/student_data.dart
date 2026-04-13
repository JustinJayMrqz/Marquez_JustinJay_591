import 'package:modelhandling/model/student.dart';

class StudentService {
  Future<List<Student>> fetchStudents() async {
    await Future.delayed(const Duration(seconds: 2));

    final rawData = [
      {'id': '2', 'name': 'Reynaldo Talabucon', 'age': 20, 'gpa': 1.5},
      {'id': '3', 'name': 'Brian Corpuz', 'age': 20, 'gpa': 1.5},
      {'id': '4', 'name': 'Jamir Gayorgor', 'age': 18, 'gpa': 1.8},
      {'id': '5', 'name': 'Justin Delacruz', 'age': 19, 'gpa': 1.5},
      {'id': '6', 'name': 'Pyke Delacruz', 'age': 29, 'gpa': 2.0},
      {'id': '7', 'name': 'Jerald Delacruz', 'age': 29, 'gpa': 1.7},
      {'id': '8', 'name': 'Jesaurus Delacruz', 'age': 29, 'gpa': 1.3},
    ];

    return rawData.map((data) => Student.fromMap(data)).toList();
  }
}

// File: lib/controller/student_controller  .dart

import 'package:modelhandling_02/models/student.dart';
class StudentController {
  // Internal list to store all students

  final List<Student> _students = [];

  // Get all students (read-only copy)

  List<Student> getAllStudents() {
    return List.unmodifiable(_students);
  }

  // Add a new student to the list

  void addStudent(String id, String name, String course, double gpa) {
    final student = Student(id: id, name: name, course: course, gpa: gpa);

    _students.add(student);
  }

  // Find a student by their ID

  Student? findById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (e) {
      return null; // Not found
    }
  }

  // Delete a student by their ID

  bool deleteStudent(String id) {
    final index = _students.indexWhere((s) => s.id == id);

    if (index != -1) {
      _students.removeAt(index);

      return true;
    }

    return false;
  }

  bool updateStudent(
    String id,
    String newName,
    String newCourse,
    double newGPA,
  ) {
    final index = _students.indexWhere((s) => s.id == id);
    if (index != -1) {
      _students[index] = Student(
        id: id,
        name: newName,
        course: newCourse,
        gpa: newGPA,
      );
      return true;
    }
    return false;
  }
  // Get total count of students

  int getCount() {
    return _students.length;
  }
}

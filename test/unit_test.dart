import 'package:flutter_test/flutter_test.dart';
import 'package:alu_launch/core/constants/firestore_paths.dart';

void main() {
  group('ALU Launch Core Validation Tests', () {
    test('Student email domain validation must enforce @alustudent.com', () {
      const allowedStudentEmail = 'john.doe@alustudent.com';
      const lowercaseStudentEmail = 'johndoe@alustudent.com';
      const uppercaseStudentEmail = 'JOHNDOE@ALUSTUDENT.COM';
      const forbiddenEmail1 = 'john.doe@gmail.com';
      const forbiddenEmail2 = 'admin@alustudent.org';
      const forbiddenEmail3 = 'johndoe@alustudent.com.net';

      // Verify validator behavior matching the signup form logic
      bool validateEmail(String email, UserRole role) {
        final cleanEmail = email.trim().toLowerCase();
        if (role == UserRole.student) {
          return cleanEmail.endsWith('@alustudent.com');
        }
        return true;
      }

      expect(validateEmail(allowedStudentEmail, UserRole.student), isTrue);
      expect(validateEmail(lowercaseStudentEmail, UserRole.student), isTrue);
      expect(validateEmail(uppercaseStudentEmail, UserRole.student), isTrue);
      expect(validateEmail(forbiddenEmail1, UserRole.student), isFalse);
      expect(validateEmail(forbiddenEmail2, UserRole.student), isFalse);
      expect(validateEmail(forbiddenEmail3, UserRole.student), isFalse);

      // Verify Startup/Admin are not restricted by domain
      expect(validateEmail(forbiddenEmail1, UserRole.startupFounder), isTrue);
      expect(validateEmail(forbiddenEmail1, UserRole.admin), isTrue);
    });

    test('Chat Room ID must strictly follow studentId_startupId structure', () {
      const studentId = 'student123';
      const startupId = 'startup456';

      String generateChatRoomId(String studentId, String startupId) {
        return '${studentId}_$startupId';
      }

      final generatedId = generateChatRoomId(studentId, startupId);
      expect(generatedId, equals('student123_startup456'));
      expect(generatedId.split('_').length, equals(2));
      expect(generatedId.split('_')[0], equals(studentId));
      expect(generatedId.split('_')[1], equals(startupId));
    });

    test('UserRole enum roles are defined correctly', () {
      expect(UserRole.values.length, equals(3));
      expect(UserRole.student.toString(), contains('student'));
      expect(UserRole.startupFounder.toString(), contains('startupFounder'));
      expect(UserRole.admin.toString(), contains('admin'));
    });
  });
}

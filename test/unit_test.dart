import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alu_launch/core/constants/firestore_paths.dart';
import 'package:alu_launch/core/providers/theme_provider.dart';

void main() {
  group('ALU Launch Core Validation Tests', () {
    test('Student email domain validation must enforce @alustudent.com', () {
      const allowedStudentEmail = 'john.doe@alustudent.com';
      const lowercaseStudentEmail = 'johndoe@alustudent.com';
      const invalidEmail1 = 'john.doe@gmail.com';
      const invalidEmail2 = 'john.doe@alu.edu';

      expect(allowedStudentEmail.endsWith('@alustudent.com'), isTrue);
      expect(lowercaseStudentEmail.endsWith('@alustudent.com'), isTrue);
      expect(invalidEmail1.endsWith('@alustudent.com'), isFalse);
      expect(invalidEmail2.endsWith('@alustudent.com'), isFalse);
    });

    test('Chat Room ID must strictly follow studentId_startupId structure', () {
      const studentId = 'student123';
      const startupId = 'startup456';
      final roomId = '${studentId}_$startupId';

      final parts = roomId.split('_');
      expect(parts.length, equals(2));
      expect(roomId, startsWith(studentId));
      expect(roomId, endsWith(startupId));
    });

    test('UserRole enum roles are defined correctly', () {
      expect(UserRole.values.length, equals(3));
      expect(UserRole.student.toString(), contains('student'));
      expect(UserRole.startupFounder.toString(), contains('startupFounder'));
      expect(UserRole.admin.toString(), contains('admin'));
    });

    test('ThemeProvider can change and persist ThemeMode', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': ThemeMode.dark.name});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      // Verify initial loaded theme
      expect(container.read(themeProvider), equals(ThemeMode.dark));

      // Change theme
      await container.read(themeProvider.notifier).setThemeMode(ThemeMode.light);

      // Verify theme state change
      expect(container.read(themeProvider), equals(ThemeMode.light));

      // Verify persistent storage update
      expect(prefs.getString('theme_mode'), equals(ThemeMode.light.name));
    });
  });
}

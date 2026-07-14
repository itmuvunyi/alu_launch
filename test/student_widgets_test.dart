import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alu_launch/core/constants/firestore_paths.dart';
import 'package:alu_launch/features/authentication/models/app_user.dart';
import 'package:alu_launch/features/authentication/providers/auth_providers.dart';
import 'package:alu_launch/features/internships/models/opportunity.dart';
import 'package:alu_launch/features/internships/providers/internship_providers.dart';
import 'package:alu_launch/features/applications/models/application.dart';
import 'package:alu_launch/features/applications/providers/application_providers.dart';
import 'package:alu_launch/features/notifications/models/notification.dart';
import 'package:alu_launch/features/notifications/providers/notification_providers.dart';
import 'package:alu_launch/features/messages/providers/message_providers.dart';
import 'package:alu_launch/features/messages/models/message.dart';
import 'package:alu_launch/features/messages/repositories/message_repository.dart';
import 'package:alu_launch/features/student/presentation/screens/student_home_screen.dart';
import 'package:alu_launch/features/student/presentation/screens/student_explore_screen.dart';
import 'package:alu_launch/features/student/presentation/screens/student_bookmarks_screen.dart';
import 'package:alu_launch/features/student/presentation/screens/student_profile_screen.dart';
import 'package:alu_launch/features/applications/presentation/screens/my_applications_screen.dart';
import 'package:alu_launch/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:alu_launch/features/internships/presentation/screens/opportunity_details_screen.dart';
import 'package:alu_launch/features/startup/presentation/screens/startup_profile_read_only_screen.dart';
import 'package:alu_launch/features/applications/presentation/screens/application_tracking_screen.dart';
import 'package:alu_launch/features/messages/presentation/screens/chat_screen.dart';
import 'package:alu_launch/features/messages/presentation/screens/chat_inbox_screen.dart';
import 'package:alu_launch/features/startup/models/startup.dart';
import 'package:alu_launch/features/startup/providers/startup_providers.dart';

class MockMessageRepository implements MessageRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #markAsRead) {
      return Future<void>.value();
    }
    return null;
  }
}

void main() {
  final mockUser = AppUser(
    uid: 'student123',
    email: 'student@alustudent.com',
    role: UserRole.student,
    displayName: 'Test Student',
    createdAt: DateTime.now(),
    isVerified: true,
    headline: 'Flutter Developer',
    campus: 'Kigali',
  );

  final mockOpportunity = Opportunity(
    id: 'opp123',
    startupId: 'startup123',
    startupName: 'Test Startup',
    title: 'Software Engineer Intern',
    description: 'Build awesome apps.',
    requirements: ['Flutter', 'Dart'],
    location: 'Kigali',
    type: 'Internship',
    duration: '3 months',
    stipend: '\$500/mo',
    skillsRequired: ['Flutter'],
    createdAt: DateTime.now(),
  );

  final mockApplication = Application(
    id: 'app123',
    opportunityId: 'opp123',
    opportunityTitle: 'Software Engineer Intern',
    startupId: 'startup123',
    startupName: 'Test Startup',
    studentId: 'student123',
    studentName: 'Test Student',
    studentEmail: 'student@alustudent.com',
    status: ApplicationStatus.applied,
    timeline: [],
    createdAt: DateTime.now(),
  );

  final mockNotification = NotificationModel(
    id: 'notif123',
    userId: 'student123',
    title: 'Application Update',
    body: 'Your application was received.',
    type: 'application',
    createdAt: DateTime.now(),
  );

  final mockStartup = Startup(
    id: 'startup123',
    ownerId: 'founder123',
    name: 'Test Startup',
    industry: 'Technology',
    description: 'A cool startup.',
    location: 'Kigali',
    email: 'info@startup.com',
    createdAt: DateTime.now(),
  );

  final mockChatRoom = ChatRoom(
    id: 'room123',
    studentId: 'student123',
    studentName: 'Test Student',
    startupId: 'startup123',
    startupName: 'Test Startup',
    lastMessage: 'Hello',
    lastMessageTime: DateTime.now(),
    unreadByStudent: 0,
    unreadByFounder: 0,
  );

  final mockMessage = ChatMessage(
    id: 'msg123',
    senderId: 'student123',
    senderName: 'Test Student',
    text: 'Hello',
    createdAt: DateTime.now(),
  );

  Widget buildTestableWidget(Widget child) {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWith((ref) => Stream.value(mockUser)),
        opportunitiesStreamProvider.overrideWith((ref) => Stream.value([mockOpportunity])),
        bookmarkedIdsStreamProvider.overrideWith((ref) => Stream.value(['opp123'])),
        bookmarkedOpportunitiesStreamProvider.overrideWith((ref) => Stream.value([mockOpportunity])),
        studentApplicationsStreamProvider.overrideWith((ref) => Stream.value([mockApplication])),
        notificationsStreamProvider.overrideWith((ref) => Stream.value([mockNotification])),
        unreadNotificationsCountProvider.overrideWith((ref) => 1),
        studentUnreadMessagesCountProvider.overrideWith((ref) => 0),
        opportunityDetailsProvider('opp123').overrideWith((ref) => Future.value(mockOpportunity)),
        startupDetailsStreamProvider('startup123').overrideWith((ref) => Stream.value(mockStartup)),
        applicationDetailsStreamProvider('app123').overrideWith((ref) => Stream.value(mockApplication)),
        chatRoomStreamProvider('room123').overrideWith((ref) => Stream.value(mockChatRoom)),
        chatMessagesStreamProvider('room123').overrideWith((ref) => Stream.value([mockMessage])),
        studentChatRoomsStreamProvider.overrideWith((ref) => Stream.value([mockChatRoom])),
        messageRepositoryProvider.overrideWithValue(MockMessageRepository()),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('StudentHomeScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const StudentHomeScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Test Student!'), findsOneWidget);
  });

  testWidgets('StudentExploreScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const StudentExploreScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Explore Opportunities'), findsOneWidget);
  });

  testWidgets('StudentBookmarksScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const StudentBookmarksScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Saved Bookmarks'), findsOneWidget);
  });

  testWidgets('StudentProfileScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const StudentProfileScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Test Student'), findsOneWidget);
  });

  testWidgets('MyApplicationsScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const MyApplicationsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('My Applications'), findsOneWidget);
  });

  testWidgets('NotificationsScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const NotificationsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsOneWidget);
  });

  testWidgets('OpportunityDetailsScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const OpportunityDetailsScreen(opportunityId: 'opp123')));
    await tester.pumpAndSettle();
    expect(find.text('Opportunity Details'), findsOneWidget);
  });

  testWidgets('StartupProfileReadOnlyScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const StartupProfileReadOnlyScreen(startupId: 'startup123')));
    await tester.pumpAndSettle();
    expect(find.text('Startup Profile'), findsOneWidget);
  });

  testWidgets('ApplicationTrackingScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const ApplicationTrackingScreen(applicationId: 'app123')));
    await tester.pumpAndSettle();
    expect(find.text('Application Tracking'), findsOneWidget);
  });

  testWidgets('ChatScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const ChatScreen(roomId: 'room123')));
    await tester.pumpAndSettle();
    expect(find.text('Test Startup'), findsOneWidget);
  });

  testWidgets('ChatInboxScreen renders without layout crashes', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(const ChatInboxScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Messages'), findsOneWidget);
  });
}

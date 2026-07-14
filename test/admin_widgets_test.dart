import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alu_launch/features/startup/models/startup.dart';
import 'package:alu_launch/features/startup/providers/startup_upload_controllers.dart';
import 'package:alu_launch/features/admin/presentation/screens/startup_verification_approval_screen.dart';

void main() {
  final mockStartup = Startup(
    id: 'startup123',
    ownerId: 'founder123',
    name: 'Innovative Tech Corp',
    industry: 'Technology',
    description: 'We build awesome Flutter apps and backends.',
    location: 'Kigali, Rwanda',
    email: 'contact@innovativetech.com',
    phone: '+250788888888',
    website: 'https://innovativetech.com',
    verificationDocPath: 'startups/startup123/document.pdf',
    createdAt: DateTime.now(),
  );

  Widget buildTestableWidget({
    required List<Startup> startups,
    required String signedUrl,
  }) {
    return ProviderScope(
      overrides: [
        unverifiedStartupsStreamProvider.overrideWith((ref) => Stream.value(startups)),
        verificationDocSignedUrlProvider(mockStartup.verificationDocPath!).overrideWith(
          (ref) => Future.value(signedUrl),
        ),
      ],
      child: const MaterialApp(
        home: StartupVerificationApprovalScreen(),
      ),
    );
  }

  testWidgets('StartupVerificationApprovalScreen renders and expands/interacts correctly', (WidgetTester tester) async {
    // 1. Render screen with loading/mock unverified startup list
    await tester.pumpWidget(buildTestableWidget(
      startups: [mockStartup],
      signedUrl: 'https://supabase.co/storage/v1/object/sign/verification-docs/doc.pdf',
    ));
    await tester.pumpAndSettle();

    // Verify card content renders (collapsed state)
    expect(find.text('Innovative Tech Corp'), findsOneWidget);
    expect(find.text('Technology • Kigali, Rwanda'), findsOneWidget);
    
    // Buttons inside children should NOT be visible yet since ExpansionTile is collapsed
    expect(find.text('Reject'), findsNothing);
    expect(find.text('Verify Startup'), findsNothing);

    // 2. Tap to expand ExpansionTile
    await tester.tap(find.text('Innovative Tech Corp'));
    await tester.pumpAndSettle();

    // Expanded details should now be visible
    expect(find.text('About Startup:'), findsOneWidget);
    expect(find.text('We build awesome Flutter apps and backends.'), findsOneWidget);
    expect(find.text('Founder Email'), findsOneWidget);
    expect(find.text('contact@innovativetech.com'), findsOneWidget);
    expect(find.text('Verification_Document.pdf'), findsOneWidget);

    // Buttons inside children should now be fully interactive
    expect(find.text('Open PDF'), findsOneWidget);
    expect(find.text('Reject'), findsOneWidget);
    expect(find.text('Verify Startup'), findsOneWidget);

    // 3. Tap "Reject" button - should trigger dialog
    await tester.tap(find.text('Reject'));
    await tester.pumpAndSettle();

    // Verify reject dialog opens
    expect(find.text('Reject Verification?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    
    // Dismiss reject dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // 4. Tap "Verify Startup" button - should trigger dialog
    await tester.tap(find.text('Verify Startup'));
    await tester.pumpAndSettle();

    // Verify approval dialog opens
    expect(find.text('Verify Startup?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    
    // Dismiss approval dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });

  testWidgets('StartupVerificationApprovalScreen renders empty state when no pending verifications exist', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(
      startups: [],
      signedUrl: '',
    ));
    await tester.pumpAndSettle();

    // Verify empty state components render correctly
    expect(find.text('No pending verifications'), findsOneWidget);
    expect(find.text('All submitted startup registration documents have been reviewed.'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/firestore_paths.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import '../../features/authentication/presentation/screens/onboarding_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/complete_google_registration_screen.dart';
import '../../features/authentication/repositories/auth_repository.dart';
import '../../features/authentication/providers/auth_providers.dart';

// Import newly created feature screens
import '../../features/student/presentation/screens/student_home_screen.dart';
import '../../features/student/presentation/screens/student_explore_screen.dart';
import '../../features/student/presentation/screens/student_profile_screen.dart';
import '../../features/student/presentation/screens/student_bookmarks_screen.dart';
import '../../features/internships/presentation/screens/opportunity_details_screen.dart';
import '../../features/startup/presentation/screens/startup_profile_read_only_screen.dart';
import '../../features/applications/presentation/screens/my_applications_screen.dart';
import '../../features/applications/presentation/screens/application_tracking_screen.dart';
import '../../features/startup/presentation/screens/startup_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/startup/presentation/screens/startup_profile_edit_screen.dart';
import '../../features/startup/presentation/screens/create_opportunity_screen.dart';
import '../../features/startup/presentation/screens/manage_opportunities_screen.dart';
import '../../features/startup/presentation/screens/applicants_management_screen.dart';
import '../../features/startup/presentation/screens/applicant_details_screen.dart';
import '../../features/startup/presentation/screens/startup_verification_screen.dart';
import '../../features/admin/presentation/screens/startup_verification_approval_screen.dart';
import '../../features/admin/presentation/screens/opportunity_approval_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/messages/presentation/screens/chat_inbox_screen.dart';
import '../../features/messages/presentation/screens/chat_screen.dart';

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(firebaseAuthStateProvider, (_, __) => notifyListeners());
    ref.listen(currentUserProvider, (_, __) => notifyListeners());
  }
}

String _homeRouteForRole(UserRole role) {
  switch (role) {
    case UserRole.student:
      return '/student/home';
    case UserRole.startupFounder:
      return '/startup/dashboard';
    case UserRole.admin:
      return '/admin/dashboard';
  }
}

class StudentMainLayout extends StatefulWidget {
  const StudentMainLayout({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<StudentMainLayout> createState() => _StudentMainLayoutState();
}

class _StudentMainLayoutState extends State<StudentMainLayout> {
  bool _ignorePointers = false;

  void _onDestinationSelected(int index) {
    if (_ignorePointers) return;
    setState(() => _ignorePointers = true);
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _ignorePointers = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IgnorePointer(
        ignoring: _ignorePointers,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: IgnorePointer(
        ignoring: _ignorePointers,
        child: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.send_outlined),
              selectedIcon: Icon(Icons.send),
              label: 'Applications',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final firebaseUserAsync = ref.read(firebaseAuthStateProvider);
      final userAsync = ref.read(currentUserProvider);

      final onAuthScreens = loc == '/login' ||
          loc == '/register' ||
          loc == '/forgot-password' ||
          loc == '/register/complete-google';
      final onSplashOrOnboarding = loc == '/splash' || loc == '/onboarding';

      if (firebaseUserAsync.isLoading) {
        return loc == '/splash' ? null : '/splash';
      }

      final firebaseUser = firebaseUserAsync.valueOrNull;

      // Fully signed out.
      if (firebaseUser == null) {
        if (onSplashOrOnboarding || onAuthScreens) return null;
        return '/login';
      }

      if (userAsync.isLoading) {
        return loc == '/splash' ? null : '/splash';
      }

      final appUser = userAsync.valueOrNull;

      if (appUser == null) {
        if (loc == '/register/complete-google') return null;
        return loc == '/splash' ? null : '/splash';
      }

      // Role-based route gating guards
      if (loc.startsWith('/admin') && appUser.role != UserRole.admin) {
        return _homeRouteForRole(appUser.role);
      }
      if (loc.startsWith('/student') && appUser.role != UserRole.student) {
        return _homeRouteForRole(appUser.role);
      }
      if (loc.startsWith('/startup') && appUser.role != UserRole.startupFounder) {
        return _homeRouteForRole(appUser.role);
      }

      if (onSplashOrOnboarding || onAuthScreens) {
        return _homeRouteForRole(appUser.role);
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(
          path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/messages', builder: (_, __) => const ChatInboxScreen()),
      GoRoute(
        path: '/messages/:roomId',
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return ChatScreen(roomId: roomId);
        },
      ),
      GoRoute(
          path: '/forgot-password',
          builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(
        path: '/register/complete-google',
        builder: (context, state) {
          final pendingUser = state.extra as NeedsRoleSelectionException;
          return CompleteGoogleRegistrationScreen(pendingUser: pendingUser);
        },
      ),

      // Stateful shell routing for student dashboard tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return StudentMainLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/home',
                builder: (context, state) => const StudentHomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/explore',
                builder: (context, state) => const StudentExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/applications',
                builder: (context, state) => const MyApplicationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/profile',
                builder: (context, state) => const StudentProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Student sub-routes
      GoRoute(
        path: '/student/bookmarks',
        builder: (context, state) => const StudentBookmarksScreen(),
      ),
      GoRoute(
        path: '/student/opportunity/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OpportunityDetailsScreen(opportunityId: id);
        },
      ),
      GoRoute(
        path: '/student/startup/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StartupProfileReadOnlyScreen(startupId: id);
        },
      ),
      GoRoute(
        path: '/student/application-tracking/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ApplicationTrackingScreen(applicationId: id);
        },
      ),

      // Startup Founder Routes
      GoRoute(
        path: '/startup/dashboard',
        builder: (_, __) => const StartupDashboardScreen(),
      ),
      GoRoute(
        path: '/startup/profile-edit',
        builder: (_, __) => const StartupProfileEditScreen(),
      ),
      GoRoute(
        path: '/startup/opportunities',
        builder: (_, __) => const ManageOpportunitiesScreen(),
      ),
      GoRoute(
        path: '/startup/opportunities/create',
        builder: (_, __) => const CreateOpportunityScreen(),
      ),
      GoRoute(
        path: '/startup/opportunities/edit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CreateOpportunityScreen(opportunityId: id);
        },
      ),
      GoRoute(
        path: '/startup/applicants',
        builder: (_, __) => const ApplicantsManagementScreen(),
      ),
      GoRoute(
        path: '/startup/applicant/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ApplicantDetailsScreen(applicationId: id);
        },
      ),
      GoRoute(
        path: '/startup/verification',
        builder: (_, __) => const StartupVerificationScreen(),
      ),

      // Admin Routes
      GoRoute(
        path: '/admin/dashboard',
        builder: (_, __) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/verifications',
        builder: (_, __) => const StartupVerificationApprovalScreen(),
      ),
      GoRoute(
        path: '/admin/approvals',
        builder: (_, __) => const OpportunityApprovalScreen(),
      ),
    ],
  );
});

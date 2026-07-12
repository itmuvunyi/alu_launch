import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firestore_paths.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Raw Firebase auth state (signed in / not). This is what the router's
/// refresh listener watches.
final firebaseAuthStateProvider = StreamProvider<fb_auth.User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// The full app-level profile (role, verification, etc.) for whoever's
/// currently signed in. This is the provider the rest of the app should
/// read from — never read `firebaseAuthStateProvider` directly outside of
/// the auth feature and the router.
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final firebaseUser = ref.watch(firebaseAuthStateProvider).valueOrNull;
  if (firebaseUser == null) return Stream.value(null);
  return ref.watch(authRepositoryProvider).watchUserProfile(firebaseUser.uid);
});

/// Convenience: throws if accessed while signed out — use only in places
/// that are already role-gated (e.g. inside `/student/*` routes) where a
/// null user would mean a routing bug, not a valid state.
final requireCurrentUserProvider = Provider<AppUser>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) {
    throw StateError(
      'requireCurrentUserProvider read while signed out — this indicates '
      'a route that should be auth-gated was reached without a session.',
    );
  }
  return user;
});

/// Auth actions with loading/error state for screens to react to via
/// `ref.watch(authControllerProvider)` (AsyncLoading -> show spinner,
/// AsyncError -> show the message, AsyncData -> success/idle).
class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.signInWithEmail(email: email, password: password),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      ),
    );
  }

  /// Returns normally on success. Rethrows [NeedsRoleSelectionException] so
  /// the UI can show a role picker — this is NOT an error state, so it's
  /// deliberately rethrown rather than captured into [state].
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await _repo.signInWithGoogle();
      state = const AsyncData(null);
    } on NeedsRoleSelectionException {
      state = const AsyncData(null);
      rethrow;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> completeGoogleRegistration({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
    required UserRole role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.completeGoogleRegistration(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        role: role,
      ),
    );
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.sendPasswordResetEmail(email));
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signOut());
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);
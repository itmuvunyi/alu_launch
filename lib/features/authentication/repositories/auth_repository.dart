import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/firestore_paths.dart';
import '../models/app_user.dart';

/// User-facing auth errors — messages are safe to show directly in a
/// SnackBar/dialog, mapped from raw FirebaseAuthException codes.
class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Thrown when a Google sign-in belongs to a brand-new user who hasn't
/// picked a role yet. The UI (RegisterScreen / a role-picker sheet) should
/// catch this specifically and call `completeGoogleRegistration`.
class NeedsRoleSelectionException implements Exception {
  NeedsRoleSelectionException({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
}

class AuthRepository {
  AuthRepository({
    fb_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? fb_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final fb_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  Stream<fb_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  fb_auth.User? get currentFirebaseUser => _firebaseAuth.currentUser;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(FirestoreCollections.users);

  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromJson({...doc.data()!, 'uid': doc.id});
  }

  /// Live profile stream — used by `currentUserProvider` so role changes
  /// (e.g. an admin verifying the account) reflect immediately app-wide.
  Stream<AppUser?> watchUserProfile(String uid) {
    return _usersRef.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromJson({...doc.data()!, 'uid': doc.id});
    });
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final profile = await getUserProfile(credential.user!.uid);
      if (profile == null) {
        throw AuthException(
          'No profile found for this account. Please contact support.',
        );
      }
      return profile;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    }
  }

  /// Rule constraint: this repository intentionally has no "admin" branch —
  /// admins are provisioned directly in Firestore/Console by an existing
  /// admin, never through self-registration (matches "ALU Administrator"
  /// having full moderation authority — that trust level isn't self-granted).
  Future<AppUser> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    if (role == UserRole.admin) {
      throw AuthException('Admin accounts cannot be self-registered.');
    }
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);

      final user = AppUser(
        uid: credential.user!.uid,
        email: email.trim(),
        role: role,
        displayName: displayName,
        isVerified: false,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await _usersRef.doc(user.uid).set(user.toJson());
      return user;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    }
  }

  /// Signs in with Google. On a brand-new account, throws
  /// [NeedsRoleSelectionException] instead of returning — the caller must
  /// then collect a role and call [completeGoogleRegistration].
  Future<AppUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Google sign-in was cancelled.');
      }
      final googleAuth = await googleUser.authentication;
      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final uid = userCredential.user!.uid;

      final existing = await getUserProfile(uid);
      if (existing != null) return existing;

      throw NeedsRoleSelectionException(
        uid: uid,
        email: userCredential.user!.email ?? '',
        displayName:
            userCredential.user!.displayName ?? googleUser.displayName ?? '',
        photoUrl: userCredential.user!.photoURL,
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    }
  }

  Future<AppUser> completeGoogleRegistration({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
    required UserRole role,
  }) async {
    if (role == UserRole.admin) {
      throw AuthException('Admin accounts cannot be self-registered.');
    }
    final user = AppUser(
      uid: uid,
      email: email,
      role: role,
      displayName: displayName,
      photoUrl: photoUrl,
      isVerified: false,
      isActive: true,
      createdAt: DateTime.now(),
    );
    await _usersRef.doc(uid).set(user.toJson());
    return user;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  String _mapFirebaseError(fb_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'weak-password':
        return 'Password is too weak — use at least 6 characters.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network error — check your connection and try again.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// The current signed-in user's uid, or null if signed out.
/// (Authentication)
/// will replace/extend this with a full `authStateProvider` exposing the
/// complete user model (role, verification status, etc.) from Firestore —
/// this uid stream will likely become an implementation detail of that
/// larger provider rather than being used directly. Kept here, isolated,
/// so that upgrade doesn't ripple through the storage feature.
final currentUserIdProvider = StreamProvider<String?>((ref) {
  return ref
      .watch(firebaseAuthProvider)
      .authStateChanges()
      .map((user) => user?.uid);
});

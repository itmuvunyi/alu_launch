import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/providers/firebase_providers.dart';
import '../models/startup.dart';
import '../repositories/startup_repository.dart';

final startupRepositoryProvider = Provider<StartupRepository>((ref) {
  return StartupRepository();
});

final startupDetailsProvider = FutureProvider.family<Startup?, String>((ref, id) {
  return ref.watch(startupRepositoryProvider).getStartupById(id);
});

final startupDetailsStreamProvider = StreamProvider.family<Startup?, String>((ref, id) {
  return ref.watch(startupRepositoryProvider).watchStartupById(id);
});

final currentFounderStartupStreamProvider = StreamProvider<Startup?>((ref) {
  final userId = ref.watch(currentUserIdProvider).valueOrNull;
  if (userId == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection(FirestoreCollections.startups)
      .where('ownerId', isEqualTo: userId)
      .limit(1)
      .snapshots()
      .map((snap) {
    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    return Startup.fromJson({...doc.data(), 'id': doc.id});
  });
});

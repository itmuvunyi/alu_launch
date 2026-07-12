import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../core/constants/firestore_paths.dart';
import '../../../core/providers/file_upload_controller.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/file_validators.dart';

/// Student avatar upload → persists to `users/{uid}.avatarUrl`.
final avatarUploadControllerProvider =
    AsyncNotifierProvider.autoDispose<AvatarUploadController, String?>(
  AvatarUploadController.new,
);

class AvatarUploadController extends FileUploadController {
  @override
  StorageBucket get bucket => StorageBucket.profilePictures;

  @override
  FileValidationConfig get validationConfig => FileValidationConfig.avatar;

  @override
  String buildPath(String fileName) {
    final uid = ref.read(currentUserIdProvider).value;
    if (uid == null) {
      throw StateError('Cannot upload avatar: no signed-in user.');
    }
    // Fixed filename (not the original) so re-uploads overwrite in place via
    // upsert, instead of accumulating old avatars in the bucket forever.
    return '$uid/avatar${p.extension(fileName)}';
  }

  @override
  Future<void> persistUrl(String url) async {
    final uid = ref.read(currentUserIdProvider).value;
    if (uid == null) return;
    await ref
        .read(firestoreProvider)
        .collection(FirestoreCollections.users)
        .doc(uid)
        .set({'photoUrl': url}, SetOptions(merge: true));
  }
}

/// Student resume upload → persists to `users/{uid}.resumeUrl`.
final resumeUploadControllerProvider =
    AsyncNotifierProvider.autoDispose<ResumeUploadController, String?>(
  ResumeUploadController.new,
);

class ResumeUploadController extends FileUploadController {
  @override
  StorageBucket get bucket => StorageBucket.resumes;

  @override
  FileValidationConfig get validationConfig => FileValidationConfig.resume;

  @override
  String buildPath(String fileName) {
    final uid = ref.read(currentUserIdProvider).value;
    if (uid == null) {
      throw StateError('Cannot upload resume: no signed-in user.');
    }
    return '$uid/resume${p.extension(fileName)}';
  }

  @override
  Future<void> persistUrl(String url) async {
    final uid = ref.read(currentUserIdProvider).value;
    if (uid == null) return;
    await ref
        .read(firestoreProvider)
        .collection(FirestoreCollections.users)
        .doc(uid)
        .set({'resumeUrl': url}, SetOptions(merge: true));
  }
}

/// Student portfolio upload → appended to `users/{uid}.portfolioUrls`
/// (an array — a student can have multiple portfolio pieces, matching the
/// "Portfolio Projects" section shown on the profile screen in the prototype).
final portfolioUploadControllerProvider =
    AsyncNotifierProvider.autoDispose<PortfolioUploadController, String?>(
  PortfolioUploadController.new,
);

class PortfolioUploadController extends FileUploadController {
  @override
  StorageBucket get bucket => StorageBucket.portfolios;

  @override
  FileValidationConfig get validationConfig => FileValidationConfig.portfolio;

  @override
  String buildPath(String fileName) {
    final uid = ref.read(currentUserIdProvider).value;
    if (uid == null) {
      throw StateError('Cannot upload portfolio file: no signed-in user.');
    }
    // Timestamped (not fixed) — unlike avatar/resume, portfolio items are
    // additive: each upload needs a distinct path rather than overwriting
    // the previous one.
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$uid/$timestamp${p.extension(fileName)}';
  }

  @override
  Future<void> persistUrl(String url) async {
    final uid = ref.read(currentUserIdProvider).value;
    if (uid == null) return;
    await ref
        .read(firestoreProvider)
        .collection(FirestoreCollections.users)
        .doc(uid)
        .set({
      'portfolioUrls': FieldValue.arrayUnion([url]),
    }, SetOptions(merge: true));
  }
}

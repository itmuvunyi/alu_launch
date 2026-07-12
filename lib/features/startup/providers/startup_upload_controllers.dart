import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../core/constants/firestore_paths.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/storage_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/file_validators.dart';

/// Startup logo upload → persists to `startups/{startupId}.logoUrl`.
///
/// Scoped by [startupId] (a `.family` provider), unlike the student
/// controllers, since which startup is being edited isn't implicit from
/// "the current user" the way a student's own avatar is.
final startupLogoUploadControllerProvider = AsyncNotifierProvider.autoDispose
    .family<StartupLogoUploadController, String?, String>(
  StartupLogoUploadController.new,
);

class StartupLogoUploadController
    extends AutoDisposeFamilyAsyncNotifier<String?, String> {
  @override
  String? build(String startupId) => null;

  String get _startupId => arg;

  Future<void> upload({
    required Uint8List bytes,
    required String contentType,
    required String fileName,
  }) async {
    state = const AsyncLoading();
    try {
      FileValidator.validate(
        bytes: bytes,
        contentType: contentType,
        config: FileValidationConfig.startupLogo,
      );

      final storage = ref.read(storageServiceProvider);
      final url = await storage.uploadFile(
        bucket: StorageBucket.startupLogos,
        path: '$_startupId/logo${p.extension(fileName)}',
        bytes: bytes,
        contentType: contentType,
      );

      await ref
          .read(firestoreProvider)
          .collection(FirestoreCollections.startups)
          .doc(_startupId)
          .set({'logoUrl': url}, SetOptions(merge: true));

      state = AsyncData(url);
    } on FileValidationException catch (e, st) {
      state = AsyncError(e, st);
    } on StorageException catch (e, st) {
      state = AsyncError(e, st);
    } catch (e, st) {
      state = AsyncError(
        const StorageException('Something went wrong. Please try again.'),
        st,
      );
    }
  }
}

/// Startup verification document upload.
///
/// Unlike every other upload in the app, `verification-docs` is a PRIVATE
/// bucket (only the owning founder + admins should ever see legal/business
/// documents). So this controller persists the storage PATH — not a public
/// URL — to `startups/{startupId}.verificationDocPath`, and a separate
/// provider ([verificationDocSignedUrlProvider] below) resolves a
/// time-limited signed URL on demand whenever the document actually needs
/// to be displayed (e.g. an admin opening the Startup Verification screen).
final verificationDocUploadControllerProvider = AsyncNotifierProvider
    .autoDispose.family<VerificationDocUploadController, String?, String>(
  VerificationDocUploadController.new,
);

class VerificationDocUploadController
    extends AutoDisposeFamilyAsyncNotifier<String?, String> {
  @override
  String? build(String startupId) => null;

  String get _startupId => arg;

  Future<void> upload({
    required Uint8List bytes,
    required String contentType,
    required String fileName,
  }) async {
    state = const AsyncLoading();
    try {
      FileValidator.validate(
        bytes: bytes,
        contentType: contentType,
        config: FileValidationConfig.verificationDoc,
      );

      final storage = ref.read(storageServiceProvider);
      final path = '$_startupId/${DateTime.now().millisecondsSinceEpoch}'
          '${p.extension(fileName)}';

      // uploadFile still returns a URL (getPublicUrl on a private bucket
      // resolves but won't actually be fetchable) — we deliberately discard
      // it here and store the PATH instead, since that's what
      // createSignedUrl needs later, not the unusable "public" URL.
      await storage.uploadFile(
        bucket: StorageBucket.verificationDocs,
        path: path,
        bytes: bytes,
        contentType: contentType,
      );

      await ref
          .read(firestoreProvider)
          .collection(FirestoreCollections.startups)
          .doc(_startupId)
          .set({'verificationDocPath': path}, SetOptions(merge: true));

      state = AsyncData(path);
    } on FileValidationException catch (e, st) {
      state = AsyncError(e, st);
    } on StorageException catch (e, st) {
      state = AsyncError(e, st);
    } catch (e, st) {
      state = AsyncError(
        const StorageException('Something went wrong. Please try again.'),
        st,
      );
    }
  }
}

/// Resolves a fresh signed URL for an already-uploaded verification doc.
/// Call this (e.g. in the Admin Startup Verification screen) whenever the
/// document needs to be shown/downloaded — signed URLs expire, so this is
/// NOT something to cache long-term in Firestore.
final verificationDocSignedUrlProvider =
    FutureProvider.autoDispose.family<String, String>((ref, storagePath) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getSignedUrl(
    bucket: StorageBucket.verificationDocs,
    path: storagePath,
  );
});

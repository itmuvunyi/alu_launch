import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage_service.dart';
import '../utils/file_validators.dart';
import 'storage_providers.dart';

/// State is `AsyncValue<String?>`:
/// - [AsyncLoading] while validating/uploading — UI shows a spinner/progress bar
/// - [AsyncData] holding the resulting URL on success (or the previously
///   persisted URL at rest, if I seed it — most screens just watch this
///   for the "in-flight upload" case and read the persisted URL from the
///   parent Firestore document otherwise)
/// - [AsyncError] holding a [FileValidationException] (bad file) or
///   [StorageException] (network/provider failure) — UI can check the
///   error's runtime type to show a specific message
///
/// Subclasses only need to say WHERE the file goes (bucket + path + config)
/// and WHAT to do with the resulting URL (persist to Firestore).
abstract class FileUploadController extends AutoDisposeAsyncNotifier<String?> {
  StorageBucket get bucket;
  FileValidationConfig get validationConfig;

  String buildPath(String fileName);
  Future<void> persistUrl(String url);

  @override
  String? build() => null;

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
        config: validationConfig,
      );

      final storage = ref.read(storageServiceProvider);
      final url = await storage.uploadFile(
        bucket: bucket,
        path: buildPath(fileName),
        bytes: bytes,
        contentType: contentType,
      );

      await persistUrl(url);

      state = AsyncData(url);
    } on FileValidationException catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    } on StorageException catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    } catch (e, st) {
      state = AsyncError(
        const StorageException('Something went wrong. Please try again.'),
        st,
      );
      rethrow;
    }
  }
}

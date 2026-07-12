import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart' hide StorageException;

import 'storage_service.dart';



/// Supabase Storage implementation of [IStorageService].
///
/// Buckets are PUBLIC — uploads return a permanent public URL that's safe to
/// store directly in a Firestore document field (e.g. `resumeUrl`) and reuse
/// indefinitely, since it never expires (unlike a signed URL)

class SupabaseStorageService implements IStorageService {
  SupabaseStorageService(this._client);

  final SupabaseClient _client;

  @override
  Future<String> uploadFile({
    required StorageBucket bucket,
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    try {
      await _client.storage.from(bucket.bucketName).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType,
              upsert: true, // overwrite in place (e.g. avatar replacement)
            ),
          );

      return _client.storage.from(bucket.bucketName).getPublicUrl(path);
    } catch (e) {
      throw StorageException('Failed to upload file. Please try again.', e);
    }
  }

  @override
  Future<void> deleteFile({
    required StorageBucket bucket,
    required String path,
  }) async {
    try {
      await _client.storage.from(bucket.bucketName).remove([path]);
    } catch (e) {
      // Rethrown (not swallowed) so the caller can decide whether an orphaned
      // old file is worth surfacing to the user — e.g. an avatar-replace flow
      // may choose to ignore this and proceed, since the upload of the new
      // file already succeeded by the time delete runs.
      throw StorageException('Failed to delete previous file.', e);
    }
  }

  @override
  Future<String> getSignedUrl({
    required StorageBucket bucket,
    required String path,
    Duration expiresIn = const Duration(hours: 1),
  }) async {
    try {
      return await _client.storage
          .from(bucket.bucketName)
          .createSignedUrl(path, expiresIn.inSeconds);
    } catch (e) {
      throw StorageException('Failed to generate file link.', e);
    }
  }
}

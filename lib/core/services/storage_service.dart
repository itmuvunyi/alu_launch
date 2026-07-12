import 'dart:typed_data';

enum StorageBucket {
  profilePictures,
  startupLogos,
  resumes,
  portfolios,
  verificationDocs;

  String get bucketName => switch (this) {
        StorageBucket.profilePictures => 'profile-pictures',
        StorageBucket.startupLogos => 'startup-logos',
        StorageBucket.resumes => 'resumes',
        StorageBucket.portfolios => 'portfolios',
        StorageBucket.verificationDocs => 'verification-docs',
      };
}

abstract class IStorageService {
  /// Uploads bytes to [bucket] under [path] (e.g. `'{uid}/avatar.jpg'`).
  /// Returns a URL the app can use to display/download the file.
  Future<String> uploadFile({
    required StorageBucket bucket,
    required String path,
    required Uint8List bytes,
    required String contentType,
  });

  /// Deletes a file at [path] within [bucket]. Used when a user replaces
  /// their avatar/resume, to avoid orphaned files piling up in the bucket.
  Future<void> deleteFile({
    required StorageBucket bucket,
    required String path,
  });

  Future<String> getSignedUrl({
    required StorageBucket bucket,
    required String path,
    Duration expiresIn = const Duration(hours: 1),
  });
}

/// Thrown when an upload/delete/signed-URL request fails at the network
/// or provider level (as opposed to failing client-side validation)
class StorageException implements Exception {
  const StorageException(this.message, [this.cause]);
  final String message;
  final Object? cause;

  @override
  String toString() => cause == null ? message : '$message ($cause)';
}

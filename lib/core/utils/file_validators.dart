import 'dart:typed_data';

class FileValidationException implements Exception {
  const FileValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}

class FileValidationConfig {
  const FileValidationConfig({
    required this.maxSizeBytes,
    required this.allowedContentTypes,
    required this.friendlyTypeDescription,
  });

  final int maxSizeBytes;
  final Set<String> allowedContentTypes;
  final String friendlyTypeDescription;

  static const avatar = FileValidationConfig(
    maxSizeBytes: 5 * 1024 * 1024, // 5MB
    allowedContentTypes: {'image/jpeg', 'image/png', 'image/webp'},
    friendlyTypeDescription: 'JPEG, PNG, or WEBP image up to 5MB',
  );

  static const startupLogo = avatar; // same constraints

  static const resume = FileValidationConfig(
    maxSizeBytes: 10 * 1024 * 1024, // 10MB
    allowedContentTypes: {'application/pdf'},
    friendlyTypeDescription: 'PDF up to 10MB',
  );

  static const portfolio = FileValidationConfig(
    maxSizeBytes: 20 * 1024 * 1024, // 20MB
    allowedContentTypes: {
      'application/pdf',
      'image/jpeg',
      'image/png',
      'image/webp',
    },
    friendlyTypeDescription: 'PDF or image up to 20MB',
  );

  static const verificationDoc = FileValidationConfig(
    maxSizeBytes: 10 * 1024 * 1024, // 10MB
    allowedContentTypes: {'application/pdf', 'image/jpeg', 'image/png'},
    friendlyTypeDescription: 'PDF or image up to 10MB',
  );
}

class FileValidator {
  FileValidator._();

  /// Throws [FileValidationException] if [bytes]/[contentType] don't satisfy
  /// [config]. Call this before any upload attempt.
  static void validate({
    required Uint8List bytes,
    required String contentType,
    required FileValidationConfig config,
  }) {
    if (bytes.isEmpty) {
      throw const FileValidationException('The selected file is empty.');
    }

    if (bytes.length > config.maxSizeBytes) {
      final maxMb = (config.maxSizeBytes / (1024 * 1024)).toStringAsFixed(0);
      throw FileValidationException(
        'File is too large. Maximum allowed size is ${maxMb}MB.',
      );
    }

    if (!config.allowedContentTypes.contains(contentType)) {
      throw FileValidationException(
        'Unsupported file type. Please upload a ${config.friendlyTypeDescription}.',
      );
    }
  }
}

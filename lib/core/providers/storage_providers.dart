import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

import '../config/supabase_config.dart';
import '../services/storage_service.dart';
import '../services/supabase_storage_service.dart';

/// The raw Supabase client. Exposed at the core level only — feature code
/// should depend on [storageServiceProvider] below, never reach for this
/// directly, to keep Supabase an implementation detail.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  if (!SupabaseConfig.isConfigured) {
    throw StateError('Supabase client accessed but not configured. Ensure SupabaseConfig.isConfigured is true before accessing.');
  }
  return supabaseClient; // from supabase_config.dart, initialized in main()
});

/// Placeholder storage service used when Supabase is not configured.
class PlaceholderStorageService implements IStorageService {
  const PlaceholderStorageService();

  @override
  Future<String> uploadFile({
    required StorageBucket bucket,
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    // TODO: Connect real Supabase Storage upload when keys are configured
    print('PlaceholderStorageService: Simulating upload of ${bytes.length} bytes to ${bucket.bucketName}/$path');
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network latency
    return 'https://raw.githubusercontent.com/itmuvunyi/flutter-expansiontile-demo/main/placeholder.png'; // standard fallback
  }

  @override
  Future<void> deleteFile({
    required StorageBucket bucket,
    required String path,
  }) async {
    print('PlaceholderStorageService: Simulating delete of ${bucket.bucketName}/$path');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<String> getSignedUrl({
    required StorageBucket bucket,
    required String path,
    Duration expiresIn = const Duration(hours: 1),
  }) async {
    return 'https://raw.githubusercontent.com/itmuvunyi/flutter-expansiontile-demo/main/placeholder.png';
  }
}

/// The app-wide storage service. Typed as [IStorageService] (the interface),
/// not [SupabaseStorageService] (the implementation).
final storageServiceProvider = Provider<IStorageService>((ref) {
  if (SupabaseConfig.isConfigured) {
    return SupabaseStorageService(ref.watch(supabaseClientProvider));
  } else {
    return const PlaceholderStorageService();
  }
});

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase is used ONLY for Storage (avatars, resumes, portfolios,
/// verification docs). Auth and the database remain 100% Firebase — this
/// project intentionally does not use Supabase Auth or Supabase's Postgres DB.

class SupabaseConfig {
  SupabaseConfig._();

  static String get url => dotenv.env['SUPABASE_URL'] ?? '';

  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static bool get isConfigured =>
      url.isNotEmpty &&
      anonKey.isNotEmpty &&
      !url.contains('YOUR-PROJECT-REF') &&
      !anonKey.contains('YOUR-ANON-PUBLIC-KEY');

  static Future<void> initialize() async {
    if (!isConfigured) {
      print('WARNING: Supabase URL or Anon Key is not set. Storage uploads will use fallback placeholders.');
      return;
    }
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}

/// Convenience accessor for the initialized client.
SupabaseClient get supabaseClient => Supabase.instance.client;

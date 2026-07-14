import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/config/supabase_config.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // Falls back gracefully if .env is missing
    debugPrint('WARNING: .env file not found or failed to load. Storage will use placeholders.');
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SupabaseConfig.initialize();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const AluLaunchApp(),
    ),
  );
}

class AluLaunchApp extends ConsumerWidget {
  const AluLaunchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'ALU Launch',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
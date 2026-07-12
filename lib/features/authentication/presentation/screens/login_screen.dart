import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../providers/auth_providers.dart';
import '../../repositories/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberDevice = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  Future<void> _submitGoogle() async {
    try {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
    } on NeedsRoleSelectionException catch (e) {
      if (!mounted) return;
      context.push('/register/complete-google', extra: e);
    } catch (_) {}
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Enter a valid email address';
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        ),
      );
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
            vertical: AppSpacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/alu_logo.png',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('ALU Launch',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text(
                  'Bridge to Global Opportunities',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Welcome back', style: theme.textTheme.headlineMedium),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'student@alueducation.com',
                    suffixIcon: Icon(Icons.alternate_email),
                  ),
                  validator: _emailValidator,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: _passwordValidator,
                  onFieldSubmitted: (_) => _submit(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    child: const Text('Forgot password?'),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberDevice,
                      onChanged: (v) =>
                          setState(() => _rememberDevice = v ?? false),
                    ),
                    Text('Remember this device',
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ElevatedButton.icon(
                  onPressed: authState.isLoading ? null : _submit,
                  icon: authState.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.arrow_forward),
                  label: const Text('Login'),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: Text('OR CONTINUE WITH',
                          style: theme.textTheme.labelSmall),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: authState.isLoading ? null : _submitGoogle,
                  icon: const Icon(Icons.g_mobiledata, size: 28),
                  label: const Text('Sign in with Google'),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: theme.textTheme.bodyMedium),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: Text(
                        'Register',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/appwrite_notification_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getErrorMessage(dynamic error) {
    final errorMessage = error.toString().toLowerCase();

    // Invalid credentials
    if (errorMessage.contains('invalid login credentials') ||
        errorMessage.contains('invalid email or password') ||
        errorMessage.contains('email not confirmed')) {
      return 'Email or password is incorrect';
    }

    // Email not confirmed
    if (errorMessage.contains('email not confirmed') ||
        errorMessage.contains('confirm your email')) {
      return 'Please verify your email address';
    }

    // Too many attempts
    if (errorMessage.contains('too many') ||
        errorMessage.contains('rate limit')) {
      return 'Too many login attempts. Please try again later';
    }

    // Network errors
    if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout')) {
      return 'Network connection failed. Please check your internet';
    }

    // User not found
    if (errorMessage.contains('user not found') ||
        errorMessage.contains('no user found')) {
      return 'No account found with this email';
    }

    // Default message
    return 'Login failed. Please try again';
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final session = await ref.read(authRepositoryProvider).signInWithGoogle();

      // Invalidate auth providers to trigger refresh
      ref.invalidate(authStateProvider);
      ref.invalidate(currentUserProvider);

      // Get current user after successful login
      final user = await ref.read(authRepositoryProvider).currentUser;

      // Save push token after successful login
      if (user != null) {
        try {
          final pushToken = await AppwriteNotificationService.instance
              .getToken();
          if (pushToken != null) {
            await ref
                .read(notificationRepositoryProvider)
                .saveFCMToken(
                  userId: user.$id,
                  token: pushToken,
                  deviceType: Platform.isAndroid ? 'android' : 'ios',
                  deviceInfo: {
                    'platform': Platform.operatingSystem,
                    'version': Platform.operatingSystemVersion,
                  },
                );
          }
        } catch (e) {
          // Silent fail for push token
        }
      }

      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        final errorMsg = _getErrorMessage(e);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Details',
              textColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('OAuth Error Details'),
                    content: SingleChildScrollView(
                      child: Text(
                        'Error: $e\n\n'
                        'Please check the console logs for detailed debugging information.',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // Invalidate auth providers to trigger refresh
      ref.invalidate(authStateProvider);
      ref.invalidate(currentUserProvider);

      // Get current user after successful login
      final user = await ref.read(authRepositoryProvider).currentUser;

      // Save push token after successful login
      if (user != null) {
        try {
          final pushToken = await AppwriteNotificationService.instance
              .getToken();
          if (pushToken != null) {
            await ref
                .read(notificationRepositoryProvider)
                .saveFCMToken(
                  userId: user.$id,
                  token: pushToken,
                  deviceType: Platform.isAndroid ? 'android' : 'ios',
                  deviceInfo: {
                    'platform': Platform.operatingSystem,
                    'version': Platform.operatingSystemVersion,
                  },
                );
          }
        } catch (e) {
          // Silent fail for push token
        }
      }

      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        final errorMsg = _getErrorMessage(e);
        // Email verification check removed since verification is disabled
        // final isEmailNotVerified = e.toString().toLowerCase().contains(
        //   'verify',
        // );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 5),
            // Resend verification action removed since verification is disabled
            // action: isEmailNotVerified
            //     ? SnackBarAction(
            //         label: 'Resend',
            //         textColor: Colors.white,
            //         onPressed: () => context.push('/resend-verification'),
            //       )
            //     : null,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Icon(
                  Icons.volunteer_activism,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'HRA-FoDAS',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Food Donation & Distribution',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sign In'),
                ),
                const SizedBox(height: 16),
                // Google Sign-In temporarily disabled due to OAuth configuration issues
                // TODO: Re-enable once Appwrite OAuth is properly configured
                // OutlinedButton.icon(
                //   onPressed: _isLoading ? null : _signInWithGoogle,
                //   icon: Image.network(
                //     'https://www.google.com/favicon.ico',
                //     height: 20,
                //     width: 20,
                //     errorBuilder: (context, error, stackTrace) =>
                //         const Icon(Icons.login, size: 20),
                //   ),
                //   label: const Text('Sign in with Google'),
                //   style: OutlinedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(vertical: 12),
                //   ),
                // ),
                // const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: const Text('Sign Up'),
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

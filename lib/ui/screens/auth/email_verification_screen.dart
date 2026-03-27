import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String userId;
  final String secret;

  const EmailVerificationScreen({
    super.key,
    required this.userId,
    required this.secret,
  });

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _isVerifying = true;
  bool _isSuccess = false;
  String _message = 'Verifying your email...';

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }

  Future<void> _verifyEmail() async {
    try {
      // Verify email with Appwrite
      await ref
          .read(authRepositoryProvider)
          .verifyEmail(userId: widget.userId, secret: widget.secret);

      // Update user profile is_verified field
      await ref
          .read(authRepositoryProvider)
          .updateUserVerificationStatus(
            userId: widget.userId,
            isVerified: true,
          );

      setState(() {
        _isVerifying = false;
        _isSuccess = true;
        _message = 'Email verified successfully!';
      });

      // Navigate to login after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) context.go('/login');
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _isSuccess = false;
        _message = 'Email verification failed. The link may have expired.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isVerifying
                      ? Icons.email_outlined
                      : _isSuccess
                      ? Icons.check_circle_outline
                      : Icons.error_outline,
                  size: 100,
                  color: _isVerifying
                      ? AppTheme.primaryColor
                      : _isSuccess
                      ? Colors.green
                      : AppTheme.errorColor,
                ),
                const SizedBox(height: 32),
                if (_isVerifying)
                  const CircularProgressIndicator()
                else
                  Text(
                    _isSuccess ? '✓' : '✗',
                    style: TextStyle(
                      fontSize: 48,
                      color: _isSuccess ? Colors.green : AppTheme.errorColor,
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  _message,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (!_isVerifying && _isSuccess)
                  Text(
                    'Redirecting to login...',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                if (!_isVerifying && !_isSuccess) ...[
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Go to Login'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

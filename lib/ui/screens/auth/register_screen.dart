import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/enums/enums.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserRole _selectedRole = UserRole.donor;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authRepositoryProvider)
          .signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _nameController.text.trim(),
            role: _selectedRole,
          );

      // Email verification temporarily disabled - user can login immediately
      // Invalidate providers to refresh auth state
      ref.invalidate(authStateProvider);
      ref.invalidate(currentUserProvider);

      if (mounted) {
        // Show success message and navigate to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Account created! You can now sign in.'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 3),
          ),
        );
        context.go('/login');
      }

      // Email verification flow (currently disabled)
      // if (mounted) {
      //   // Show success dialog with resend option
      //   showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (context) => AlertDialog(
      //       icon: const Icon(
      //         Icons.mark_email_read,
      //         size: 60,
      //         color: AppTheme.successColor,
      //       ),
      //       title: const Text('Check Your Email'),
      //       content: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           Text(
      //             'We\'ve sent a verification link to:',
      //             textAlign: TextAlign.center,
      //             style: Theme.of(context).textTheme.bodyMedium,
      //           ),
      //           const SizedBox(height: 8),
      //           Text(
      //             _emailController.text.trim(),
      //             textAlign: TextAlign.center,
      //             style: Theme.of(
      //               context,
      //             ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      //           ),
      //           const SizedBox(height: 16),
      //           Text(
      //             'Please click the link in the email to verify your account before logging in.',
      //             textAlign: TextAlign.center,
      //             style: Theme.of(
      //               context,
      //             ).textTheme.bodySmall?.copyWith(color: Colors.grey),
      //           ),
      //         ],
      //       ),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //             context.push('/resend-verification');
      //           },
      //           child: const Text('Didn\'t receive it?'),
      //         ),
      //         ElevatedButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //             context.go('/login');
      //           },
      //           child: const Text('Go to Login'),
      //         ),
      //       ],
      //     ),
      //   );
      // }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();

      // Invalidate auth providers to trigger refresh
      ref.invalidate(authStateProvider);
      ref.invalidate(currentUserProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Account created successfully!'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 3),
          ),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
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
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                DropdownButtonFormField<UserRole>(
                  initialValue: _selectedRole,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'I want to',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: UserRole.donor,
                      child: Text('Donate Food'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.recipient,
                      child: Text('Receive Donations (Organization)'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.volunteer,
                      child: Text('Volunteer for Deliveries'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _selectedRole = value!),
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
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Account'),
                ),
                const SizedBox(height: 16),
                // Google Sign-In temporarily disabled due to OAuth configuration issues
                // TODO: Re-enable once Appwrite OAuth is properly configured
                // OutlinedButton.icon(
                //   onPressed: _isLoading ? null : _signUpWithGoogle,
                //   icon: Image.network(
                //     'https://www.google.com/favicon.ico',
                //     height: 20,
                //     width: 20,
                //     errorBuilder: (context, error, stackTrace) =>
                //         const Icon(Icons.login, size: 20),
                //   ),
                //   label: const Text('Sign up with Google'),
                //   style: OutlinedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(vertical: 12),
                //   ),
                // ),
                // const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Sign In'),
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

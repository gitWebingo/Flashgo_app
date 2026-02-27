import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final String validEmail = 'info@webingo.in';
  final String validPassword = 'Webingo@12345';

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1500));

      if (_emailController.text == validEmail &&
          _passwordController.text == validPassword) {
        await _saveLoginStatus();
        if (mounted) _navigateToHome();
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid credentials'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          );
        }
      }
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    await _saveLoginStatus();
    if (mounted) _navigateToHome();
  }

  Future<void> _saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Stack(
        children: [
          // Dynamic Background Orbs
          _buildBackgroundOrbs(),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            // Logo Section
                            _buildLogo(),

                            const SizedBox(height: 40),
                            // Header Text
                            _buildHeader(),

                            const SizedBox(height: 50),
                            // Form Section
                            _buildLoginForm(),

                            const SizedBox(height: 40),
                            // Action Buttons
                            _buildActionButtons(),

                            const Spacer(),
                            // Footer
                            _buildFooter(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundOrbs() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withValues(alpha: 0.15),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 3.seconds),
        ),
        Positioned(
          bottom: 100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -20, end: 20, duration: 4.seconds),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: const Icon(
            Icons.bolt_rounded,
            color: Colors.blueAccent,
            size: 64,
          ),
        )
            .animate()
            .scale(duration: 800.ms, curve: Curves.elasticOut)
            .shimmer(delay: 1.seconds),
        const SizedBox(height: 16),
        const Text(
          'FLASHGO',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 4,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Experience the Light',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ).animate().fadeIn(delay: 400.ms).moveY(begin: 10, end: 0),
        const SizedBox(height: 12),
        Text(
          'Login to illuminate your world with premium flash features',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.6),
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _ElegantTextField(
            controller: _emailController,
            hint: 'Email Address',
            icon: Icons.alternate_email_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!value.contains('@')) return 'Enter a valid email';
              return null;
            },
          ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0),
          const SizedBox(height: 20),
          _ElegantTextField(
            controller: _passwordController,
            hint: 'Password',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onToggleVisibility: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Password is required';
              return null;
            },
          ).animate().fadeIn(delay: 700.ms).moveY(begin: 20, end: 0),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF42EADD), Color(0xFF3B82F6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('SIGN IN',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: Colors.white)),
            ),
          ),
        ).animate().fadeIn(delay: 800.ms).scale(),
        const SizedBox(height: 24),
        TextButton(
          onPressed: _isLoading ? null : _handleGuestLogin,
          child: Text(
            'CONTINUE AS GUEST',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ).animate().fadeIn(delay: 900.ms),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          'POWERED BY WEBINGO',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.2),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1.seconds);
  }
}

class _ElegantTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;

  const _ElegantTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onToggleVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            validator: validator,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            cursorColor: Colors.blueAccent,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3), fontSize: 15),
              prefixIcon: Icon(icon,
                  color: Colors.blueAccent.withValues(alpha: 0.6), size: 22),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              errorStyle: const TextStyle(height: 0),
            ),
          ),
        ),
      ),
    );
  }
}

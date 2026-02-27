import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: 800.ms,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Depth orbs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.05),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: -20, end: 20, duration: 3.seconds),
          ),

          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purpleAccent.withOpacity(0.05),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: 20, end: -20, duration: 4.seconds),
          ),

          // Central Logo & Identity
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF42EADD), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Colors.white,
                  size: 70,
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 2.seconds, color: Colors.white30)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.1, 1.1),
                    duration: 1.5.seconds,
                    curve: Curves.easeInOut,
                  ),
              const SizedBox(height: 40),
              const Text(
                'FLASHGO',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 10,
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack),
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF42EADD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().scaleX(delay: 500.ms, duration: 600.ms),
              const SizedBox(height: 16),
              Text(
                'ILLUMINATE EVERYTHING',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.4),
                  letterSpacing: 4,
                ),
              ).animate().fadeIn(delay: 1.seconds),
            ],
          ),

          // Loading bar at bottom
          Positioned(
            bottom: 80,
            child: SizedBox(
              width: 150,
              height: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF42EADD)),
                ),
              ),
            ).animate().fadeIn(delay: 1200.ms),
          ),
        ],
      ),
    );
  }
}

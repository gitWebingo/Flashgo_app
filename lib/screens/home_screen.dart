import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isFlashlightOn = false;
  bool _isStrobeOn = false;
  double _strobeSpeed = 5.0; // Hz
  Timer? _strobeTimer;

  @override
  void dispose() {
    _strobeTimer?.cancel();
    _setTorchState(false);
    super.dispose();
  }

  Future<void> _setTorchState(bool on) async {
    try {
      if (on) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
    } catch (e) {
      if (mounted && (_isFlashlightOn || _isStrobeOn)) {
        _showError('Flashlight not available on this device');
        // Reset UI if hardware fails
        setState(() {
          _isFlashlightOn = false;
          _isStrobeOn = false;
          _strobeTimer?.cancel();
        });
      }
    }
  }

  Future<void> _toggleFlashlight() async {
    setState(() {
      _isFlashlightOn = !_isFlashlightOn;
      if (_isFlashlightOn) {
        _isStrobeOn = false;
        _strobeTimer?.cancel();
        _setTorchState(true);
      } else {
        _setTorchState(false);
      }
    });
  }

  void _toggleStrobe() {
    setState(() {
      _isStrobeOn = !_isStrobeOn;
      if (_isStrobeOn) {
        _isFlashlightOn = false;
        _startStrobe();
      } else {
        _strobeTimer?.cancel();
        _setTorchState(false);
      }
    });
  }

  void _startStrobe() {
    _strobeTimer?.cancel();
    final interval = (1000 / _strobeSpeed).round();

    // Initial state for strobe loop
    bool toggle = true;
    _setTorchState(toggle);

    _strobeTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      if (_isStrobeOn) {
        toggle = !toggle;
        _setTorchState(toggle);
      } else {
        timer.cancel();
        _setTorchState(false);
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Stack(
        children: [
          // Dynamic Background Glow
          _buildBackgroundGlow(),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlow() {
    bool isActive = _isFlashlightOn || _isStrobeOn;
    return AnimatedContainer(
      duration: 1.seconds,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: isActive ? 1.2 : 0.6,
          colors: [
            isActive
                ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                : const Color(0xFF1D1E33).withValues(alpha: 0.3),
            const Color(0xFF0A0E21),
          ],
        ),
      ),
    ).animate(target: isActive ? 1 : 0).shimmer(
        duration: 3.seconds,
        color: isActive
            ? const Color(0xFFFFD700).withValues(alpha: 0.05)
            : Colors.transparent);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
      child: Center(
        child: Column(
          children: [
            Text(
              'FLASHGO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                letterSpacing: 4.0,
                color:
                    const Color(0xFFFFD700).withValues(alpha: 0.9), // Gold text
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700), // Gold underline
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Big Size Light Button
            _buildMainButton(),

            const SizedBox(height: 48),
            // Status Text
            _buildStatusText(),

            const SizedBox(height: 60),
            // Controls Section (Glassmorphic look)
            _buildControlsSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusText() {
    bool isActive = _isFlashlightOn || _isStrobeOn;
    return Column(
      children: [
        Text(
          isActive
              ? (_isStrobeOn ? 'STROBE ACTIVE' : 'LIGHT ON')
              : 'SYSTEM READY',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: isActive ? const Color(0xFFFFD700) : Colors.white24,
          ),
        )
            .animate(target: isActive ? 1 : 0)
            .fadeIn()
            .shimmer(duration: isActive ? 2.seconds : null),
        const SizedBox(height: 8),
        Text(
          isActive ? 'Tap to deactivate' : 'Ready to illuminate',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.3),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildControlsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          _buildModeSelector(),
          if (_isStrobeOn) ...[
            const SizedBox(height: 32),
            _buildStrobeControls(),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0);
  }

  Widget _buildMainButton() {
    bool isActive = _isFlashlightOn || _isStrobeOn;
    return Center(
      child: GestureDetector(
        onTap: _toggleFlashlight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Immersive Light Beams / Glow (The "Big Light")
            if (isActive) ...[
              // Largest outer glow
              Container(
                width: 450,
                height: 450,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFD700).withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat()).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  duration: 3.seconds,
                  curve: Curves.easeInOut),

              // Pulsing rays
              ...List.generate(
                  4,
                  (index) => Transform.rotate(
                        angle: (index * 45) * 3.14 / 180,
                        child: Container(
                          width: 2,
                          height: 500,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xFFFFD700).withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ).animate(onPlay: (c) => c.repeat()).fadeOut(
                          duration: 2.seconds, delay: (index * 200).ms)),
            ],

            // Main central button
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.03),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFFFFD700)
                      : Colors.white.withValues(alpha: 0.1),
                  width: 4,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                          blurRadius: 100,
                          spreadRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isActive
                        ? Icons.bolt_rounded
                        : Icons.power_settings_new_rounded,
                    size: 110,
                    color: isActive
                        ? const Color(0xFFFFD700)
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                  if (isActive)
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Color(0xFFFFD700),
                      ),
                    ).animate().fadeIn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          _buildModeTab(
              'Light', _isFlashlightOn && !_isStrobeOn, _toggleFlashlight),
          _buildModeTab('Strobe', _isStrobeOn, _toggleStrobe),
        ],
      ),
    );
  }

  Widget _buildModeTab(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFFFD700)
                : Colors.transparent, // Active Gold
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: isActive
                  ? Colors.black
                  : Colors.white.withValues(alpha: 0.5), // Black text on Gold
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrobeControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SPEED',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              Text(
                '${_strobeSpeed.toStringAsFixed(1)} Hz',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFFFD700),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
              thumbColor: const Color(0xFFFFD700),
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              overlayColor: const Color(0xFFFFD700).withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _strobeSpeed,
              min: 1,
              max: 20,
              onChanged: (value) {
                setState(() {
                  _strobeSpeed = value;
                  if (_isStrobeOn) {
                    _startStrobe();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

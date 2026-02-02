import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isFlashlightOn = false;
  bool _isScreenLightOn = false;
  bool _isStrobeOn = false;
  Color _selectedColor = Colors.white;
  double _strobeSpeed = 5.0; // Hz
  Timer? _strobeTimer;
  final List<Color> _colorOptions = [
    Colors.white,
    const Color(0xFFFF6B6B), // Red
    const Color(0xFF4ECDC4), // Cyan
    const Color(0xFFFFE66D), // Yellow
    const Color(0xFF95E1D3), // Mint
    const Color(0xFFAA96DA), // Purple
    const Color(0xFFFCACA3), // Pink
    const Color(0xFF6BCF7F), // Green
  ];

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
        _isScreenLightOn = false;
        _isStrobeOn = false;
        _strobeTimer?.cancel();
        _setTorchState(true);
      } else {
        _setTorchState(false);
      }
    });
  }

  void _toggleScreenLight() {
    setState(() {
      _isScreenLightOn = !_isScreenLightOn;
      if (_isScreenLightOn) {
        _isFlashlightOn = false;
        _isStrobeOn = false;
        _strobeTimer?.cancel();
        _setTorchState(false);
      }
    });
  }

  void _toggleStrobe() {
    setState(() {
      _isStrobeOn = !_isStrobeOn;
      if (_isStrobeOn) {
        _isScreenLightOn = false;
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isScreenLightOn
                ? [_selectedColor, _selectedColor]
                : [
                    const Color(0xFF0A0E21),
                    const Color(0xFF1D1E33),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isScreenLightOn
                    ? _buildScreenLight()
                    : _buildMainContent(),
              ),
            ],
          ),
        ),
      ),
    );
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
                color: const Color(0xFFFFD700).withOpacity(0.9), // Gold text
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildMainButton(),
          const SizedBox(height: 60),
          _buildModeSelector(),
          const SizedBox(height: 40),
          if (_isStrobeOn) _buildStrobeControls(),
          if (!_isStrobeOn) _buildColorPicker(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    return Center(
      child: GestureDetector(
        onTap: _toggleFlashlight,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isFlashlightOn
                ? const Color(0xFFFFD700)
                    .withOpacity(0.1) // Subtle gold background when on
                : Colors.transparent,
            border: Border.all(
              color: _isFlashlightOn
                  ? const Color(0xFFFFD700) // Gold border
                  : Colors.white.withOpacity(0.1),
              width: 2,
            ),
            boxShadow: _isFlashlightOn
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.4),
                      blurRadius: 60,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            Icons.power_settings_new,
            size: 80,
            color: _isFlashlightOn
                ? const Color(0xFFFFD700)
                : Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          _buildModeTab(
              'Light', _isFlashlightOn && !_isStrobeOn, _toggleFlashlight),
          _buildModeTab('Screen', _isScreenLightOn, _toggleScreenLight),
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
                  : Colors.white.withOpacity(0.5), // Black text on Gold
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
                  color: Colors.white.withOpacity(0.5),
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
              inactiveTrackColor: Colors.white.withOpacity(0.1),
              thumbColor: const Color(0xFFFFD700),
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              overlayColor: const Color(0xFFFFD700).withOpacity(0.2),
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

  Widget _buildColorPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'SCREEN COLOR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _colorOptions.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFFD700)
                          : Colors.transparent, // Gold border selection
                      width: 3,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenLight() {
    return GestureDetector(
      onTap: _toggleScreenLight,
      child: Container(
        color: _selectedColor,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 64,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'TAP TO CLOSE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

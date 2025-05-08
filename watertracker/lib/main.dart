import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WaterTrackerScreen(),
    );
  }
}

class WaterTrackerScreen extends StatefulWidget {
  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with SingleTickerProviderStateMixin {
  int _glasses = 0;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💧 Water Tracker'),
        centerTitle: true,
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Water Wave
          Container(
            height: 200,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _WaterWavePainter(
                        progress: _glasses / 8,
                        waveValue: _waveController.value,
                      ),
                    );
                  },
                ),
                Center(
                  child: Text(
                    '${_glasses * 250}ml',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Glass Counter
          Text('$_glasses/8 glasses', style: const TextStyle(fontSize: 24)),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 32),
                onPressed:
                    () => setState(() => _glasses > 0 ? _glasses-- : null),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 32),
                onPressed:
                    () => setState(() => _glasses < 8 ? _glasses++ : null),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaterWavePainter extends CustomPainter {
  final double progress;
  final double waveValue;

  _WaterWavePainter({required this.progress, required this.waveValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue.withOpacity(0.6)
          ..style = PaintingStyle.fill;

    final path = Path();
    final height = size.height * (1 - progress);

    path.moveTo(0, height);

    for (double i = 0; i < size.width; i++) {
      final y =
          height + sin((i / size.width * 2 * pi) + (waveValue * 2 * pi)) * 10;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

double sin(double x) => (math.sin(x) + 1) / 2;

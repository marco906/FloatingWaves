import 'package:flutter/material.dart';
import 'wave_painter.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Painter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WaveDemo(),
    );
  }
}

class WaveDemo extends StatefulWidget {
  const WaveDemo({Key? key}) : super(key: key);

  @override
  State<WaveDemo> createState() => _WaveDemoState();
}

class _WaveDemoState extends State<WaveDemo> with SingleTickerProviderStateMixin {
  // init values
  double waves = 4;
  double segments = 1;
  double amplitude = 50;
  double waveHorOffset = 15;
  double hue = 0;
  Color primColor = Colors.red;
  Color secColor = Colors.orange;
  final duration = 4000;
  late Animation<double> _animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: duration), vsync: this);
    controller.forward();
    controller.addStatusListener((status) {
      setAnimationForStatus(status);
    });
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween(begin: 0.0, end: 1.0).animate(controller);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          // Wave painter
          AnimatedBuilder(
            animation: _animation, 
            builder: (context, nil) {
              return CustomPaint(
                isComplex: true,
                size: const Size(double.infinity, 350),
                painter: WavePainter(
                    time: _animation.value,
                    waves: waves,
                    segments: segments,
                    amplitude: amplitude,
                    waveHorOffset: waveHorOffset,
                    primColor: primColor,
                    secColor: secColor),
              );
          }),

          // Controls for the parameters
          Column(
            children: [
              const Text('Waves', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Slider(value: waves, min: 1, max: 5, divisions: 4, label: waves.toInt().toString(), onChanged: (double value) {
                setState(() { waves = value; });
              }),

              const Text('Segments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Slider(value: segments, min: 1, max: 4, divisions: 3, label: segments.toInt().toString(), onChanged: (double value) {
                setState(() { segments = value; });
              }),

              const Text('Amplitude', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Slider(value: amplitude, min: 10, max: 80, onChanged: (double value) {
                setState(() { amplitude = value; });
              }),
              
              const Text('X Offset', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Slider(value: waveHorOffset, min: 0, max: 50, onChanged: (double value) {
                setState(() { waveHorOffset = value; });
              }),

              const Text('Hue Rotation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Slider(value: hue, min: 0, max: 360, onChanged: (double value) {
                setState(() { 
                  hue = value;
                  primColor = increaseColorHue(Colors.red, value);
                  secColor = increaseColorHue(Colors.red, value + 40);
                  });
              }),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    print("dispose");
  }

  void setAnimationForStatus(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        controller.reset();
        break;
      case AnimationStatus.dismissed:
        controller.forward();
        break;
      default:
        break;
    }
  }

  Color increaseColorHue(Color color, double increment) {
    var hslColor = HSLColor.fromColor(color);
    var newValue = min(max(hslColor.lightness + increment, 0.0), 360.0);
    return hslColor.withHue(newValue).toColor();
  }
}

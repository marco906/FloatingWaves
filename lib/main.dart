import 'package:flutter/material.dart';
import 'WavePainter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  double time = 0.0;
  double waves = 4;
  double segments = 1;
  double amplitude = 50;
  double waveHorOffset = 15;
  Color primColor = Colors.red;
  Color secColor = Colors.orange;
  final period = 1.0;
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
    _animation = Tween(begin: 0.0, end: period).animate(controller)
      ..addListener(() {
        setState(() {
          time = _animation.value;
        });
      });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomPaint(
            size: const Size(double.infinity, 350),
            painter: WavePinter(
                time: time,
                waves: waves,
                segments: segments,
                amplitude: amplitude,
                waveHorOffset: waveHorOffset,
                primColor: primColor,
                secColor: secColor),
          ),

          // Controls for the parameters
          Column(
            children: [
              const Text('Waves', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Slider(
                  value: waves,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: waves.toInt().toString(),
                  onChanged: (double value) {
                    setState(() {
                      waves = value;
                    });
                  }),
              const Text('Segments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Slider(
                  value: segments,
                  min: 1,
                  max: 4,
                  divisions: 3,
                  label: segments.toInt().toString(),
                  onChanged: (double value) {
                    setState(() {
                      segments = value;
                    });
                  }),
              const Text('Amplitude', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Slider(
                  value: amplitude,
                  min: 10,
                  max: 80,
                  //divisions: 7,
                  //label: amplitude.toInt().toString(),
                  onChanged: (double value) {
                    setState(() {
                      amplitude = value;
                    });
                  }),
              const Text('Wave X Offset', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Slider(
                  value: waveHorOffset,
                  min: 0,
                  max: 50,
                  onChanged: (double value) {
                    setState(() {
                      waveHorOffset = value;
                    });
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: const Text('Red'),
                      onPressed: () {
                        setState(() {
                          primColor = Colors.red;
                          secColor = Colors.orange;
                        });
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.yellow),
                      child: const Text('Yellow'),
                      onPressed: () {
                        setState(() {
                          primColor = Colors.yellow;
                          secColor = Colors.yellowAccent.shade100;
                        });
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      child: const Text('Blue'),
                      onPressed: () {
                        setState(() {
                          primColor = Colors.blue;
                          secColor = Colors.lightBlueAccent;
                        });
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
                      child: const Text('Green'),
                      onPressed: () {
                        setState(() {
                          primColor = Colors.greenAccent.shade400;
                          secColor = Colors.greenAccent;
                        });
                      }),
                ],
              )
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
}

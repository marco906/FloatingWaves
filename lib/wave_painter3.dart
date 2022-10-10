import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class WaveDemo3 extends StatefulWidget {
  const WaveDemo3({Key? key}) : super(key: key);

  @override
  State<WaveDemo3> createState() => _WaveDemo3State();
}

class _WaveDemo3State extends State<WaveDemo3> with SingleTickerProviderStateMixin {
  WaveCofig config = WaveCofig();
	bool isPlaying = true;
	double stoppedTime = 0.0;

  late Animation<double> _animation;
  late AnimationController controller;

  final textStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey);
  final textStyle2 = const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: config.duration), vsync: this);
    controller.forward();
    controller.addStatusListener((status) {
      setAnimationForStatus(status);
    });
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, nil) {
              return Padding(
                padding: const EdgeInsets.only(top: 100),
                child: CustomPaint(
                  size: Size(size.width, (size.width * 0.2)),
                  painter: WavePainter3(controller.value, config),
                ),
              );
            }),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
								controlRow(children: [
                  playButton,
									speedControl
                ]),
                controlRow(children: [
                  ampControl,
                  densityControl,
                ]),

                controlRow(children: [
                  scaleControl,
                  windowFractionControl,
                ]),
                controlRow(children: [
                  waveControl,
                  hueControl,
                ]),
                controlRow(children: [
                  thicknessControl,
                  glowControl,
                ]),
                controlRow(children: [
                  waveTrimControl,
									waveOffsetControl
                ]),
								controlRow(children: [
                  waveFadeControl,
                ]),
								controlRow(children: [
                  rotationControl(config.rotX, RotationType.X),
                  rotationControl(config.rotY, RotationType.Y),
                ]),
                controlRow(children: [
                  rotationControl(config.rotZ, RotationType.Z),
                  depthControl,
                ]),

                translateButtons,
                viewButtons
              ],
            ),
          )
        ],
      ),
    );
  }

  void setRotation(double value, RotationType type)
  {
    setState(() {
      switch (type) {
        case RotationType.X:
          config.rotX = value;
          return;
        case RotationType.Y:
          config.rotY = value;
          return;
        case RotationType.Z:
          config.rotZ = value;
          return;
      }
    });
  }

  // MARK: - Controls
  Widget controlRow({required List<Widget> children})
  {
    return SizedBox(height: 80, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: children));
  }

  Widget controlHeader(String title, double value, int precision)
  {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Text(title, style: textStyle),
      const SizedBox(width: 5),
      Text(value.toStringAsFixed(precision), style: textStyle2)
    ]);
  }

  Widget rotationControl(double value, RotationType type)
  {
    return Column(children: [
      controlHeader("Rot ${type.name}", value, 2),
      Slider(
        value: value, min: -pi, max: pi,
        onChanged: (double value) { setRotation(value, type); }
      ),
    ]);
  }

  Widget get depthControl
  {
    return Column(children: [
      controlHeader("Depth", config.depth, 2),
      Slider(
        value: config.depth, min: 0, max: 10,
        onChanged: (double value) { setState(() { config.depth = value; }); }
      ),
    ]);
  }

  Widget get scaleControl
  {
    return Column(children: [
      controlHeader("Scale", config.scale, 2),
      Slider(
        value: config.scale, min: 0.05, max: 10,
        onChanged: (double value) { setState(() { config.scale = value; }); }
      ),
    ]);
  }

  Widget get thicknessControl
  {
    return Column(children: [
      controlHeader("Thickness", config.thickness, 1),
      Slider(
        value: config.thickness, min: 1, max: 12,
        onChanged: (double value) { setState(() { config.thickness = value; }); }
      ),
    ]);
  }

  Widget get waveControl
  {
    return Column(children: [
      controlHeader("Waves", config.waves.toDouble(), 0),
      Slider(
        value: config.waves.toDouble(), divisions: config.maxWaves - 1, min: 1, max: config.maxWaves.toDouble(), 
        onChanged: (double value) { setState(() { config.waves = value.toInt(); }); }
      ),
    ]);
  }

  Widget get hueControl
  {
    return Column(children: [
      controlHeader("Color", config.hue, 0),
      Slider(
        value: config.hue, min: 0, max: 360, 
        onChanged: (double value) { setState(() { config.hue = value; }); }
      ),
    ]);
  }

  Widget get ampControl
  {
    return Column(children: [
      controlHeader("Amplitude", config.amplitude, 2),
      Slider(
        value: config.amplitude, min: 0.1, max: 1, 
        onChanged: (double value) { setState(() { config.amplitude = value; }); }
      ),
    ]);
  }

  Widget get densityControl
  {
    return Column(children: [
      controlHeader("Density", config.density, 1),
      Slider(
        value: config.density, min: 1, max: 5, 
        onChanged: (double value) { setState(() { config.density = value; }); }
      ),
    ]);
  }

  Widget get windowFractionControl
  {
    return Column(children: [
      controlHeader("Length", config.windowfraction, 1),
      Slider(
        value: config.windowfraction, min: 0.05, max: 1.0, 
        onChanged: (double value) { setState(() { config.windowfraction = value; }); }
      ),
    ]);
  }

  Widget get glowControl
  {
    return Column(children: [
      controlHeader("Glow", config.blur, 2),
      Slider(
        value: config.blur, min: 0.0, max: 5.0, 
        onChanged: (double value) { setState(() { config.blur = value; }); }
      ),
    ]);
  }

  Widget get speedControl
  {
    return Column(children: [
      controlHeader("Speed", config.duration.toDouble()/1000, 0),
      Slider(
        value: config.duration.toDouble(), min: 1000, max: 5000, 
        onChanged: (double value) { setState(() { 
          config.duration = value.toInt();
          controller.duration = Duration(milliseconds: value.toInt()); }); }
      ),
    ]);
  }

	Widget get waveOffsetControl
  {
    return Column(children: [
      controlHeader("WaveOffset", config.waveOffset.dx, 2),
      Slider(
        value: config.waveOffset.dx, min: 0.0, max: 10, 
        onChanged: (double value) { setState(() { config.waveOffset = Offset(value, config.waveOffset.dy); }); }
      ),
    ]);
  }

	Widget get waveTrimControl
  {
    return Column(children: [
      controlHeader("WaveTrim", config.waveTrim, 1),
      Slider(
        value: config.waveTrim, min: 0.0, max: 10, 
        onChanged: (double value) { setState(() { config.waveTrim = value; }); }
      ),
    ]);
  }

	Widget get waveFadeControl
  {
    return Column(children: [
      controlHeader("WaveFade", config.waveFadeFactor, 1),
      Slider(
        value: config.waveFadeFactor, min: 0.0, max: 1.0, 
        onChanged: (double value) { setState(() { config.waveFadeFactor = value; }); }
      ),
    ]);
  }

	Widget get playButton
	{
		return OutlinedButton(
    onPressed: () {
      setState(() {
				isPlaying ? controller.stop() : controller.forward();
				isPlaying = !isPlaying;
      });
    },
    child: Text(isPlaying ? "Pause" : "Play"),
    );
	}

  Widget get translateButtons  
  {
    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    OutlinedButton(
    onPressed: () {
      setState(() {
        config.transX = config.transX - 20;
      });
    },
    child: Text("Left"),
    ),
    OutlinedButton(
    onPressed: () {
      setState(() {
        config.transX = config.transX + 20;
      });
    },
    child: Text("Right"),
    ),
    OutlinedButton(
    onPressed: () {
      setState(() {
        config.transY = config.transY - 20;
      });
    },
    child: Text("Up"),
    ),
    OutlinedButton(
    onPressed: () {
      setState(() {
        config.transY = config.transY + 20;
      });
    },
    child: Text("Down")
    )
    ]);
  }

  Widget get viewButtons
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {
            setState(() {
              config.rotX = -0.42;
              config.rotY = -0.26;
              config.rotZ = -0.49;
              config.depth = 7.0;
              config.scale = 3.38;
              config.transX = 0;
              config.transY = 50;
            });
          },
          child: Text("View1"),
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              config.scale = 5.0;
              config.rotX = -0.51;
              config.rotY = 0;
              config.rotZ = -1.16;
              config.transX = 0;
              config.transY = 200;
            });
          },
          child: Text("View2"),
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              config.scale = 1;
              config.rotX = 0;
              config.rotY = 0;
              config.rotZ = 0;
              config.transX = 0;
              config.transY = 0;
            });
          },
          child: Text("Reset"),
        ),
      ],
    );
  }
}

class WaveCofig
{
  double width = 300;
  double windowfraction = 0.6;
  double amplitude = 0.40;
  double density = 2.0;
  double rotX = 0;
  double rotY = 0;
  double rotZ = 0;
	double depth = 7.0;
  double scale = 1;
  double transX = 0;
  double transY = 0;
	double hue = 215;
  double blur = 0.0;
	double thickness = 1.5;
	int waves = 15;
	int waveGroups = 1;
	double waveTrim = 3.0;
	Offset waveOffset = Offset(2.2, 0);
	Offset waveGroupOffset = Offset(50, 0);
	double waveFadeFactor = 1.0;
  int duration = 3000;
	final int maxWaves = 20;

  static WaveCofig get simple
	{
		final WaveCofig config = WaveCofig();
		config.waves = 1;
		return config;
	}
}

// Painter
class WavePainter3 extends CustomPainter {
  final double time;
  final WaveCofig config;

  WavePainter3(this.time, this.config);

  @override
  void paint(Canvas canvas, Size size) {

    const Color baseColor = Color.fromARGB(200, 33, 240, 243);
		final Color modColor = increaseColorHue(baseColor, config.hue);

    Paint paint0 = Paint()
      ..color = modColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = config.thickness
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, config.blur)
      ..blendMode = BlendMode.screen;

    final rotationMatrix = Matrix4.identity()
      ..rotateX(config.rotX)
      ..rotateY(config.rotY)
      ..rotateZ(config.rotZ)
      ..scale(config.scale);

    final depthMatrix = Matrix4.identity()
      ..setEntry(3, 0, 0.000)
      ..setEntry(3, 1, 0.000)
      ..setEntry(3, 2, config.depth / 1000);

		void drawWaveGroup(Canvas canvas)
		{
			for (var w = 0; w < config.waves; w++)
			{
				
				final double offsetx = config.waveOffset.dx * w;
				final double waveTrim = config.waveTrim * w;
				final double fadeValue = w / config.waves;
				//final Matrix4 matrix = Matrix4.identity().scaled(1, 1, 1);
				final Path path = createWavePath(size, w, waveTrim, offsetx);

				final Color waveColor = modColor.withAlpha(modColor.alpha - (modColor.alpha * fadeValue * config.waveFadeFactor).toInt());
				Paint paint_x = paint0;
				paint_x.color = waveColor;
				canvas.drawPath(path, paint_x);
			}
		}

    // transform canvas space
    canvas.translate(config.transX, config.transY);
    canvas.transform(depthMatrix.storage);
    canvas.transform(rotationMatrix.storage);

		drawWaveGroup(canvas);
		
  }

  @override
  bool shouldRepaint(covariant WavePainter3 oldDelegate)
	{
		return true;
    //return (oldDelegate.time != time || oldDelegate.config != config);
  }

	Color increaseColorHue(Color color, double increment) 
	{
		var hslColor = HSLColor.fromColor(color);
		var newValue = min(max(hslColor.lightness + increment, 0.0), 360.0);
		return hslColor.withHue(newValue).toColor();
	}

  // create path
  double yValue(double xFraction, Size size, int index)
  {
    final density = config.density;
    const omega = 2 * pi;
    final double amp = size.height * 0.5 * config.amplitude;
    final double variation = 1 - index * 0.1;
    //var random = Random();
    //final double factor = random.nextDouble();
    return sin(xFraction * omega * density) * amp * variation;
  }

  Path createWavePath(Size size, int index, double windowTrim, double waveOffset) 
	{
    final width = size.width;
    final double windowWidth = width * config.windowfraction;
    double xmin = time * (width + windowWidth) - windowWidth + windowTrim;
    double xmax = xmin + windowWidth - 3 * windowTrim;
    xmin = xmin < -windowTrim ? -windowTrim : xmin;
    xmax = xmax > width ? width : xmax;

    List<Offset> relativePoints = [];
    for (double x = xmin; x <= xmax; x++) {
      final relativePoint = Offset(x + waveOffset, yValue(x/width, size, index));
      relativePoints.add(relativePoint);
    }
    final path_0 = Path();
    path_0.moveTo(0, size.height /2);
    path_0.addPolygon(relativePoints, false);
    
    return path_0;
  }
}

enum RotationType
{
  X, Y, Z
}

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
  double width = 300;
  double time = 0;
  double rotX = 0;
  double rotY = 0;
  double rotZ = 0;
	double depth = 7.0;
  double scale = 1;
  double transX = 0;
  double transY = 0;
	double hue = 75;
	double thickness = 2.0;
	int waves = 1;

  final duration = 3000;
  late Animation<double> _animation;
  late AnimationController controller;

  final textStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey);
  final textStyle2 = const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey);

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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
              animation: _animation,
              builder: (context, nil) {
                return CustomPaint(
                  size: Size(size.width, (size.width * 0.20)),
                  painter: WavePainter3(controller.value, rotX, rotY, rotZ, scale, transX, transY, depth, hue, thickness, waves),
                );
              }),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Row(
                  children: [
                    Text('Rot X', style: textStyle),
                    const SizedBox(width: 5),
                    Text(rotX.toStringAsFixed(2), style: textStyle2)
                  ],
                ),
                Row(
                  children: [
                    Text('Rot Y', style: textStyle),
                    const SizedBox(width: 5),
                    Text(rotY.toStringAsFixed(2), style: textStyle2)
                  ],
                ),
              ]),
              Row(
                children: [
                  Slider(
                      value: rotX,
                      min: -pi,
                      max: pi,
                      onChanged: (double value) {
                        setState(() {
                          rotX = value;
                        });
                      }),
                  Slider(
                      value: rotY,
                      min: -pi,
                      max: pi,
                      onChanged: (double value) {
                        setState(() {
                          rotY = value;
                        });
                      }),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Row(
                  children: [
                    Text('Rot Z', style: textStyle),
                    const SizedBox(width: 5),
                    Text(rotZ.toStringAsFixed(2), style: textStyle2)
                  ],
                ),
                Row(
                  children: [
                    Text('Depth', style: textStyle),
                    const SizedBox(width: 5),
                    Text(depth.toStringAsFixed(1), style: textStyle2)
                  ],
                ),
              ]),
              Row(
                children: [
                  Slider(
                      value: rotZ,
                      min: -pi,
                      max: pi,
                      onChanged: (double value) {
                        setState(() {
                          rotZ = value;
                        });
                      }),
                  Slider(
                      value: depth,
                      min: 0,
                      max: 10,
                      onChanged: (double value) {
                        setState(() {
                          depth = value;
                        });
                      }),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Row(
                  children: [
                    Text('Scale', style: textStyle),
                    const SizedBox(width: 5),
                    Text(scale.toStringAsFixed(2), style: textStyle2)
                  ],
                ),
                Row(
                  children: [
                    Text('Thickness', style: textStyle),
                    const SizedBox(width: 5),
                    Text(thickness.toStringAsFixed(1), style: textStyle2)
                  ],
                ),
              ]),
              Row(
                children: [
                  Slider(
                      value: scale,
                      min: 0,
                      max: 5,
                      onChanged: (double value) {
                        setState(() {
                          scale = value;
                        });
                      }),
                  Slider(
                      value: thickness,
                      min: 1,
                      max: 12,
                      onChanged: (double value) {
                        setState(() {
                          thickness = value;
                        });
                      }),
                ],
              ),

							Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Row(
                  children: [
                    Text('Waves', style: textStyle),
                    const SizedBox(width: 5),
                    Text(waves.toStringAsFixed(0), style: textStyle2)
                  ],
                ),
                Row(
                  children: [
                    Text('Color', style: textStyle),
                    const SizedBox(width: 5),
                    Text(hue.toStringAsFixed(0), style: textStyle2)
                  ],
                ),
              ]),
              Row(
                children: [
                  Slider(
                      value: waves.toDouble(),
                      min: 1,
                      max: 20,
											divisions: 9,
                      onChanged: (double value) {
                        setState(() {
                          waves = value.toInt();
                        });
                      }),
                  Slider(
                      value: hue,
                      min: 0,
                      max: 360,
                      onChanged: (double value) {
                        setState(() {
                          hue = value;
                        });
                      }),
                ],
              ),
              
							translateButtons,

              Row(
								mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
												rotX = -0.42;
												rotY = -0.26;
												rotZ = -0.49;
												depth = 7.0;
												scale = 3.38;
												transX = 0;
												transY = 50;
                      });
                    },
                    child: Text("View1"),
                  ),
									OutlinedButton(
                    onPressed: () {
                      setState(() {
                        scale = 5.0;
                        rotX = -0.51;
                        rotY = 0;
                        rotZ = -1.16;
                        transX = 0;
                        transY = 200;
                      });
                    },
                    child: Text("View2"),
                  ),
									OutlinedButton(
                    onPressed: () {
                      setState(() {
                        scale = 1;
                        rotX = 0;
                        rotY = 0;
                        rotZ = 0;
                        transX = 0;
                        transY = 0;
                      });
                    },
                    child: Text("Reset"),
                  ),
                ],
              )
            ],
          )
        ],
      ),
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
        transX = transX - 20;
      });
    },
    child: Text("Left"),
    ),
    OutlinedButton(
    onPressed: () {
      setState(() {
        transX = transX + 20;
      });
    },
    child: Text("Right"),
    ),
    OutlinedButton(
    onPressed: () {
      setState(() {
        transY = transY - 20;
      });
    },
    child: Text("Up"),
    ),
    OutlinedButton(
    onPressed: () {
      setState(() {
        transY = transY + 20;
      });
    },
    child: Text("Down")
    )
    ]);
  }
}

// Painter
class WavePainter3 extends CustomPainter {
  final double time;
  final double rotX;
  final double rotY;
  final double rotZ;
  final double scale;
  final double transX;
  final double transY;
	final double depth;
	final double hue;
	final double thickness;
	final int waves;

  WavePainter3(this.time, this.rotX, this.rotY, this.rotZ, this.scale, this.transX, this.transY, this.depth, this.hue, this.thickness, this.waves);

  @override
  void paint(Canvas canvas, Size size) {

    const Color baseColor = Color.fromARGB(200, 33, 240, 243);
		final Color modColor = increaseColorHue(baseColor, hue);

    Paint paint0 = Paint()
      ..color = modColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickness
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 0.5)
      ..blendMode = BlendMode.screen;

    final rotationMatrix = Matrix4.identity()
      ..rotateX(rotX)
      ..rotateY(rotY)
      ..rotateZ(rotZ)
      ..scale(scale);

    final depthMatrix = Matrix4.identity()
      ..setEntry(3, 0, 0.000)
      ..setEntry(3, 1, 0.000)
      ..setEntry(3, 2, depth / 1000);

    // transform canvas space
    canvas.translate(transX, transY);
    canvas.transform(depthMatrix.storage);
    canvas.transform(rotationMatrix.storage);

		final double offsetVal = 2;
		for (var w = 0; w < waves; w++)
		{
      final Path path_0 = createWavePath(size, w);
			final offset = Offset(w * offsetVal, 0);
      //final Matrix4 matrix = Matrix4.identity().scaled(1, 1, 1);
		  final path = path_0.shift(-offset);
      final random = Random();
      
      final Color color_x = modColor.withAlpha(modColor.alpha - (w * 15));
      Paint paint_x = paint0;
      paint_x.color = color_x;
			canvas.drawPath(path, paint_x);
		}
  }

  @override
  bool shouldRepaint(covariant WavePainter3 oldDelegate)
	{
    return oldDelegate.time != time;
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
    const density = 4;
    const omega = 2 * pi;
    final double amp = size.height * 0.5 * 0.3;
    final double variation = 1 - index * 0.05;
    //var random = Random();
    //final double factor = random.nextDouble();
    return sin(xFraction * omega * density) * amp * variation;
  }

  Path createWavePath(Size size, index) 
	{
    final width = size.width;
    final double windowWidth = width * 0.4;
    double xmin = time * (width + windowWidth) - windowWidth;
    double xmax = xmin + windowWidth;
    xmin = xmin < 0 ? 0 : xmin.roundToDouble();
    xmax = xmax > width ? width : xmax.roundToDouble();

    List<Offset> relativePoints = [];
    for (double x = xmin; x <= xmax; x++) {
      final relativePoint = Offset(x, yValue(x/width, size, index));
      relativePoints.add(relativePoint);
    }
    final path_0 = Path();
    path_0.moveTo(0, size.height /2);
    path_0.addPolygon(relativePoints, false);
    
    return path_0;
  }
}

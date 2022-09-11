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
  double scale = 1;

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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
              animation: _animation,
              builder: (context, nil) {
                return CustomPaint(
                  size: Size(width, (width * 0.18)),
                  painter: WavePainter3(_animation.value, rotX, rotY, rotZ, scale),
                );
              }),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
                Text('Rot X', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Rot Y', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
                Text('Rot Z', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Scale', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                      value: scale,
                      min: 0,
                      max: 5,
                      onChanged: (double value) {
                        setState(() {
                          scale = value;
                        });
                      }),
                ],
              ),
              Text('Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Slider(
                  value: time,
                  min: 0,
                  max: 1,
                  onChanged: (double value) {
                    setState(() {
                      time = value;
                    });
                  }),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    scale = 1;
                    rotX = 0;
                    rotY = 0;
                    rotZ = 0;
                  });
                },
                child: Text("Reset"),
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

// Painter
class WavePainter3 extends CustomPainter {
  final double time;
  final double rotX;
  final double rotY;
  final double rotZ;
  final double scale;

  WavePainter3(this.time, this.rotX, this.rotY, this.rotZ, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      //..color = Color.fromARGB(255, 235, 238, 34)
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    final int alpha1 = (sin((time * pi) + 0.00 * pi) * 255).abs().toInt();
    final int alpha2 = (sin((time * pi) + 0.0625 * pi) * 255).abs().toInt();
    final int alpha3 = (sin((time * pi) + 0.125 * pi) * 255).abs().toInt();
		final int alpha4 = (sin((time * pi) + 0.1875 * pi) * 255).abs().toInt();
    final int alpha5 = (sin((time * pi) + 0.25 * pi) * 255).abs().toInt();

    final Color baseColor = Color.fromARGB(255, 244, 19, 68);

    final gradient = ui.Gradient.linear(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), [
      baseColor.withAlpha(0),
      baseColor.withAlpha(alpha1),
      baseColor.withAlpha(alpha2),
      baseColor.withAlpha(alpha3),
			baseColor.withAlpha(alpha4),
      baseColor.withAlpha(alpha5),
      baseColor.withAlpha(0),
      // Color.fromARGB(255, 237, 244, 19),
      // Color.fromARGB(0, 255, 255, 255),
    ], [
      0.0,
      0.1,
      0.25,
			0.5,
			0.75,
      0.9,
      1.0
    ]);

    paint0.shader = gradient;

    final rotationMatrix = Matrix4.identity()
      ..rotateX(rotX)
      ..rotateY(rotY)
      ..rotateZ(rotZ)
      ..scale(scale)
      ..setEntry(3, 0, 0.000)
      ..setEntry(3, 1, 0.000)
      ..setEntry(3, 2, 0.000);

    // transform canvas space
    canvas.transform(rotationMatrix.storage);

    // create path
    final path_0 = createWavePath(size);

    canvas.drawPath(path_0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Path createWavePath(Size size) {
    final path_0 = Path();
    path_0.moveTo(size.width * 0.9816266, size.height * 0.6732048);
    path_0.cubicTo(size.width * 0.9699056, size.height * 0.8037976, size.width * 0.9457210, size.height * 0.8865714, size.width * 0.9192232,
        size.height * 0.8867952);
    path_0.cubicTo(size.width * 0.8972790, size.height * 0.8875738, size.width * 0.8774549, size.height * 0.8337857, size.width * 0.8616953,
        size.height * 0.7524262);
    path_0.cubicTo(size.width * 0.8465536, size.height * 0.6747571, size.width * 0.8354077, size.height * 0.5776690, size.width * 0.8237811,
        size.height * 0.4841738);
    path_0.cubicTo(size.width * 0.8127210, size.height * 0.3953405, size.width * 0.8021202, size.height * 0.3038833, size.width * 0.7889227,
        size.height * 0.2233012);
    path_0.cubicTo(size.width * 0.7752318, size.height * 0.1401943, size.width * 0.7586395, size.height * 0.06961190,
        size.width * 0.7390300, size.height * 0.03466048);
    path_0.cubicTo(size.width * 0.7172361, size.height * -0.003774286, size.width * 0.6936609, size.height * 0.001628438,
        size.width * 0.6725279, size.height * 0.04990310);
    path_0.cubicTo(size.width * 0.6345408, size.height * 0.1378643, size.width * 0.6124549, size.height * 0.3438833, size.width * 0.5904077,
        size.height * 0.5236905);
    path_0.cubicTo(size.width * 0.5793476, size.height * 0.6142714, size.width * 0.5678283, size.height * 0.7055333, size.width * 0.5524893,
        size.height * 0.7761167);
    path_0.cubicTo(size.width * 0.5356910, size.height * 0.8537857, size.width * 0.5148069, size.height * 0.8964071, size.width * 0.4927210,
        size.height * 0.8850476);
    path_0.cubicTo(size.width * 0.4474378, size.height * 0.8618452, size.width * 0.4223498, size.height * 0.6268929, size.width * 0.3994524,
        size.height * 0.4399024);
    path_0.cubicTo(size.width * 0.3777386, size.height * 0.2627190, size.width * 0.3529682, size.height * 0.07543714,
        size.width * 0.3128798, size.height * 0.02330117);
    path_0.cubicTo(size.width * 0.2907073, size.height * -0.005371881, size.width * 0.2674039, size.height * 0.009930119,
        size.width * 0.2470850, size.height * 0.06650500);
    path_0.cubicTo(size.width * 0.2291695, size.height * 0.1166993, size.width * 0.2145936, size.height * 0.1955340, size.width * 0.2022262,
        size.height * 0.2815548);
    path_0.cubicTo(size.width * 0.1898588, size.height * 0.3675738, size.width * 0.1792579, size.height * 0.4612619, size.width * 0.1679858,
        size.height * 0.5519429);
    path_0.cubicTo(size.width * 0.1567137, size.height * 0.6426214, size.width * 0.1444348, size.height * 0.7347571, size.width * 0.1280391,
        size.height * 0.8004857);
    path_0.cubicTo(size.width * 0.1102296, size.height * 0.8718452, size.width * 0.08766781, size.height * 0.9046595,
        size.width * 0.06591888, size.height * 0.8781548);
    path_0.cubicTo(size.width * 0.04520343, size.height * 0.8521595, size.width * 0.02773979, size.height * 0.7760714,
        size.width * 0.01840991, size.height * 0.6711643);

    // path_0.lineTo(size.width*0.01689047,size.height*0.6732048);
    // path_0.lineTo(0,size.height*0.7127190);
    // path_0.cubicTo(size.width*0.007874378,size.height*0.8041714,size.width*0.02060695,size.height*0.8803690,size.width*0.03651944,size.height*0.9312619);
    // path_0.cubicTo(size.width*0.06445236,size.height*1.019612,size.width*0.09957597,size.height*1.016312,size.width*0.1276854,size.height*0.9319429);
    // path_0.cubicTo(size.width*0.1529150,size.height*0.8562143,size.width*0.1706185,size.height*0.7280595,size.width*0.1863781,size.height*0.5993214);
    // path_0.cubicTo(size.width*0.1952120,size.height*0.5270881,size.width*0.2038515,size.height*0.4536905,size.width*0.2132863,size.height*0.3835929);
    // path_0.cubicTo(size.width*0.2223498,size.height*0.3163119,size.width*0.2325266,size.height*0.2520381,size.width*0.2449472,size.height*0.2030100);
    // path_0.cubicTo(size.width*0.2718489,size.height*0.09255286,size.width*0.3087300,size.height*0.09172524,size.width*0.3357948,size.height*0.2009710);
    // path_0.cubicTo(size.width*0.3482863,size.height*0.2495143,size.width*0.3585159,size.height*0.3135929,size.width*0.3675970,size.height*0.3807762);
    // path_0.cubicTo(size.width*0.3772438,size.height*0.4521357,size.width*0.3860249,size.height*0.5270881,size.width*0.3950528,size.height*0.6007762);
    // path_0.cubicTo(size.width*0.4109541,size.height*0.7298071,size.width*0.4286219,size.height*0.8587381,size.width*0.4541717,size.height*0.9340786);
    // path_0.cubicTo(size.width*0.4837811,size.height*1.020438,size.width*0.5193734,size.height*1.017507,size.width*0.5484979,size.height*0.9263119);
    // path_0.cubicTo(size.width*0.5732318,size.height*0.8479619,size.width*0.5905494,size.height*0.7195143,size.width*0.6062017,size.height*0.5914571);
    // path_0.cubicTo(size.width*0.6151416,size.height*0.5184476,size.width*0.6238712,size.height*0.4441738,size.width*0.6334807,size.height*0.3738833);
    // path_0.cubicTo(size.width*0.6427210,size.height*0.3064071,size.width*0.6531803,size.height*0.2424262,size.width*0.6659528,size.height*0.1948545);
    // path_0.cubicTo(size.width*0.6794034,size.height*0.1440021,size.width*0.6954249,size.height*0.1177107,size.width*0.7117511,size.height*0.1197088);
    // path_0.cubicTo(size.width*0.7278584,size.height*0.1231090,size.width*0.7433863,size.height*0.1536102,size.width*0.7562361,size.height*0.2070876);
    // path_0.cubicTo(size.width*0.7686052,size.height*0.2572810,size.width*0.7787468,size.height*0.3223310,size.width*0.7877897,size.height*0.3902905);
    // path_0.cubicTo(size.width*0.7968369,size.height*0.4582524,size.width*0.8053004,size.height*0.5300976,size.width*0.8139227,size.height*0.6002905);
    // path_0.cubicTo(size.width*0.8298240,size.height*0.7296119,size.width*0.8476481,size.height*0.8586405,size.width*0.8731631,size.height*0.9337857);
    // path_0.cubicTo(size.width*0.9034635,size.height*1.023107,size.width*0.9414506,size.height*1.017476,size.width*0.9699657,size.height*0.9091262);
    // path_0.cubicTo(size.width*0.9827940,size.height*0.8597810,size.width*0.9931288,size.height*0.7933333,size.width,size.height*0.7160190);
    // path_0.lineTo(size.width*0.9816266,size.height*0.6732048);
    // path_0.close();
    return path_0;
  }
}

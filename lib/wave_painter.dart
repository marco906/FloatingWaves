import 'package:flutter/material.dart';
import 'dart:math';

// Custom Painter Class
class WavePainter extends CustomPainter {
	final double time;
	final double waves;
	final double segments;
	final double amplitude;
	final double waveHorOffset;
	final Color primColor;
	final Color secColor;

	WavePainter(
			{required this.time,
			required this.waves,
			required this.segments,
			required this.amplitude,
			required this.waveHorOffset,
			required this.primColor,
			required this.secColor});

	@override
	void paint(Canvas canvas, Size size) {
		var path = Path();
		// Additional Parameters
		const amplitudeVariation = 0.12;
		const waveVertOffset = 0.0;
		const waveBaseThickness = 4.0;

		final segmentWidth = size.width / segments;
		final baseLine = size.height * 0.5;
		final xShift = size.width * time;
		final xShift2 = size.width * 1 - time;

		// Draw single wave
		void drawWave(double amplitude, double horShift, double baseShift, double timeShift) {
			var wavePath = Path();
			final ampltudeScale = sin(time * 2 * pi + timeShift * pi);
			final waveBaseline = baseLine + baseShift;

			void addBezierLine(double start, double widthFraction, double offset, int direction) {
				wavePath.quadraticBezierTo(start + segmentWidth * (widthFraction + offset), waveBaseline + amplitude * ampltudeScale * direction,
						start + segmentWidth * (2 * widthFraction + offset), waveBaseline);
			}

			// Add Bezier points for segments
			for (var x = 1; x <= segments; x++) {
				final startPoint = (x - 1) * segmentWidth;
				wavePath.moveTo(startPoint, waveBaseline);
				addBezierLine(startPoint, 0.25, 0, 1);
				addBezierLine(startPoint, 0.25, 0.5, -1);
			}

			// x shift variation for single wave
			path.addPath(wavePath, Offset(horShift, 0));
			path.addPath(wavePath, Offset(-(size.width - horShift), 0));
		}

		// Draw all waves
		for (var w = 0; w < waves; w++) {
			final variation = 1 - (w * amplitudeVariation);
			drawWave(amplitude * variation, w * waveHorOffset, w * waveVertOffset, variation);

			// x shift for all waves
			path = path.shift(Offset(xShift, 0));
			path.addPath(path, Offset(-xShift2, 0));

			// Create the paint and draw
			final paint = createPaint(primColor, secColor, waveBaseThickness, size, variation);
			canvas.drawPath(path, paint);
			//canvas.saveLayer(bounds, paint)

			// reset path
			path = Path();
		}
	}

	Paint createPaint(Color primaryColor, Color secondaryColor, double baseStroke, Size size, double variation) {
		final clear = Colors.white.withOpacity(0);
		final strokeVariation = sin((time + variation) * 2 * pi) * baseStroke * 0.3;
		var paint = Paint()
			..strokeWidth = baseStroke + strokeVariation
			..style = PaintingStyle.stroke
			..isAntiAlias = true
			//..color = primaryColor;
			..shader = LinearGradient(
				colors: [clear, secondaryColor, primaryColor, secondaryColor, clear],
				stops: const [0.2, 0.3, 0.5, 0.7, 0.8],
				transform: GradientRotation(time * pi + 2 * (variation + 1) * pi))
					.createShader(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2));
		return paint;
	}

	@override
	bool shouldRepaint(covariant WavePainter oldDelegate) {
		return oldDelegate.time != time;
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
							const Text('Segments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
							const Text('Amplitude', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
							Slider(
									value: amplitude,
									min: 10,
									max: 80,
									onChanged: (double value) {
										setState(() {
											amplitude = value;
										});
									}),
							const Text('X Offset', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
							Slider(
									value: waveHorOffset,
									min: 0,
									max: 50,
									onChanged: (double value) {
										setState(() {
											waveHorOffset = value;
										});
									}),
							const Text('Hue Rotation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
							Slider(
									value: hue,
									min: 0,
									max: 360,
									onChanged: (double value) {
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
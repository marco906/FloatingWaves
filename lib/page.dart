import 'dart:math';
import 'package:flutter/material.dart';
import 'package:waves/model.dart';
import 'package:waves/widgets.dart';

class WaveDemo extends StatefulWidget {
	const WaveDemo({Key? key}) : super(key: key);

	@override
	State<WaveDemo> createState() => _WaveDemoState();
}

class _WaveDemoState extends State<WaveDemo> with SingleTickerProviderStateMixin {
	WaveCofigModel model = WaveCofigModel.adv1;
	bool showConfig = true;

	late Animation<double> _animation;
	late AnimationController controller;

	final textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey);
	final textStyle2 = const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey);
	final textStyle3 = const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey);

	@override
	void initState() {
		super.initState();
		controller = AnimationController(duration: Duration(milliseconds: model.duration), vsync: this);
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
				children: [
					AnimatedBuilder(
						animation: _animation,
						builder: (context, nil) {
							return Padding(
								padding: const EdgeInsets.only(top: 100),
								child: CustomPaint(
									size: Size(size.width, (size.width * 0.2)),
									painter: WavePainter2(controller.value, model),
								),
							);
						}),
					Expanded(
						child: ListView(
							shrinkWrap: true,
							children: [
								Padding(
								  padding: const EdgeInsets.symmetric(horizontal: 16),
								  child: Row(
								  	mainAxisAlignment: MainAxisAlignment.spaceBetween,
								  	crossAxisAlignment: CrossAxisAlignment.end,
								    children: [	
											showConfig ? configView : SizedBox(),
								  		showConfigButton
								    ],
								  ),
								),
								presetButtons,
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
									satControl,
									hueControl,
								]),
								controlRow(children: [
									thicknessControl,
									glowControl,
								]),
								controlRow(children: [
									waveControl,
									waveOffsetControl
								]),
								controlRow(children: [
									waveTrimControl,
									waveFadeControl,
								]),
								controlRow(children: [
									rotationControl(model.rotX, RotationType.X),
									rotationControl(model.rotY, RotationType.Y),
								]),
								controlRow(children: [
									rotationControl(model.rotZ, RotationType.Z),
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

	// MARK: - Controls
	Widget controlRow({required List<Widget> children})
	{
		return SizedBox(
			height: 80, 
			child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children));
	}

	Widget controlHeader(String title, double value, int precision)
	{
		return Padding(
		  padding: const EdgeInsets.symmetric(horizontal: 16),
		  child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
		  	Text(title, style: textStyle),
		  	const SizedBox(width: 5),
		  	Text(value.toStringAsFixed(precision), style: textStyle2)
		  ]),
		);
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
			controlHeader("Depth", model.depth, 2),
			Slider(
				value: model.depth, min: 0, max: 10,
				onChanged: (double value) { setState(() { model.depth = value; }); }
			),
		]);
	}

	Widget get scaleControl
	{
		return Column(children: [
			controlHeader("Scale", model.scale, 2),
			Slider(
				value: model.scale, min: 0.5, max: 10,
				onChanged: (double value) { setState(() { model.scale = value; }); }
			),
		]);
	}

	Widget get thicknessControl
	{
		return Column(children: [
			controlHeader("Thickness", model.thickness, 1),
			Slider(
				value: model.thickness, min: 1, max: 12,
				onChanged: (double value) { setState(() { model.thickness = value; }); }
			),
		]);
	}

	Widget get waveControl
	{
		return Column(children: [
			controlHeader("Waves", model.waves.toDouble(), 0),
			Slider(
				value: model.waves.toDouble(), divisions: model.maxWaves - 1, min: 1, max: model.maxWaves.toDouble(), 
				onChanged: (double value) { setState(() { model.waves = value.toInt(); }); }
			),
		]);
	}

	Widget get hueControl
	{
		return Column(children: [
			controlHeader("Color", model.hue, 0),
			Slider(
				value: model.hue, min: 0, max: 360, 
				onChanged: (double value) { setState(() { model.hue = value; }); }
			),
		]);
	}

	Widget get satControl
	{
		return Column(children: [
			controlHeader("Saturation", model.saturation, 1),
			Slider(
				value: model.saturation, min: 0, max: 1, 
				onChanged: (double value) { setState(() { model.saturation = value; }); }
			),
		]);
	}

	Widget get ampControl
	{
		return Column(children: [
			controlHeader("Amplitude", model.amplitude, 2),
			Slider(
				value: model.amplitude, min: 0.1, max: 1, 
				onChanged: (double value) { setState(() { model.amplitude = value; }); }
			),
		]);
	}

	Widget get densityControl
	{
		return Column(children: [
			controlHeader("Density", model.density, 1),
			Slider(
				value: model.density, min: 1, max: 5, 
				onChanged: (double value) { setState(() { model.density = value; }); }
			),
		]);
	}

	Widget get windowFractionControl
	{
		return Column(children: [
			controlHeader("Length", model.windowfraction, 1),
			Slider(
				value: model.windowfraction, min: 0.05, max: 1.0, 
				onChanged: (double value) { setState(() { model.windowfraction = value; }); }
			),
		]);
	}

	Widget get glowControl
	{
		return Column(children: [
			controlHeader("Glow", model.blur, 1),
			Slider(
				value: model.blur, min: 0.0, max: 10.0, 
				onChanged: (double value) { setState(() { model.blur = value; }); }
			),
		]);
	}

	Widget get speedControl
	{
		return Column(children: [
			controlHeader("Duration", model.duration.toDouble()/1000, 1),
			Slider(
				value: model.duration.toDouble(), min: 1000, max: 7000, 
				onChanged: (double value) { setState(() { 
					model.duration = value.toInt();
					controller.duration = Duration(milliseconds: value.toInt()); }); }
			),
		]);
	}

	Widget get waveOffsetControl
	{
		return Column(children: [
			controlHeader("WaveOffset", model.waveOffset.dx, 2),
			Slider(
				value: model.waveOffset.dx, min: 0.0, max: 10, 
				onChanged: (double value) { setState(() { model.waveOffset = Offset(value, model.waveOffset.dy); }); }
			),
		]);
	}

	Widget get waveTrimControl
	{
		return Column(children: [
			controlHeader("WaveTrim", model.waveTrim, 1),
			Slider(
				value: model.waveTrim, min: 0.0, max: 10, 
				onChanged: (double value) { setState(() { model.waveTrim = value; }); }
			),
		]);
	}

	Widget get waveFadeControl
	{
		return Column(children: [
			controlHeader("WaveFade", model.waveFadeFactor, 1),
			Slider(
				value: model.waveFadeFactor, min: 0.0, max: 1.0, 
				onChanged: (double value) { setState(() { model.waveFadeFactor = value; }); }
			),
		]);
	}

	Widget get playButton
	{
		return OutlinedButton(
		onPressed: () {
			setState(() {
				model.isPlaying ? controller.stop() : controller.forward();
				model.isPlaying = !model.isPlaying;
			});
		},
		child: Text(model.isPlaying ? "Animation Pause" : "Animation Start"),
		);
	}

	Widget get showConfigButton
	{
		return OutlinedButton(
		onPressed: () {
			setState(() {
				showConfig = !showConfig;
			});
		},
		child: Text(showConfig ? "Hide Config" : "Show Config"),
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
				model.transX = model.transX - 20;
			});
		},
		child: const Text("Left"),
		),
		OutlinedButton(
		onPressed: () {
			setState(() {
				model.transX = model.transX + 20;
			});
		},
		child: const Text("Right"),
		),
		OutlinedButton(
		onPressed: () {
			setState(() {
				model.transY = model.transY - 20;
			});
		},
		child: const Text("Up"),
		),
		OutlinedButton(
		onPressed: () {
			setState(() {
				model.transY = model.transY + 20;
			});
		},
		child: const Text("Down")
		)
		]);
	}

	Widget get presetButtons	
	{
		return Padding(
		  padding: const EdgeInsets.all(8),
		  child: Row(
		  	mainAxisAlignment: MainAxisAlignment.spaceBetween,
		  	children: [
		  		OutlinedButton(
		  			onPressed: () { setState(() { model = WaveCofigModel.simple; });},
		  			child: const Text("Simple"),
		  		),
		  		OutlinedButton(
		  			onPressed: () { setState(() { model = WaveCofigModel.adv1; });},
		  			child: const Text("Adv1"),
		  		),
		  		OutlinedButton(
		  			onPressed: () { setState(() { model = WaveCofigModel.adv2; });},
		  			child: const Text("Adv2"),
		  		),
		  		OutlinedButton(
		  			onPressed: () { setState(() { model = WaveCofigModel.advGradient; });},
		  			child: const Text("Gradient"),
		  		),
		  		OutlinedButton(
		  			onPressed: () { setState(() { model = WaveCofigModel.advRainbow; });},
		  			child: const Text("🌈"),
		  		),
		  	]),
		);
	}

	Widget get viewButtons
	{
		return Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				OutlinedButton(
					onPressed: () {
						setState(() {
							model.rotX = -0.42;
							model.rotY = -0.26;
							model.rotZ = -0.49;
							model.depth = 7.0;
							model.scale = 3.38;
							model.transX = 0;
							model.transY = 50;
						});
					},
					child: const Text("View1"),
				),
				OutlinedButton(
					onPressed: () {
						setState(() {
							model.scale = 5.0;
							model.rotX = -0.51;
							model.rotY = 0;
							model.rotZ = -1.16;
							model.transX = 0;
							model.transY = 200;
						});
					},
					child: const Text("View2"),
				),
				OutlinedButton(
					onPressed: () {
						setState(() {
							model.scale = 1;
							model.rotX = 0;
							model.rotY = 0;
							model.rotZ = 0;
							model.transX = 0;
							model.transY = 0;
						});
					},
					child: const Text("Reset View"),
				),
			],
		);
	}

	Widget get configView
	{
		return Text(
			model.toString(),
			style: textStyle3,
		);
	}

	void setRotation(double value, RotationType type)
	{
		setState(() {
			switch (type) {
				case RotationType.X:
					model.rotX = value;
					return;
				case RotationType.Y:
					model.rotY = value;
					return;
				case RotationType.Z:
					model.rotZ = value;
					return;
			}
		});
	}
}

import 'package:flutter/material.dart';
import 'package:waves/wave_painter2.dart';
import 'package:waves/wave_painter3.dart';
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
			home: const WaveDemo3(),
		);
	}
}	

class WaveDemo2 extends StatelessWidget {
	const WaveDemo2({Key? key}) : super(key: key);
	final double width = 350;

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				CustomPaint(
					size: Size(width, (width * 0.583)),
					painter: WavePainter2(),
				),
			],
		);
	}
}

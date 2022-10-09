import 'package:flutter/material.dart';
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

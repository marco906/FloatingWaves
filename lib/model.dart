import 'package:flutter/material.dart';

class WaveCofigModel
{
	bool isPlaying = true;
	int duration = 3000;
	double windowfraction = 0.6;

	double amplitude = 0.40;
	double density = 2.0;
	int waveGroups = 1;
	int waves = 15;
	double blur = 0.0;
	double thickness = 1.5;

	double waveTrim = 3.0;
	Offset waveOffset = const Offset(2.2, 0);
	Offset waveGroupOffset = const Offset(50, 0);
	double waveFadeFactor = 1.0;

	double hue = 234;
	double saturation = 1.0;
	LinearGradient? gradient;
	bool rainbow = false;

	double rotX = 0;
	double rotY = 0;
	double rotZ = 0;
	double depth = 7.0;
	double scale = 1;
	double transX = 0;
	double transY = 0;

	final int maxWaves = 20;

	String get description => this.toString();

	@override
  String toString() {
    // TODO: implement toString
    return 
			"""
			duration: ${(duration/1000).toStringAsFixed(1)}
			length: ${windowfraction.toStringAsFixed(2)}

			waves: $waves
			amplitude: ${amplitude.toStringAsFixed(2)}
			density: ${density.toStringAsFixed(2)}

			hue: ${hue.toStringAsFixed(0)}
			sat: ${saturation.toStringAsFixed(1)}
			gradient: ${gradient != null}
			rainbow: $rainbow

			thickness: ${thickness.toStringAsFixed(2)}
			glow: ${blur.toStringAsFixed(1)}

			waveOffset: ${waveOffset.toString()}
			waveFade: ${waveFadeFactor.toStringAsFixed(1)}
			waveTrim: ${waveTrim.toStringAsFixed(1)}

			rotation: ${rotX.toStringAsFixed(2)}, ${rotY.toStringAsFixed(2)}, ${rotZ.toStringAsFixed(2)}
			position: ${transX.toStringAsFixed(0)}, ${transY.toStringAsFixed(0)}
			scale: ${scale.toStringAsFixed(2)}
			depth: ${depth.toStringAsFixed(2)}
			""";
  }

	static WaveCofigModel get simple
	{
		final WaveCofigModel config = WaveCofigModel();
		config.amplitude = 0.30;
		config.density = 5.0;
		config.windowfraction = 0.4;
		config.waves = 1;
		config.thickness = 3;
		return config;
	}

	static WaveCofigModel get adv1
	{
		final WaveCofigModel config = WaveCofigModel();
		return config;
	}

	static WaveCofigModel get adv2
	{
		final WaveCofigModel config = WaveCofigModel();
		config.amplitude = 0.35;
		config.density = 3.4;
		config.windowfraction = 0.5;
		config.waves = 14;
		config.waveOffset = const Offset(1.85, 0);
		config.waveTrim = 1.7;
		config.waveFadeFactor = 0.6;
		return config;
	}

	static WaveCofigModel get advGradient
	{
		final WaveCofigModel config = WaveCofigModel();
		config.amplitude = 0.5;
		config.density = 1.8;
		config.windowfraction = 0.7;
		config.thickness = 2.0;
		config.blur = 0.53;
		config.waves = 19;
		config.waveOffset = const Offset(1.9, 0);
		config.waveTrim = 4.3;
		config.waveFadeFactor = 0.8;
		config.gradient = const LinearGradient(colors: [Colors.blue, Colors.blueAccent, Colors.purple, Colors.red]);
		return config;
	}

	static WaveCofigModel get advRainbow
	{
		final WaveCofigModel config = WaveCofigModel();
		config.amplitude = 0.5;
		config.density = 2.2;
		config.windowfraction = 0.5;
		config.thickness = 6.3;
		config.blur = 0.67;
		config.waves = 18;
		config.waveOffset = const Offset(2.4, 0);
		config.waveTrim = 1.5;
		config.waveFadeFactor = 0.9;
		config.rainbow= true;
		return config;
	}
	
	@override
	bool operator == (other) 
	{
		if(other is WaveCofigModel)
		{
			return description == other.description;
		}	
		return false;
	}


	@override
	int get hashCode 
	{
		return description.hashCode;
	}
}

enum RotationType
{
	X, Y, Z
}
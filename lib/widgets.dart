import 'dart:math';

import 'package:flutter/material.dart';
import 'package:waves/model.dart';

class WavePainter2 extends CustomPainter {
	final double time;
	final WaveCofigModel model;

	Color get modColor
	{
		const Color baseColor = Color.fromARGB(200, 33, 240, 243);
		final Color modhue = increaseColorHue(baseColor, model.hue);
		final Color modSat = increaseColorSat(modhue, model.saturation);
		return modSat;
	}

	WavePainter2(this.time, this.model);

	@override
	void paint(Canvas canvas, Size size) {

		Paint paint0 = Paint()
			//..color = modColor
			..style = PaintingStyle.stroke
			..strokeCap = StrokeCap.round
			..strokeWidth = model.thickness
			..maskFilter = MaskFilter.blur(BlurStyle.solid, model.blur)
			..shader = model.rainbow ? null : model.gradient?.createShader(Rect.fromCircle(center: Offset(size.width / 2, size.width / 2), radius: size.width / 2))
			..blendMode = BlendMode.screen;
			

		final rotationMatrix = Matrix4.identity()
			..rotateX(model.rotX)
			..rotateY(model.rotY)
			..rotateZ(model.rotZ)
			..scale(model.scale);

		final depthMatrix = Matrix4.identity()
			..setEntry(3, 0, 0.000)
			..setEntry(3, 1, 0.000)
			..setEntry(3, 2, model.depth / 1000);

		void drawWaveGroup(Canvas canvas)
		{
			for (var w = 0; w < model.waves; w++)
			{
				
				final double offsetx = model.waveOffset.dx * w;
				final double waveTrim = model.waveTrim * w;
				final double fadeValue = w / model.waves;
				final Path path = createWavePath(size, w, waveTrim, offsetx);

				final Color waveColor = modColor.withAlpha(modColor.alpha - (modColor.alpha * fadeValue * model.waveFadeFactor).toInt());
				Paint wavePaint = paint0;
				wavePaint.color = waveColor;

				// rainbow
				if (model.rainbow)
				{
					final double hueOffset = w / model.waves * 360;
					final Color rainbowColor = increaseColorHue(waveColor, hueOffset);
					wavePaint.color = rainbowColor;
				}

				canvas.drawPath(path, wavePaint);
			}
		}

		// transform canvas space
		canvas.translate(model.transX, model.transY);
		canvas.transform(depthMatrix.storage);
		canvas.transform(rotationMatrix.storage);

		drawWaveGroup(canvas);
	}

	@override
	bool shouldRepaint(covariant WavePainter2 oldDelegate)
	{
		return (oldDelegate.time != time || oldDelegate.model != model);
	}

	Color increaseColorHue(Color color, double increment) 
	{
		var hslColor = HSLColor.fromColor(color);
		var newValue = min(max(hslColor.lightness + increment, 0.0), 360.0);
		return hslColor.withHue(newValue).toColor();
	}

	Color increaseColorSat(Color color, double value) 
	{
		var hslColor = HSLColor.fromColor(color);
		return hslColor.withSaturation(value).toColor();
	}

	// create path
	double yValue(double xFraction, Size size, int index)
	{
		final density = model.density;
		const omega = 2 * pi;
		final double amp = size.height * 0.5 * model.amplitude;
		final double variation = 1 - index * 0.1;
		return sin(xFraction * omega * density) * amp * variation;
	}

	Path createWavePath(Size size, int index, double windowTrim, double waveOffset) 
	{
		final width = size.width;
		final double windowWidth = width * model.windowfraction;
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
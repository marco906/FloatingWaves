import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class WavePainter2 extends CustomPainter{
	
	@override
	void paint(Canvas canvas, Size size) {

	Paint paint0 = Paint()
		//..color = Color.fromARGB(80, 255, 255, 255)
		..style = PaintingStyle.stroke
		..strokeWidth = 18;

	paint0.shader = ui.Gradient.linear(Offset(0,size.height*0.87),Offset(size.width*1.03,size.height*0.03),[Color.fromARGB(0, 255, 255, 255),Color.fromARGB(90, 249, 249, 249), Color.fromARGB(0, 255, 255, 255)],[0.0, 0.5, 1.0]); 
		 
				 
	Path path0 = Path();
	path0.moveTo(0,size.height*0.4342857);
	path0.quadraticBezierTo(size.width*0.1610417,size.height*0.3142857,size.width*0.5025000,size.height*0.5814286);
	path0.cubicTo(size.width*0.6981250,size.height*0.7278571,size.width*0.8443750,size.height*0.8992857,size.width*0.9000000,size.height*0.7971429);
	path0.cubicTo(size.width*0.9491667,size.height*0.7139286,size.width*0.8510417,size.height*0.5689286,size.width*0.7583333,size.height*0.4042857);
	path0.cubicTo(size.width*0.6654167,size.height*0.2478571,size.width*0.6062500,size.height*0.1917857,size.width*0.6316667,size.height*0.1257143);
	path0.cubicTo(size.width*0.6589583,size.height*0.0596429,size.width*0.7610417,size.height*0.2085714,size.width*0.8283333,size.height*0.2785714);
	path0.cubicTo(size.width*0.8991667,size.height*0.3542857,size.width*0.9475000,size.height*0.4228571,size.width*0.9741667,size.height*0.3742857);
	path0.cubicTo(size.width*0.9943750,size.height*0.3357143,size.width*0.8860417,size.height*0.2017857,size.width*0.8566667,size.height*0.1442857);
	//path0.quadraticBezierTo(size.width*0.6425000,size.height*0.2167857,0,size.height*0.4342857);

	canvas.drawPath(path0, paint0);


	const double shift = 4;

	final path1 = path0.shift(Offset(shift, shift));
	final path2 = path0.shift(Offset(shift, -shift));
	final path3 = path0.shift(Offset(-shift, shift));
	final path4 = path0.shift(Offset(-shift, -shift));
	final path5 = path0.shift(Offset(0, shift));
	final path6 = path0.shift(Offset(0, -shift));
	
	canvas.drawPath(path1, paint0);
	canvas.drawPath(path2, paint0);
	canvas.drawPath(path3, paint0);
	canvas.drawPath(path4, paint0);
	canvas.drawPath(path5, paint0);
	canvas.drawPath(path6, paint0);
		
	}

	@override
	bool shouldRepaint(covariant CustomPainter oldDelegate) {
		return true;
	}
	
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class PointWidget extends StatefulWidget {
  const PointWidget({Key? key}) : super(key: key);

  @override
  State<PointWidget> createState() => _PointWidgetState();
}

class _PointWidgetState extends State<PointWidget> {
  late Timer timer;
  final List<Dot> dots = List.generate(100*3, (index) => Dot()).toList();

  @override
  void initState() {
    const d = Duration(milliseconds: 600~/60 );
    timer = Timer.periodic(d, (timer) {
      setState(() {
        for (var dot in dots) {
          final dx = dot.position.dx - dot.dx;
          final dy = dot.position.dy - dot.dy;
          dot.position = Offset(dx, dy);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: CustomPaint(
        painter: MyAnim(dots: dots),
        child: Container(),
      ),
    );
  }
}

class MyAnim extends CustomPainter {
  MyAnim({required this.dots});
  List<Dot> dots;
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    const r = 100.0;
    final p = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(c, r, p);
    
    for (var d in dots) {
      canvas.drawCircle(d.position, d.radius, Paint()..style = PaintingStyle.fill..color = d.color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Dot {
  Dot() {
    radius = [3, 10].range;
    color = colors[[0, colors.length].range.toInt()];
    position = Offset([0, 400].range, [0, 500].range);
    dx = [-0.1, 0.1].range;
    dy = [-0.1, 0.1].range;
  }
  late double radius;
  late Color color;
  late Offset position;
  late double dx, dy;
}

final random = Random();

final colors = [
  Colors.amber,
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.grey,
  Colors.greenAccent,
  Colors.orange,
  Colors.black,
];

extension RandomOnList on List<num> {
  double get range =>
      random.nextDouble() * (max(first, last) - min(first, last)) +
      min(first, last);
}

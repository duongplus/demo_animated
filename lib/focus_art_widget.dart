import 'dart:math';

import 'package:demo_animated_widget/point_widget.dart';
import 'package:flutter/material.dart';

class FocusArtWidget extends StatefulWidget {
  const FocusArtWidget({Key? key}) : super(key: key);

  @override
  State<FocusArtWidget> createState() => _FocusArtWidgetState();
}

class _FocusArtWidgetState extends State<FocusArtWidget>
    with SingleTickerProviderStateMixin {
  final List<Dot> dots = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    const d = Duration(seconds: 10);
    _controller = AnimationController(vsync: this, duration: d);
    _animation = Tween<double>(begin: 0, end: 300).animate(_controller)
      ..addListener(() {
        if (dots.isEmpty) {
          _create();
        } else {}
      })
      ..addStatusListener((status) {});
    _controller.forward();
    super.initState();
  }

  _create() {
    final size = MediaQuery.of(context).size;
    final o = Offset(size.width / 2, size.height / 2);
    const n = 5;
    final r = size.width / n ;
    const a = 0.2;
    field(r, n, a, o);
  }

  field(double r, int n, double a, Offset o) {
    if (r < 10) return;
    dots.add(Dot()
      ..radius = r / n
      ..position = o
      ..color = Colors.black);

    var theta = 0.0;
    var dTheta = 2 * pi / n;
    for (var i = 0; i < n; i++) {
      var pos = [r, theta].polar + o;
      dots.add(Dot()
        ..radius = r / n
        ..position = pos
        ..color = Colors.black);
      theta += dTheta;
      field(r / 2, n, a * 1.5, pos);
    }
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
  final List<Dot> dots;
  MyAnim({required this.dots});
  @override
  void paint(Canvas canvas, Size size) {
    dots.forEach((d) {
      var paint = Paint()..color = d.color;
      canvas.drawCircle(d.position, d.radius, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
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

extension RandomOnList1 on List<double> {
  double get range =>
      random.nextDouble() * (max(first, last) - min(first, last)) +
      min(first, last);

  Offset get polar => Offset(first * cos(last), first * sin(last));
}

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: GraphArea(),
      ),
    );
  }
}

class GraphArea extends StatefulWidget {
  const GraphArea({super.key});

  @override
  State<GraphArea> createState() => _GraphAreaState();
}

class _GraphAreaState extends State<GraphArea>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<DataPoint> data = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    _animationController.forward();
    _loadStepsData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadStepsData() async {
    final prefs = await SharedPreferences.getInstance();
    List<DataPoint> loadedData = [];
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime day = today.subtract(Duration(days: i));
      String dateKey = '${day.year}-${day.month}-${day.day}';
      int steps = prefs.getInt(dateKey) ?? 0; // Default to 0 if no data
      loadedData.add(DataPoint(day: 7 - i, steps: steps));
    }

    setState(() {
      data = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController.forward(from: 0.0);
      },
      child: CustomPaint(
        painter: GraphPainter(_animationController.view, data: data),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<DataPoint> data;
  final Animation<double> _size;
  final Animation<double> _dotSize;

  GraphPainter(Animation<double> animation, {required this.data})
      : _size = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(0.0, 0.75, curve: Curves.easeInOutCubicEmphasized),
          ),
        ),
        _dotSize = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(0.75, 1, curve: Curves.easeInOutCubicEmphasized),
          ),
        ),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    var xSpacing = size.width / (data.length - 1);

    // Prevent division by zero
    var maxSteps = data
        .fold<DataPoint>(
          data[0],
          (p, c) => p.steps > c.steps ? p : c,
        )
        .steps;
    if (maxSteps == 0) maxSteps = 1; // Avoid division by zero

    var yRatio = size.height / maxSteps;
    var curveOffset = xSpacing * 0.3;

    List<Offset> offsets = [];
    var cx = 0.0;
    for (int i = 0; i < data.length; i++) {
      var y = size.height - (data[i].steps * yRatio * _size.value);
      offsets.add(Offset(cx, y));
      cx += xSpacing;
    }

    Paint linePaint = Paint()
      ..color = Color(0xff30c3f9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Paint shadowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.solid, 3)
      ..strokeWidth = 3.0;

    Paint fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [
          Color(0xff30c3f9),
          Colors.white,
        ],
      )
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Paint dotOutlinePaint = Paint()
      ..color = Colors.white.withAlpha(200)
      ..strokeWidth = 8;

    Paint dotCenter = Paint()
      ..color = Color(0xff30c3f9)
      ..strokeWidth = 8;

    Path linePath = Path();
    Offset cOffset = offsets[0];
    linePath.moveTo(cOffset.dx, cOffset.dy);

    for (int i = 1; i < offsets.length; i++) {
      var x = offsets[i].dx;
      var y = offsets[i].dy;
      var c1x = cOffset.dx + curveOffset;
      var c1y = cOffset.dy;
      var c2x = x - curveOffset;
      var c2y = y;

      linePath.cubicTo(c1x, c1y, c2x, c2y, x, y);
      cOffset = offsets[i];
    }

    Path fillPath = Path.from(linePath);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, shadowPaint);
    canvas.drawPath(linePath, linePaint);

    for (var offset in offsets) {
      canvas.drawCircle(offset, 15 * _dotSize.value, dotOutlinePaint);
      canvas.drawCircle(offset, 6 * _dotSize.value, dotCenter);
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return data != oldDelegate.data;
  }
}

class DataPoint {
  final int day;
  final int steps;

  DataPoint({
    required this.day,
    required this.steps,
  });
}

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'dart:math';

const CURVE_HEIGHT = 270.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
Color kpColor = const Color(0xff3625ad);

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isShowingBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildContent(),
          const CurvedShape(),
          CupertinoButton(
            onPressed: () {
              setState(() {
                _isShowingBox = !_isShowingBox;
              });
            },
            padding: EdgeInsets.zero,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: _isShowingBox
                  ? Container(
                      margin: const EdgeInsets.only(
                        top: CURVE_HEIGHT - AVATAR_DIAMETER + 20,
                      ),
                      width: double.infinity,
                      height: AVATAR_DIAMETER,
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffecf2f7),
                        ),
                        child: const Icon(
                          Icons.mood_bad,
                          color: Colors.red,
                          size: AVATAR_RADIUS,
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(
                          top: CURVE_HEIGHT - AVATAR_DIAMETER),
                      width: double.infinity,
                      height: AVATAR_DIAMETER,
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffecf2f7),
                        ),
                        child: const Icon(
                          Icons.mood,
                          color: Colors.green,
                          size: AVATAR_RADIUS,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, CURVE_HEIGHT, 16, 16),
      child: OverflowBar(
        overflowSpacing: 20,
        children: [
          const TextInput(
            hintText: 'Username',
          ),
          const TextInput(
            hintText: 'Email',
          ),
          const TextInput(
            hintText: 'Password',
          ),
          const TextInput(
            hintText: 'Confirm password',
          ),
          SizedBox(
            height: 55,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: kpColor),
              child: const Center(
                child: Text(
                  "Update",
                  style: TextStyle(fontSize: 23),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedShape extends StatelessWidget {
  const CurvedShape({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: CURVE_HEIGHT,
      child: CustomPaint(
        painter: _MyPainter(),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = kpColor;
    // const Color(0xfffbb500);

    Offset circleCenter = Offset(size.width / 2, size.height - AVATAR_RADIUS);

    Offset topLeft = const Offset(0, 0);
    Offset bottomLeft = Offset(0, size.height * 0.25);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, size.height * 0.5);

    Offset leftCurveControlPoint =
        Offset(circleCenter.dx * 0.5, size.height - AVATAR_RADIUS * 1.5);
    Offset rightCurveControlPoint =
        Offset(circleCenter.dx * 1.6, size.height - AVATAR_RADIUS);

    const arcStartAngle = 200 / 180 * pi;
    final avatarLeftPointX =
        circleCenter.dx + AVATAR_RADIUS * cos(arcStartAngle);
    final avatarLeftPointY =
        circleCenter.dy + AVATAR_RADIUS * sin(arcStartAngle);
    Offset avatarLeftPoint =
        Offset(avatarLeftPointX, avatarLeftPointY); // the left point of the arc

    const arcEndAngle = -5 / 180 * pi;
    final avatarRightPointX =
        circleCenter.dx + AVATAR_RADIUS * cos(arcEndAngle);
    final avatarRightPointY =
        circleCenter.dy + AVATAR_RADIUS * sin(arcEndAngle);
    Offset avatarRightPoint = Offset(
        avatarRightPointX, avatarRightPointY); // the right point of the arc

    Path path = Path()
      ..moveTo(topLeft.dx,
          topLeft.dy) // this move isn't required since the start point is (0,0)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(leftCurveControlPoint.dx, leftCurveControlPoint.dy,
          avatarLeftPoint.dx, avatarLeftPoint.dy)
      ..arcToPoint(avatarRightPoint,
          radius: const Radius.circular(AVATAR_RADIUS))
      ..quadraticBezierTo(rightCurveControlPoint.dx, rightCurveControlPoint.dy,
          bottomRight.dx, bottomRight.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TextInput extends StatelessWidget {
  final String hintText;
  const TextInput({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            letterSpacing: 2,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.white30,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

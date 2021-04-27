import 'package:app/app_properties.dart';
import 'package:app/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ReceivePaymentPage extends StatelessWidget {
  static Route route({int id}) {
    return MaterialPageRoute<void>(builder: (_) => ReceivePaymentPage(id: id));
  }

  final int id;

  const ReceivePaymentPage({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user;
    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        title: AutoSizeText(
          'Receive Payment',
          style: TextStyle(color: darkGrey),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
                margin: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CustomPaint(
                    painter: TicketPainter(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/icons/QR_code.png'),
                          ),
                          AutoSizeText('asdfghjklqwertyuioxcvbnm,'),
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                AutoSizeText(
                                  '\$',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                AutoSizeText('54.24',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  maxRadius: 24,
                                  // backgroundImage:
                                  // NetworkImage(user.picture.thumbnail),
                                ),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AutoSizeText(
                                      user.name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    AutoSizeText("",
                                        // user.partner.phone,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                AutoSizeText('Retry Again with new',
                    style: TextStyle(color: Colors.white)),
                SizedBox(
                  width: 8.0,
                ),
                InkWell(
                    onTap: () {},
                    child: AutoSizeText(
                      'QR code',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    final rectLeft = Rect.fromLTWH(-15, height / 2, 30, 30);
    final startAngleLeft = -math.pi / 2;
    final sweepAngleLeft = math.pi;
    final rectRight = Rect.fromLTWH(width - 15, height / 2, 30, 30);
    final startAngleRight = math.pi / 2;
    final sweepAngleRight = math.pi;
    Path path = Path();
    path.moveTo(0, 0);
    path.arcTo(rectLeft, startAngleLeft, sweepAngleLeft, false);
    path.lineTo(0, height);
    path.lineTo(width, height);
    path.arcTo(rectRight, startAngleRight, sweepAngleRight, false);
    path.lineTo(width, 0);
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

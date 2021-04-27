import 'package:app/app_properties.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/payment_history_page.dart';
import 'package:app/screens/request_money/request_amount_page.dart';
import 'package:app/screens/request_money/request_page.dart';
import 'package:app/screens/send_money/send_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => WalletPage());
  }

  const WalletPage({Key key}) : super(key: key);
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  AnimationController animController;
  Animation<double> openOptions;

  List<User> users = [];

  getUsers() async {
    // var temp = await ApiService.getUsers(nrUsers: 5);
    // setState(() {
    //   users = temp;
    // });
  }

  @override
  void initState() {
    animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    openOptions = Tween(begin: 0.0, end: 300.0).animate(animController);
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      child: SafeArea(
        child: LayoutBuilder(
          builder: (builder, constraints) => SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                        alignment: Alignment(1, 0),
                        child: SizedBox(
                          height: kTextTabBarHeight,
                          child: IconButton(
                            onPressed: () => Navigator.of(context)
                                .push(PaymentHistoryPage.route()),
                            icon: SvgPicture.asset(
                              'assets/icons/reload_icon.svg',
                              color: Colors.red,
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AutoSizeText(
                          'Payment',
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CloseButton()
                      ],
                    ),
                  ),
                  AutoSizeText('Current account balance'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                  SizedBox(
                    height: 100,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: openOptions.value,
                            height: 80,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45)),
                                border: Border.all(color: yellow, width: 1.5)),
                            child: openOptions.value < 300
                                ? Container()
                                : Align(
                                    alignment: Alignment(0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                            onTap: () => Navigator.of(context)
                                                .push(SendPage.route()),
                                            child: AutoSizeText('Pay')),
                                        InkWell(
                                            onTap: () => Navigator.of(context)
                                                .push(RequestPage.route()),
                                            child: AutoSizeText('Request')),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        Center(
                            child: CustomPaint(
                                painter: YellowDollarButton(),
                                child: GestureDetector(
                                  onTap: () {
                                    animController.addListener(() {
                                      setState(() {});
                                    });
                                    if (openOptions.value == 300)
                                      animController.reverse();
                                    else
                                      animController.forward();
                                  },
                                  child: Container(
                                      width: 110,
                                      height: 110,
                                      child: Center(
                                          child: AutoSizeText('\$',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 32)))),
                                )))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AutoSizeText(
                        openOptions.value > 0 ? '' : 'Tap to pay / request',
                        style: TextStyle(fontSize: 10)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText('Quick Money Request'),
                  ),
                  Flexible(
                      child: Center(
                    child: users.length == 0
                        ? CupertinoActivityIndicator()
                        : Container(
                            height: 150,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Icon(Icons.add),
                                      ),
                                    ),
                                  ),
                                  ...users
                                      .map((user) => InkWell(
                                            onTap: () => Navigator.of(context)
                                                .push(
                                                    RequestAmountPage.route()),
                                            child: Container(
                                                width: 100,
                                                height: 200,
                                                margin: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      maxRadius: 24,
                                                      // backgroundImage:
                                                      //     NetworkImage(user
                                                      //         .picture
                                                      //         .thumbnail),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          4.0, 16.0, 4.0, 0.0),
                                                      child: AutoSizeText(
                                                          user.name,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: AutoSizeText(
                                                        "",
                                                        // user.partner.phone,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ))
                                      .toList(),
                                ]),
                          ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText('Hot Deals'),
                  ),
                  Flexible(
                    child: Container(
                      height: 232,
                      color: Color(0xffFAF1E2),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (_, index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          width: 140,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Icon(Icons.tab),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: AutoSizeText('Dicount Voucher',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: AutoSizeText(
                                    '10% off on any pizzahut products',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class YellowDollarButton extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;

    canvas.drawCircle(Offset(width / 2, height / 2), height / 2,
        Paint()..color = Color.fromRGBO(253, 184, 70, 0.2));
    canvas.drawCircle(Offset(width / 2, height / 2), height / 2 - 4,
        Paint()..color = Color.fromRGBO(253, 184, 70, 0.5));
    canvas.drawCircle(Offset(width / 2, height / 2), height / 2 - 12,
        Paint()..color = Color.fromRGBO(253, 184, 70, 1));
    canvas.drawCircle(Offset(width / 2, height / 2), height / 2 - 16,
        Paint()..color = Color.fromRGBO(255, 255, 255, 0.1));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

import 'package:app/app_properties.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/request_money/receive_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RequestAmountPage extends StatelessWidget {
  static Route route({int id}) {
    return MaterialPageRoute<void>(builder: (_) => RequestAmountPage(id: id));
  }

  final int id;

  const RequestAmountPage({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user;
    // double width = MediaQuery.of(context).size.width;
    Widget viewProductButton = InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 60,
        // width: width / 1.5,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: AutoSizeText("Request Now",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0)),
        ),
      ),
    );

    Widget qrCode = InkWell(
      onTap: () =>
          Navigator.of(context).push(ReceivePaymentPage.route(id: user.id)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 60,
        // width: width / 1.5,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: AutoSizeText("QR Code",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0)),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          title: AutoSizeText(
            'Request Amount',
            style: TextStyle(color: darkGrey),
          ),
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
//                mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 2.3,
                      padding: const EdgeInsets.all(16.0),
                      width: MediaQuery.of(context).size.width,
                      color: yellow,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CircleAvatar(
                                  maxRadius: 24,
                                  // backgroundImage:
                                  //     NetworkImage(user.picture.thumbnail),
                                ),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AutoSizeText(
                                      user.name,
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    AutoSizeText("",
                                        // user.partner.phone,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white30)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          AutoSizeText('Enter Amount You want to Request',
                              style: TextStyle(color: Colors.white)),
                          SizedBox(
                              width: 250,
                              child: Theme(
                                data: ThemeData(
                                    primaryColor: Colors.white,
                                    fontFamily: 'Montserrat'),
                                child: TextField(
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 48),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '\$ 00.00',
                                    hintStyle: TextStyle(
                                        color: Colors.white30, fontSize: 48),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )),
                          AutoSizeText('You can only send \$54.24',
                              style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: AutoSizeText('Payment History'),
                    ),
                    Flexible(
                        child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: AutoSizeText('24th December 2018',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold)),
                          subtitle: AutoSizeText('Received'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                '\$ ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              AutoSizeText(
                                '90.00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText('24th December 2018',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold)),
                          subtitle: AutoSizeText('Received'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                '\$ ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              AutoSizeText(
                                '90.00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText('24th December 2018',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold)),
                          subtitle: AutoSizeText('Received'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                '\$ ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              AutoSizeText(
                                '90.00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText('24th December 2018',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold)),
                          subtitle: AutoSizeText('Received'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                '\$ ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              AutoSizeText(
                                '90.00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText('24th December 2018',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold)),
                          subtitle: AutoSizeText('Received'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                '\$ ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                              AutoSizeText(
                                '90.00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(child: viewProductButton),
                          SizedBox(width: 16.0),
                          Expanded(child: qrCode)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

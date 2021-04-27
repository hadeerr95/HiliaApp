import 'package:app/models/models.dart';
import 'package:app/screens/send_money/quick_send_amount_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_properties.dart';

class SendPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SendPage());
  }

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  List<User> frequentUsers = [];
  List<User> users = [];

  getFrequentUsers() async {
    // var temp = await ApiService.getUsers(nrUsers: 5);
    // setState(() {
    //   frequentUsers = temp;
    // });
  }

  getUsers() async {
    // var temp = await ApiService.getUsers(nrUsers: 5);
    // setState(() {
    //   users = temp;
    // });
  }

  @override
  void initState() {
    super.initState();
    getFrequentUsers();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        title: AutoSizeText(
          'Send Amount',
          style: TextStyle(color: darkGrey),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.orange, width: 1))),
              child: TextField(
                cursorColor: darkGrey,
                decoration: InputDecoration(
                    hintText: 'Search',
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    prefixIcon: SvgPicture.asset(
                      'assets/icons/search_icon.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    suffix: FlatButton(
                        onPressed: () {
                          // searchController.clear();
                          // searchResults.clear();
                        },
                        child: AutoSizeText(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
              child: AutoSizeText('Frequent Contacts'),
            ),
            Expanded(
                child: Center(
              child: Container(
                height: 150,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                  child: frequentUsers.length == 0
                      ? CupertinoActivityIndicator()
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: frequentUsers
                              .map((user) => InkWell(
                                    onTap: () => Navigator.of(context).push(
                                        QuickSendAmountPage.route(id: user.id)),
                                    child: Container(
                                        width: 100,
                                        height: 200,
                                        margin: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              maxRadius: 24,
                                              // backgroundImage: NetworkImage(
                                              //     user.picture.thumbnail),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4.0, 16.0, 4.0, 0.0),
                                              child: AutoSizeText(user.name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: AutoSizeText(
                                                "",
                                                // user.partner.phone,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ))
                              .toList(),
                        ),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: AutoSizeText('Your Contacts'),
            ),
            Expanded(
                flex: 2,
                child: Center(
                  child: users.length == 0
                      ? CupertinoActivityIndicator()
                      : Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: ListView(
                            children: users
                                .map((user) => InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          QuickSendAmountPage.route(
                                              id: user.id)),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0),
                                                child: CircleAvatar(
                                                  maxRadius: 24,
                                                  // backgroundImage: NetworkImage(
                                                  //     user.picture.thumbnail),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 16.0),
                                                    child: AutoSizeText(
                                                        user.name,
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 16.0),
                                                    child: AutoSizeText(
                                                      "",
                                                      // user.partner.phone,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              AutoSizeText(
                                                'Send as a gift',
                                                style:
                                                    TextStyle(fontSize: 10.0),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 64.0),
                                            child: Divider(),
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:app/app_properties.dart';
import 'package:app/screens/address/address_form.dart';
import 'package:app/screens/select_card_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AddAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget finishButton = InkWell(
      onTap: () => Navigator.of(context).push(SelectCardPage.route()),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 1.5,
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
          child: AutoSizeText("finish".tr(),
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        title: AutoSizeText(
          'Add Address',
          style: const TextStyle(
              color: darkGrey,
              fontWeight: FontWeight.w500,
              fontFamily: "Montserrat",
              fontSize: 18.0),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AddAddressCard(),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  HomeAddressCard(),
                                  WorkAddressCard(),
                                  HomeAddressCard(),
                                  WorkAddressCard(),
                                  HomeAddressCard(),
                                  WorkAddressCard(),
                                ],
                              )))
                    ],
                  ),
                  AddAddressForm(),
                  Center(child: finishButton)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddAddressCard extends StatelessWidget {
  const AddAddressCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      elevation: 3,
      child: SizedBox(
        height: 100,
        width: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset('assets/icons/address_home.png'),
              ),
              AutoSizeText(
                'add_new_address'.tr(),
                style: TextStyle(
                  fontSize: 8,
                  color: darkGrey,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WorkAddressCard extends StatelessWidget {
  const WorkAddressCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: yellow,
      elevation: 3,
      child: SizedBox(
        height: 80,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset('assets/icons/address_work.png',
                    color: Colors.white, height: 20),
              ),
              AutoSizeText(
                'workplace'.tr(),
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeAddressCard extends StatelessWidget {
  const HomeAddressCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      color: yellow,
      elevation: 3,
      child: SizedBox(
        height: 80,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  'assets/icons/address_home.png',
                  color: Colors.white,
                  height: 20,
                ),
              ),
              AutoSizeText(
                'Simon Philip,\nCity Oscarlad',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:app/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'address_form.dart';

class AddressDialog extends StatelessWidget {
  final Partner partner;
  final String title;

  const AddressDialog({Key key, this.partner, this.title = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.grey[50]),
        padding: EdgeInsets.all(24.0),
        child: AddressForm(
          title: AutoSizeText(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          partner: partner,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

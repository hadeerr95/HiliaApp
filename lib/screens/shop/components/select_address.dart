import 'package:app/app_properties.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/components.dart';
import 'package:app/screens/components/widget.dart';
import 'package:app/screens/contact/address_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectAddress extends StatelessWidget {
  final SaleOrder order;
  final Function(SaleOrder) updateOrder;

  const SelectAddress(
      {Key key, @required this.order, @required this.updateOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              "billing_address".tr(),
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: yellow),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
              return BaseContact(
                partner: order.partner,
                header: ButtonBar(
                  children: [EditAddressButton(partner: state.user?.partner)],
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    "shipping_address".tr(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: yellow),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: Dialog(
                          shape: BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: AddressDialog(
                            partner: Partner(
                                parent:
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .state
                                        .user
                                        .partner),
                          ),
                        ));
                  },
                  child: AutoSizeText("add_a_shipping_address".tr()),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Partner>[
                    state.user?.partner,
                    ...state.user.partner.contacts
                  ]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ShippingAddress(
                            partner: e,
                            isSelected: order.partnerShipping.id == e?.id,
                            onSelect: (p) {
                              updateOrder(SaleOrder(partnerShipping: p));
                            },
                          ),
                        ),
                      )
                      ?.toList(),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}

class ShippingAddress extends StatelessWidget {
  final Partner partner;
  final bool isSelected;
  final Function(Partner) onSelect;
  const ShippingAddress({
    Key key,
    @required this.partner,
    this.isSelected = false,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onSelect != null) onSelect(partner);
      },
      child: BaseContact(
        partner: partner,
        header: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [EditAddressButton(partner: partner)],
        ),
        footer: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white12,
          ),
          child: isSelected
              ? RaisedButton(
                  onPressed: () {
                    if (onSelect != null) onSelect(partner);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      AutoSizeText(
                        "ship_to_this_address".tr(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  color: Colors.blue,
                )
              : RaisedButton(
                  onPressed: () {
                    if (onSelect != null) onSelect(partner);
                  },
                  child: AutoSizeText("select_this_address".tr()),
                ),
        ),
      ),
    );
  }
}

import 'package:app/app_properties.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/shop/check_out_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'shop_product.dart';

class ShopBottomSheet extends StatefulWidget {
  @override
  _ShopBottomSheetState createState() => _ShopBottomSheetState();
}

class _ShopBottomSheetState extends State<ShopBottomSheet> {
  @override
  Widget build(BuildContext context) {
    Widget confirmButton = InkWell(
      onTap: () async {
        Navigator.of(context)
          ..pop()
          ..pop()
          ..push(CheckOutPage.route());
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: EdgeInsets.symmetric(vertical: 20.0),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom == 0
                ? 20
                : MediaQuery.of(context).padding.bottom),
        child: Center(
            child: new AutoSizeText("confirm".tr(),
                style: const TextStyle(
                    color: const Color(0xfffefefe),
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0))),
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
      ),
    );

    return Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.9),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24), topLeft: Radius.circular(24))),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Image.asset(
                  'assets/box.png',
                  height: 24,
                  width: 24.0,
                  fit: BoxFit.cover,
                ),
                onPressed: () {},
                iconSize: 48,
              ),
            ),
            SizedBox(
              height: 300,
              child: BlocBuilder<CatalogCubit, CatalogState>(
                  builder: (context, state) {
                if (state.cartState.status == LoaderStatus.loaded) {
                  List<Variant> variants =
                      BlocProvider.of<CatalogCubit>(context).state.getVariants(
                          state.cartState.data
                              .map((e) => e.variantId)
                              .toList());
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: variants
                        .map((e) => Row(
                              children: <Widget>[
                                ShopProduct(
                                  e,
                                  onRemove: () {
                                    setState(() {
                                      context
                                          .bloc<CatalogCubit>()
                                          .removeItemFromCart(e.id);
                                    });
                                  },
                                ),
                              ],
                            ))
                        .toList(),
                  );
                }
                return Container();
              }),
            ),
            confirmButton
          ],
        ));
  }
}

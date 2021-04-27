import 'package:app/app_properties.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/shop/check_out_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'shop_bottomSheet.dart';

class ProductOption extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Variant variant;
  const ProductOption(this.scaffoldKey, {Key key, this.variant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 200,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: isArabicLang(context) ? 16.0 : null,
              left: isArabicLang(context) ? null : 16.0,
              child:
                  // variant?.imageWidget(
                  //       fit: BoxFit.contain,
                  //       height: 200,
                  //       width: 200,
                  //     ) ??
                  Container(),
            ),
            Positioned(
              left: isArabicLang(context) ? 0.0 : null,
              right: isArabicLang(context) ? null : 0.0,
              child: Container(
                height: 180,
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AutoSizeText("${variant?.name ?? ""}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              shadows: shadow)),
                    ),
                    InkWell(
                      onTap: () async {
                        // BlocProvider.of<UserCubit>(context)
                        //     .addItemToCart(SaleOrderLine(
                        //   // variantId: variant.id,
                        //   priceUnit: variant.lstPrice,
                        //   productsQty: 1,
                        // ));
                        Navigator.of(context).push(CheckOutPage.route());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            gradient: mainButton,
                            borderRadius: BorderRadius.only(
                                bottomLeft: isArabicLang(context)
                                    ? Radius.zero
                                    : Radius.circular(10.0),
                                topLeft: isArabicLang(context)
                                    ? Radius.zero
                                    : Radius.circular(10.0),
                                topRight: isArabicLang(context)
                                    ? Radius.circular(10.0)
                                    : Radius.zero,
                                bottomRight: isArabicLang(context)
                                    ? Radius.circular(10.0)
                                    : Radius.zero)),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: AutoSizeText(
                            'Buy Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // BlocProvider.of<UserCubit>(context)
                        //     .addItemToCart(SaleOrderLine(
                        //   // variantId: variant.id,
                        //   priceUnit: variant.lstPrice,
                        //   productsQty: 1,
                        // ));
                        scaffoldKey.currentState.showBottomSheet((context) {
                          return ShopBottomSheet();
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            gradient: mainButton,
                            borderRadius: BorderRadius.only(
                                bottomLeft: isArabicLang(context)
                                    ? Radius.zero
                                    : Radius.circular(10.0),
                                topLeft: isArabicLang(context)
                                    ? Radius.zero
                                    : Radius.circular(10.0),
                                topRight: isArabicLang(context)
                                    ? Radius.circular(10.0)
                                    : Radius.zero,
                                bottomRight: isArabicLang(context)
                                    ? Radius.circular(10.0)
                                    : Radius.zero)),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: AutoSizeText(
                            'Add to cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isArabicLang(BuildContext context) =>
      context.locale.languageCode == "ar";
}

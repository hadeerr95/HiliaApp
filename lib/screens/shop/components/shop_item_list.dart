import 'package:app/app_properties.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/product/components/shop_product.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';

class ShopItemList extends StatefulWidget {
  final SaleOrderLine saleOrderLine;
  final Function onRemove;
  final Function(SaleOrderLine sol) onChangeQty;

  ShopItemList(this.saleOrderLine, {Key key, this.onRemove, this.onChangeQty})
      : super(key: key);

  @override
  _ShopItemListState createState() => _ShopItemListState();
}

class _ShopItemListState extends State<ShopItemList> {
  @override
  Widget build(BuildContext context) {
    Variant variant = BlocProvider.of<CatalogCubit>(context)
        .state
        .getVariant(widget.saleOrderLine.variant?.id);
    // List<AttributeValue> attrValues =
    //     Catalog.getAttrValuesByAttrValueIds(variant.attributeValueIds);
    // print(attrValues);
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 130,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, 0.8),
            child: Container(
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: shadow,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 12.0, right: 12.0),
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              variant?.name ?? "",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: darkGrey,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 160,
                                padding: const EdgeInsets.only(
                                    left: 32.0, top: 8.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // ColorOption(Colors.red),
                                    AutoSizeText(BlocProvider.of<AuthenticationBloc>(context)
                .state
                .user
                .setting
                .priceWithCurrency(variant.lstPrice),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: darkGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                            accentColor: Colors.black,
                            textTheme: TextTheme(
                                // headline: TextStyle(
                                //     fontFamily: 'Montserrat',
                                //     fontSize: 14,
                                //     color: Colors.black,
                                //     fontWeight: FontWeight.bold),
                                // body1: TextStyle(
                                //   fontFamily: 'Montserrat',
                                //   fontSize: 12,
                                //   color: Colors.grey[400],
                                // ),
                                )),
                        child: NumberPicker.integer(
                          initialValue:
                              widget.saleOrderLine.productsQty.round(),
                          minValue: 1,
                          maxValue: 100,
                          onChanged: (value) {
                            widget.onChangeQty(widget.saleOrderLine);
                            setState(() {
                              // widget.saleOrderLine.productsQty = value;
                            });
                          },
                          itemExtent: 30,
                          listViewWidth: 40,
                        ),
                      )
                    ])),
          ),
          Positioned(
              top: 5,
              child: ShopProductDisplay(
                variant,
                onPressed: widget.onRemove,
              )),
        ],
      ),
    );
  }
}

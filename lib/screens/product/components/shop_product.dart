import 'package:app/app_properties.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';

class ShopProduct extends StatelessWidget {
  final Variant product;
  final Function onRemove;

  const ShopProduct(this.product, {Key key, this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          children: <Widget>[
            ShopProductDisplay(
              product,
              onPressed: onRemove,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                product.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkGrey,
                ),
              ),
            ),
            AutoSizeText(
              BlocProvider.of<AuthenticationBloc>(context)
                .state
                .user
                .setting
                .priceWithCurrency(product.lstPrice),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: darkGrey, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ],
        ));
  }
}

class ShopProductDisplay extends StatelessWidget {
  final Variant variant;
  final Function onPressed;

  const ShopProductDisplay(this.variant, {Key key, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 150,
        width: 100,
        child: Stack(children: <Widget>[
          Positioned(
            left: 5,
            top: 5,
            child: SizedBox(
                height: 80,
                width: 80,
                child: BlocProvider.of<CatalogCubit>(context)
                        .state
                        .getProductByVariantId(variant.id)
                        ?.imageWidget() ??
                    SizedBox()),
          ),
          Positioned(
            right: 0,
            bottom: 25,
            child: Align(
              child: IconButton(
                icon: Image.asset('assets/red_clear.png'),
                onPressed: onPressed,
              ),
            ),
          )
        ]),
      ),
    );
  }
}

import 'package:app/app_properties.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/product/view_product_page.dart';
import 'package:flutter/material.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDisplay extends StatelessWidget {
  final Product product;

  const ProductDisplay({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            top: 30.0,
            right: 0,
            child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 85,
                padding: EdgeInsets.only(right: 24),
                decoration: new BoxDecoration(
                    color: darkGrey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          offset: Offset(0, 3),
                          blurRadius: 6.0),
                    ]),
                child: Align(
                  alignment: Alignment(1, 0),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: BlocProvider.of<AuthenticationBloc>(context)
                .state
                .user
                .setting
                .priceWithCurrency(product.listPrice),
                        style: const TextStyle(
                            color: const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontSize: 36.0))
                  ])),
                ))),
        Align(
          alignment: Alignment(-1, 0),
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Container(
              height: screenAwareSize(220, context),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 18.0,
                    ),
                    child: Container(
                      child: Hero(
                        tag: product,
                        child: product.imageWidget(
                          fit: BoxFit.contain,
                          height: 230,
                          width: 230,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 20.0,
          bottom: 0.0,
          child: RawMaterialButton(
            onPressed: () => Navigator.of(context)
                .push(ViewProductPage.route(id: product.id)),
            constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
            child:
                Icon(Icons.favorite, color: Color.fromRGBO(255, 137, 147, 1)),
            elevation: 0.0,
            shape: CircleBorder(),
            fillColor: Color.fromRGBO(255, 255, 255, 0.4),
          ),
        )
      ],
    );
  }
}

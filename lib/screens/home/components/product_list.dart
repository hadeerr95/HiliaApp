import 'package:app/app_properties.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/product/view_product_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class ProductList extends StatelessWidget {
//   List<Product> products;

//   final SwiperController swiperController = SwiperController();

//   ProductList({Key key, this.products}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double cardHeight = MediaQuery.of(context).size.height / 2.7;
//     double cardWidth = MediaQuery.of(context).size.width / 1.8;
//     if (products == null) products = [];

//     return SizedBox(
//       height: cardHeight,
//       child: Swiper(
//         itemCount: products.length,
//         itemBuilder: (_, index) {
//           return ProductCard(
//               height: cardHeight, width: cardWidth, product: products[index]);
//         },
//         scale: 0.8,
//         controller: swiperController,
//         viewportFraction: 0.6,
//         loop: false,
//         fade: 0.5,
//       ),
//     );
//   }
// }

class ProductCard extends StatelessWidget {
  final Product product;
  final double height;
  final double width;

  const ProductCard({Key key, this.product, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.of(context).push(ViewProductPage.route(id: product.id)),
      child: Stack(
        children: <Widget>[
          Container(
            margin: isArabicLang(context)
                ? const EdgeInsets.only(right: 30)
                : const EdgeInsets.only(left: 30),
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: mediumYellow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {},
                  color: Colors.white,
                ),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            product.name ?? '',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        )),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          color: Color.fromRGBO(224, 69, 10, 1),
                        ),
                        child: AutoSizeText(
                          BlocProvider.of<AuthenticationBloc>(context)
                .state
                .user
                .setting
                .priceWithCurrency(product.listPrice),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            child: Hero(
              tag: product,
              child: product.imageWidget(
                fit: BoxFit.contain,
                height: 230,
                width: 230,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isArabicLang(BuildContext context) =>
      context.locale.languageCode == "ar";
}

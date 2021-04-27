import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_grid_view.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';

class RecommendedList extends StatelessWidget {
  final List<Product> products;
  final List<HiliaCategory> categories;

  const RecommendedList({Key key, this.products, this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: Container(
            padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
            child: BlocBuilder<CatalogCubit, CatalogState>(
              builder: (context, state) {
                return Column(children: [
                  Expanded(
                    child: ProductGridView(
                      products: products,
                      onMaxScrollExtent: () {
                        categories.forEach((e) {
                          // BlocProvider.of<CatalogCubit>(context)
                          //     .productCategLoad(categId: e.id);
                        });
                        print("onMaxScrollExtent");
                      },
                    ),
                  ),
                ]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ProCard extends StatelessWidget {
  final Product product;

  const ProCard({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // BlocProvider.of<CatalogCubit>(context)
        //     .variantProductLoad(productId: product.id);
        // BlocProvider.of<CatalogCubit>(context).cariantImagesLoader(product.id);

        // Catalog.variantConut(product.id) > 1
        //     ? Navigator.of(context).push(MaterialPageRoute(
        //         builder: (_) => ViewProductPage(product: product)))
        //     : Navigator.of(context).push(MaterialPageRoute(
        //         builder: (_) => ProductPage(product: product)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          // color: mediumYellow,
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 4.0,
                left: 12.0,
                child: Hero(
                  tag: product,
                  child: product.imageWidget(
                    fit: BoxFit.contain,
                    height: 100,
                    width: 100,
                  ),
                )),
            Container(
              padding: EdgeInsets.all(6.0),
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
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                          )),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
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
          ],
        ),
      ),
    );
  }
}

import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/widget.dart';
import 'package:app/screens/product/view_product_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductStaggeredGridView extends StatelessWidget {
  const ProductStaggeredGridView({
    Key key,
    @required this.products,
  }) : super(key: key);

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        Product product = products[index];
        return ProductCard(product: product);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 8.0,
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.of(context).push(ViewProductPage.route(id: product.id)),
      child: Stack(
        children: [
          CustomCard(
            showShadow: false,
            borderRadius: BorderRadius.all(Radius.circular(0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Hero(
                      tag: "product${product.id}",
                      child: product?.imageWidget(fit: BoxFit.cover)),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffffffff), Colors.grey[300]]),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AutoSizeText(
                        product.name,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(height: 8),
                      AutoSizeText(
                        BlocProvider.of<AuthenticationBloc>(context)
                            .state
                            .user
                            .setting
                            .priceWithCurrency(product.listPrice),
                        maxLines: 1,
                      ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText("sales"
                              .tr(args: [product.salesCount.toString()])),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.yellow,
                              ),
                              AutoSizeText(product.ratingValue.toString(),
                                  style: Theme.of(context).textTheme.bodyText2)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: FavButton(
              product: product,
            ),
          ),
        ],
      ),
    );
  }
}

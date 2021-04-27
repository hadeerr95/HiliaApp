import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/widget.dart';
import 'package:app/screens/product/view_product_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListView extends StatefulWidget {
  final List<Product> products;
  final Function onMaxScrollExtent;
  final Function(Product) onPressed;

  const ProductListView(
      {Key key,
      @required this.products,
      this.onMaxScrollExtent,
      this.onPressed})
      : super(key: key);
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
      return Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: (widget.products.length),
            itemBuilder: (BuildContext context, int index) {
              Product p = widget.products[index];
              if (index >= widget.products.length) {
                if (widget.onMaxScrollExtent != null)
                  widget.onMaxScrollExtent();
                return SizedBox();
              }
              return InkWell(
                onTap: () {
                  if (widget.onPressed != null)
                    widget.onPressed(p);
                  else {
                    // BlocProvider.of<CatalogCubit>(context)
                    //     .variantProductLoad(productId: p.id);
                    // BlocProvider.of<CatalogCubit>(context).cariantImagesLoader(product.id);
                    Navigator.of(context).push(ViewProductPage.route(id: p.id));
                    // Catalog.variantConut(p.id) > 1
                    //     ? Navigator.of(context).pushNamed(MyRoutes.product, arguments: {"product":p})
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (_) => ViewProductPage(product: p)))
                    //     : Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (_) => ProductPage(product: p)));
                  }
                },
                child: Card(
                  child: ListTile(
                    leading: Container(
                      child: Hero(
                          tag: "product${p.id}",
                          child: p?.imageWidget(fit: BoxFit.cover)),
                    ),
                    title: AutoSizeText(p.name),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PriceCard(product: p),
                      ],
                    ),
                    trailing: FavButton(product: p),
                  ),
                ),
              );
            },
          ),
        ),
      ]);
    });
  }
}

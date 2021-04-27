import 'package:app/app_properties.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/widget.dart';
import 'package:app/screens/product/view_product_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatefulWidget {
  ProductGridView({
    Key key,
    @required this.products,
    this.onMaxScrollExtent,
    this.onPressed,
    this.controller,
  }) : super(key: key);

  final List<Product> products;
  final Function onMaxScrollExtent;
  final Function(Product) onPressed;
  final ScrollController controller;

  @override
  _ProductGridViewState createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (widget.onMaxScrollExtent != null) widget.onMaxScrollExtent();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        physics: NeverScrollableScrollPhysics(),
        children: widget.products.map((e) {
          return InkWell(
            onTap: () {
              if (widget.onPressed != null)
                widget.onPressed(e);
              else {
                Navigator.of(context).push(ViewProductPage.route(id: e.id));
              }
            },
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.transparent,
              elevation: 0.0,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        width: double.infinity,
                        child: Hero(
                          tag: e,
                          child: e.imageWidget(fit: BoxFit.contain),
                          // e.imageWidget(fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: itemWidth,
                        decoration: BoxDecoration(
                          color: mediumYellow,
                          // gradient: RadialGradient(
                          //     colors: [mediumYellow, darkYellow],
                          //     center: Alignment(0, 0),
                          //     radius: 0.8,
                          //     focal: Alignment(0, 0),
                          //     focalRadius: 0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  e.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FavButton(
                                    product: e,
                                  ),
                                  PriceCard(product: e),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

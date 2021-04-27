import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/widget.dart';
import 'package:app/screens/product/view_product_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Exclusive extends StatelessWidget {
  const Exclusive({
    Key key,
    @required this.categories,
  }) : super(key: key);

  final List<HiliaCategory> categories;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
      return Column(
        children: categories
            .map((category) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.campaign_outlined,
                            color: Color(0xFF102c3b),
                            size: 32,
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          AutoSizeText(
                            category?.name ?? "",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    FlashSales(products: category.allProducts)
                  ],
                ))
            .toList(),
      );
    });
  }
}

class HGategList extends StatelessWidget {
  const HGategList({
    Key key,
    @required this.products,
  }) : super(key: key);

  final List<Product> products;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 2 + kToolbarHeight,
      child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: products
              .map((product) => Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: InkWell(
                      onTap: () => Navigator.of(context)
                          .push(ViewProductPage.route(id: product?.id)),
                      child: Container(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: CustomCard(
                                    width: double.infinity,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    child:
                                        product?.imageWidget(fit: BoxFit.cover),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: CustomCard(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: AutoSizeText(
                                                product?.name ?? "",
                                                maxLines: 2,
                                                maxFontSize: 20,
                                                minFontSize: 10,
                                                // style: Theme.of(context)
                                                //     .textTheme
                                                //     .bodyText2,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: AutoSizeText(
                                                BlocProvider.of<
                                                            AuthenticationBloc>(
                                                        context)
                                                    .state
                                                    .user
                                                    .setting
                                                    .priceWithCurrency(
                                                        product.listPrice),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: AutoSizeText(
                                                    "sales".tr(args: [
                                                      product.salesCount
                                                          .toString()
                                                    ]),
                                                    maxLines: 1,
                                                  )),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        size: 20,
                                                        color: Colors.yellow,
                                                      ),
                                                      AutoSizeText(
                                                          product.ratingValue
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList()),
    );
  }
}

class FlashSales extends StatelessWidget {
  const FlashSales({
    Key key,
    @required this.products,
  }) : super(key: key);

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 2 + kToolbarHeight,
      child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: products
              .map((product) => Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: InkWell(
                      onTap: () => Navigator.of(context)
                          .push(ViewProductPage.route(id: product?.id)),
                      child: Container(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: CustomCard(
                                    width: double.infinity,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    child:
                                        product?.imageWidget(fit: BoxFit.cover),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: CustomCard(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: AutoSizeText(
                                                product?.name ?? "",
                                                maxLines: 2,
                                                maxFontSize: 20,
                                                minFontSize: 10,
                                                // style: Theme.of(context)
                                                //     .textTheme
                                                //     .bodyText2,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: AutoSizeText(
                                                BlocProvider.of<
                                                            AuthenticationBloc>(
                                                        context)
                                                    .state
                                                    .user
                                                    .setting
                                                    .priceWithCurrency(
                                                        product.listPrice),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: AutoSizeText(
                                                    "sales".tr(args: [
                                                      product.salesCount
                                                          .toString()
                                                    ]),
                                                    maxLines: 1,
                                                  )),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        size: 20,
                                                        color: Colors.yellow,
                                                      ),
                                                      AutoSizeText(
                                                          product.ratingValue
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FavButton(
                                    product: product,
                                  ),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    child: Container(
                                      color: Color(0xFF102c3b),
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(
                                        "16.5 %",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList()),
    );
  }
}

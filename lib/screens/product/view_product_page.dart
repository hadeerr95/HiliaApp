import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/config.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/components.dart';
import 'package:app/screens/components/widget.dart';
import 'package:app/screens/notifications_page.dart';
import 'package:app/screens/shop/check_out_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'components/shop_bottomSheet.dart';

class ViewProductPage extends StatefulWidget {
  static Route route({int id}) {
    return MaterialPageRoute<void>(builder: (_) => ViewProductPage(id: id));
  }

  final int id;

  const ViewProductPage({Key key, this.id}) : super(key: key);

  @override
  _ViewProductPageState createState() => _ViewProductPageState(id);
}

class _ViewProductPageState extends State<ViewProductPage> {
  final int id;

  _ViewProductPageState(this.id);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map> tabs;
  Variant _variant;
  Product product;

  @override
  void initState() {
    super.initState();
    CatalogCubit catalogCubit = BlocProvider.of<CatalogCubit>(context);
    if (catalogCubit.state.getProductState(id)?.data?.variants?.isEmpty ??
        false) catalogCubit.loadProduct(id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
        LoaderState<Product> productState = state.getProductState(id);
        if (_variant == null) {
          if (productState?.data?.variants?.isNotEmpty ?? false) {
            product = productState.data;
            _variant = productState.data.variants.first;
          } else if (productState?.status == LoaderStatus.failed)
            return ConnectionFailed(
                onPressed: () => context.bloc<CatalogCubit>().loadProduct(id));
          else {
            if (productState?.status != LoaderStatus.loading)
              context.bloc<CatalogCubit>().loadProduct(id);

            return CupertinoActivityIndicator();
          }
        }

        return Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      iconTheme: IconThemeData(color: Colors.grey[700]),
                      backgroundColor: Colors.white,
                      expandedHeight: MediaQuery.of(context).size.width,
                      // floating: true,
                      // pinned: true,
                      actions: [
                        NotificationIcon(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => NotificationsPage()))),
                        ShoppingCartIcon(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => CheckOutPage()))),
                      ],
                      // snap: true,
                      bottom: TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Color(0xFF102c3b),
                        indicator: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF102c3b),
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          color: Color(0xFF102c3b),
                        ),
                        tabs: <Widget>[
                          Tab(text: "product".tr()),
                          Tab(text: "detail".tr()),
                          // Tab(text: "review".tr()),
                        ],
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            Hero(
                              tag: 'product${product.id}',
                              child: product.images.isEmpty
                                  ? product?.imageWidget(
                                      fit: BoxFit.contain,
                                      width: MediaQuery.of(context).size.width,
                                    )
                                  : Swiper(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index == 0)
                                          return product?.imageWidget(
                                            fit: BoxFit.contain,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          );
                                        ImageBites productImage =
                                            product.images[index - 1];
                                        if (productImage != null)
                                          return productImage.imageWidget();
                                        return CupertinoActivityIndicator();
                                      },
                                      itemCount: product.images.length + 1,
                                      pagination: new SwiperPagination(),
                                      control: new SwiperControl(),
                                    ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    Colors.white.withOpacity(.8),
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.white.withOpacity(.8),
                                  ],
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(children: [
                  ProductView(
                    variant: _variant,
                    product: product,
                    onChangeVarinat: (v) {
                      setState(() {
                        _variant = v;
                      });
                    },
                  ),
                  DetailTab(product: product),
                  // RatingPage(product: product),
                ]),
              ),
            ),
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
                accentColor: Colors.yellow,
                accentIconTheme: IconThemeData(color: Colors.white)),
            child: BottomAppBar(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.transparent,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.teal[50],
                        ),
                        child: FavButton(product: product),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: AddToCartButton(
                          variantId: _variant.id,
                          productId: product.id,
                          scaffoldKey: _scaffoldKey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   Widget description = Padding(
  //     padding: const EdgeInsets.all(24.0),
  //     child: AutoSizeText(
  //       product.descriptionSale ?? "",
  //       maxLines: 5,
  //       semanticsLabel: '...',
  //       overflow: TextOverflow.ellipsis,
  //       style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)),
  //     ),
  //   );

  //   return Scaffold(
  //       key: _scaffoldKey,
  //       // backgroundColor: yellow,
  //       appBar: AppBar(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0.0,
  //         iconTheme: IconThemeData(color: darkGrey),
  //         actions: <Widget>[
  //           IconButton(
  //             icon: new SvgPicture.asset(
  //               'assets/icons/search_icon.svg',
  //               fit: BoxFit.scaleDown,
  //             ),
  //             onPressed: () => Navigator.of(context)
  //                 .push(MaterialPageRoute(builder: (_) => SearchPage())),
  //           )
  //         ],
  //         title: AutoSizeText(
  //           'firstScreen',
  //           style: const TextStyle(
  //               color: darkGrey,
  //               fontWeight: FontWeight.w500,
  //               fontFamily: "Montserrat",
  //               fontSize: 18.0),
  //         ),
  //       ),
  //       body: SingleChildScrollView(
  //         child: Container(
  //           width: MediaQuery.of(context).size.width,
  //           child: Column(
  //             children: <Widget>[
  //               ProductOption(
  //                 _scaffoldKey,
  //                 variant: _variant,
  //               ),
  //               description,
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.all(8.0),
  //                     child: RawMaterialButton(
  //                       onPressed: () {
  //                         showModalBottomSheet(
  //                           context: context,
  //                           builder: (context) {
  //                             return RatingBottomSheet();
  //                           },
  //                           //elevation: 0,
  //                           //backgroundColor: Colors.transparent
  //                         );
  //                       },
  //                       constraints:
  //                           const BoxConstraints(minWidth: 45, minHeight: 45),
  //                       child: Icon(Icons.favorite,
  //                           color: Color.fromRGBO(255, 137, 147, 1)),
  //                       elevation: 0.0,
  //                       shape: CircleBorder(),
  //                       fillColor: Color.fromRGBO(255, 255, 255, 0.4),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               MoreProducts(),
  //             ],
  //           ),
  //         ),
  //       ));
  // }
}

class DetailTab extends StatefulWidget {
  const DetailTab({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _DetailTabState createState() => _DetailTabState();
}

class _DetailTabState extends State<DetailTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined),
              SizedBox(width: 24),
              AutoSizeText(
                "description".tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF102c3b),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          AutoSizeText(
            widget.product.description ?? "",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF102c3b),
            ),
          ),
          HtmlWidget(
              widget.product?.websiteDesc?.replaceAll("\"/", "\"$ServerUrl/") ??
                  ""),
        ],
      ),
    ));
  }
}

class AddToCartButton extends StatefulWidget {
  const AddToCartButton({
    Key key,
    @required this.variantId,
    @required this.productId,
    @required this.scaffoldKey,
  }) : super(key: key);

  final int variantId;
  final int productId;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  int productsQty = 1;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<CatalogCubit>(context).addItemToCart(CartItem(
          variantId: widget.variantId,
          productId: widget.productId,
          qty: productsQty,
        ));
        widget.scaffoldKey.currentState.showBottomSheet((context) {
          return ShopBottomSheet();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color(0xFF102c3b),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                // color: Colors.red,
                child: AutoSizeText(
                  'add_to_cart'.tr(),
                  maxLines: 1,
                  minFontSize: 2,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (productsQty > 1)
                          setState(() {
                            productsQty -= 1;
                          });
                      }),
                  AutoSizeText(
                    "$productsQty",
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (productsQty < 100)
                          setState(() {
                            productsQty += 1;
                          });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductView extends StatefulWidget {
  const ProductView({
    Key key,
    @required this.variant,
    @required this.product,
    this.onChangeVarinat,
  }) : super(key: key);

  final Variant variant;
  final Product product;
  final Function(Variant) onChangeVarinat;

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(children: [
        Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AutoSizeText(
                widget.variant?.name ?? "",
                maxLines: 2,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF102c3b),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 36,
              ),
              AutoSizeText(
                BlocProvider.of<AuthenticationBloc>(context)
                    .state
                    .user
                    .setting
                    .priceWithCurrency(widget.variant.lstPrice),
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF102c3b),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        widget.product.attributeLines.isNotEmpty
            ? CustomCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.product.attributeLines?.map<Widget>((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: VariantsView(
                        variant: widget.variant,
                        product: widget.product,
                        attributeLine: e,
                        onChange: (variant) {
                          if (widget.onChangeVarinat != null)
                            widget.onChangeVarinat(variant);
                        },
                      ),
                    );
                  })?.toList(),
                ),
              )
            : SizedBox()
      ]),
      // MoreProducts(),
    );
  }
}

class VariantsView extends StatefulWidget {
  final AttributeLine attributeLine;
  final Product product;
  final Variant variant;
  final Function(Variant) onChange;

  const VariantsView({
    Key key,
    @required this.attributeLine,
    @required this.product,
    @required this.variant,
    this.onChange,
  }) : super(key: key);
  @override
  _VariantsViewState createState() => _VariantsViewState();
}

class _VariantsViewState extends State<VariantsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "select_attr"
                    .tr(args: [widget.attributeLine.attribute?.name ?? ""]),
                style: TextStyle(
                  color: Colors.tealAccent[50],
                  fontSize: 16,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: widget.attributeLine.values.map<Widget>((value) {
                    List<AttributeValue> values = [
                      ...widget.variant.attributeValues
                    ]
                      ..removeWhere((el) =>
                          el.attribute.id == widget.attributeLine.attribute.id)
                      ..add(value);
                    bool enable = widget.product.variants.any((vr) => vr
                        .attributeValues
                        .every((va) => values.any((e) => va.id == e.id)));
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                          onTap: enable
                              ? () {
                                  Variant variant = widget.product.variants
                                      .firstWhere(
                                          (variant) => variant.attributeValues
                                              .every((e) => values
                                                  .any((e2) => e.id == e2.id)),
                                          orElse: () => null);
                                  setState(() {
                                    widget.onChange(variant);
                                  });
                                }
                              : null,
                          child: widget.attributeLine.attribute?.type ==
                                  AttributeType.Color
                              ? ColorOption(
                                  colorByHtmlCode(value.htmlColor),
                                  active: widget.variant.attributeValues
                                      .any((e) => e.id == value.id),
                                  enable: enable,
                                )
                              : widget.attributeLine.attribute?.type ==
                                      AttributeType.Radio
                                  ? ChipOption(
                                      value.name,
                                      active: widget.variant.attributeValues
                                          .any((e) => e.id == value.id),
                                      enable: enable,
                                    )
                                  : widget.attributeLine.attribute?.type ==
                                          AttributeType.Select
                                      ? Container()
                                      : Container(),
                        ));
                  }).toList(),
                ),
              ),
            ),
          ]),
    );
  }
}

class ChipOption extends StatelessWidget {
  final String name;
  final bool active;
  final bool enable;

  const ChipOption(this.name,
      {Key key, this.active = false, this.enable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: enable
          ? active
              ? CircleAvatar(
                  child: Icon(Icons.check),
                  backgroundColor: Colors.teal[50],
                )
              : null
          : CircleAvatar(
              child: Icon(Icons.close, color: Colors.red),
              backgroundColor: Colors.teal[50],
            ),
      label: AutoSizeText(name),
    );
  }
}

import 'dart:io';

import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/widget.dart';
import 'package:app/screens/notifications_page.dart';
import 'package:app/screens/search_page.dart';
import 'package:app/screens/shop/check_out_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'components/product_staggered_grid_view.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController tabController;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    BlocProvider.of<CatalogCubit>(context).loadCategories(refresh: true);
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    setState(() {});
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 1;
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        List<HiliaCategory> categories = state.categoriesState.data ?? [];
        // print(state.categoriesState.status);
        if (categories.isEmpty) {
          if (state.categoriesState.status == LoaderStatus.failed)
            return ConnectionFailed(
                onPressed: () => context.bloc<CatalogCubit>().loadCategories());
          else if (state.categoriesState.status == LoaderStatus.loading)
            return Center(child: CupertinoActivityIndicator());
          else if (state.categoriesState.status == LoaderStatus.none)
            context.bloc<CatalogCubit>().loadCategories();

          return AutoSizeText("No Product");
        }
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color(0xFF102c3b),

            // centerTitle: true,
            elevation: 0.0,

            title: Image.asset(
              "assets/home_icon.png",
              width: 120,
              fit: BoxFit.fill,
            ),
            actions: [
              NotificationIcon(
                onPressed: () =>
                    Navigator.of(context).push(NotificationsPage.route()),
              ),
              ShoppingCartIcon(
                onPressed: () =>
                    Navigator.of(context).push(CheckOutPage.route()),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF9aa7b0), Color(0xFFf6f6f6)])),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = AutoSizeText("pull up load");
                    body = SizedBox();
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = AutoSizeText("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = AutoSizeText("release to load more");
                  } else {
                    body = AutoSizeText("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView(children: [
                Hero(
                  tag: "searchBar",
                  child: CustomCard(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    margin:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: TextField(
                      onTap: () =>
                          Navigator.of(context).push(SearchPage.route()),
                      decoration: InputDecoration(
                        hintText: "search".tr() + "...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search_outlined),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                AdsBoard(),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 16, horizontal: 8.0),
                //   child: Exclusive(categories: [categories[1]]),
                // ),
                CatalogBrowse(
                    categories: (categories
                          ..sort((a, b) => a.sequence.compareTo(b.sequence)))
                        .where((e) => e.suggestedProducts == false)
                        .toList()),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class CatalogBrowse extends StatefulWidget {
  const CatalogBrowse({
    Key key,
    @required this.categories,
  }) : super(key: key);

  final List<HiliaCategory> categories;

  @override
  _CatalogBrowseState createState() => _CatalogBrowseState();
}

class _CatalogBrowseState extends State<CatalogBrowse>
    with SingleTickerProviderStateMixin {
  int active = 0;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(animation.value);
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.star_outline,
                color: Color(0xFF102c3b),
              ),
              SizedBox(width: 16),
              Expanded(
                child: AutoSizeText(
                  "recommended_for_you".tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF102c3b),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        CategoriesBar(
            active: active,
            categories: widget.categories,
            onSelect: (index) {
              controller
                ..reset()
                ..forward();
              setState(() {
                active = index;
              });
            }),
        widget.categories[active].allProducts.length > 0
            ? Opacity(
                opacity: animation.value,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: ProductStaggeredGridView(
                      products: widget.categories[active].allProducts),
                ))
            : Center(child: Text("Not_Found_data".tr())),
      ],
    );
  }
}

class CategoriesBar extends StatelessWidget {
  const CategoriesBar({
    Key key,
    @required this.active,
    @required this.categories,
    @required this.onSelect,
  }) : super(key: key);

  final int active;
  final List<HiliaCategory> categories;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        padding: EdgeInsetsDirectional.only(start: 15.0, end: 15.0),
        color: Colors.white,
        child: DefaultTabController(
          length: categories.length,
          child: TabBar(
              onTap: onSelect,
              indicatorColor: Color(0xFF102c3b),
              isScrollable: true,
              tabs: categories
                  .map((category) => Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          category.imageWidget(width: 80, height: 80),
                          Flexible(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                  color: Color(0xFF102c3b),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ))
                  .toList()),
        )
        // child: Row(
        //   children: [
        //     Container(
        //       padding: EdgeInsets.all(4),
        //       child: IconButton(
        //         icon: Icon(
        //           Icons.category_outlined,
        //           color: Colors.teal,
        //           size: 32,
        //         ),
        //         onPressed: () =>
        //             Navigator.of(context).push(CategoryListPage.route()),
        //       ),
        //     ),
        //     Expanded(
        //       child: CustomCard(
        //         margin: EdgeInsets.zero,
        //         color: Colors.teal,
        //         borderRadius: BorderRadius.all(Radius.circular(50)),
        //         child: SingleChildScrollView(
        //           scrollDirection: Axis.horizontal,
        //           child: SalomonBottomBar(
        //             margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        //             selectedItemColor: Colors.white,
        //             selectedColorOpacity: 1.0,
        //             itemPadding: EdgeInsets.symmetric(horizontal: 8),
        //             currentIndex: active,
        //             onTap: onSelect,
        //             items: categories.map((e) {
        //               return SalomonBottomBarItem(
        //                 icon: Container(
        //                   decoration: BoxDecoration(
        //                       color: Colors.white, shape: BoxShape.circle),
        //                   child: e.imageWidget(),
        //                   padding:
        //                       EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        //                 ),
        //                 title: Container(
        //                   child: AutoSizeText(
        //                     e.name,
        //                     style: TextStyle(
        //                         color: Colors.teal, fontWeight: FontWeight.bold),
        //                   ),
        //                 ),
        //               );
        //             }).toList(),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}

class AdsBoard extends StatefulWidget {
  const AdsBoard({
    Key key,
  }) : super(key: key);

  @override
  _AdsBoardState createState() => _AdsBoardState();
}

class _AdsBoardState extends State<AdsBoard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
      List<Ads> ads = state.adsState.data ?? [];
      if (ads.isEmpty) return SizedBox();

      return Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.width / 2) - 16,
        child: CustomCard(
          showShadow: false,
          borderRadius: BorderRadius.all(Radius.circular(0)),
          margin: EdgeInsets.zero,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: ads[index].url != null
                    ? () async {
                        try {
                          var androidInfo =
                              await DeviceInfoPlugin().androidInfo;
                          var sdkInt = androidInfo.version.sdkInt;
                          if (Platform.isIOS || sdkInt >= 20) {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => Scaffold(
                                  appBar: AppBar(
                                    // centerTitle: true,
                                    iconTheme:
                                        IconThemeData(color: Colors.white),
                                    title: Text(
                                      ads[index].name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Color(0xFF102c3b),
                                    elevation: 0,
                                  ),
                                  body: WebView(
                                    initialUrl: ads[index].url,
                                    javascriptMode: JavascriptMode.unrestricted,
                                    navigationDelegate:
                                        (NavigationRequest request) {
                                      if (request.url.startsWith('hilia://')) {
                                        return NavigationDecision.prevent;
                                      }
                                      return NavigationDecision.navigate;
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            if (await canLaunch(ads[index].url)) {
                              await launch(ads[index].url);
                            } else {
                              throw Exception();
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    : null,
                child: ads[index].imageWidget(fit: BoxFit.cover),
              );
              // return widget.categories[index]?.imageWidget(fit: BoxFit.cover) ??
              //     SizedBox();
            },
            itemCount: ads.length,
            pagination: SwiperPagination(),
            // control: SwiperControl(),
            autoplay: true,
          ),
        ),
      );
    });
  }
}

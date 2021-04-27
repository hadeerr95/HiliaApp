import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/components.dart';
import 'package:app/screens/home/components/product_staggered_grid_view.dart';
import 'package:app/screens/notifications_page.dart';
import 'package:app/screens/search_page.dart';
import 'package:app/screens/shop/check_out_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryPage extends StatefulWidget {
  static Route route(int id, {int childId}) {
    return MaterialPageRoute<void>(
        builder: (_) => CategoryPage(id, childId: childId));
  }

  final int id;
  final int childId;

  const CategoryPage(this.id, {Key key, this.childId}) : super(key: key);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
      HiliaCategory category = state.categoriesState.data
          .firstWhere((e) => e.id == widget.id, orElse: () => null);
      if (category == null) return SizedBox();
      int childIndex =
          category.children.indexWhere((e) => e.id == widget.childId);
      return Scaffold(
        // key: _scaffoldKey,
        body: SafeArea(
          child: DefaultTabController(
            initialIndex: childIndex >= 0 ? childIndex : 0,
            length: category.children.length,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    iconTheme: IconThemeData(color: Colors.grey[700]),
                    backgroundColor:  Color(0xFF102c3b),
                    expandedHeight: MediaQuery.of(context).size.width / 1.5,
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
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFF102c3b),
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                          ),
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Expanded(flex: 1, child: SizedBox()),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: Hero(
                                              tag: 'categ${category.id}',
                                              child: category.imageWidget(),
                                            ),
                                          ),
                                        ),
                                        AutoSizeText(
                                          category.name,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 1, child: SizedBox()),
                                ],
                              ),
                            ),
                            // Container(
                            // decoration: BoxDecoration(
                            //   gradient: RadialGradient(
                            //     colors: [
                            //       Colors.transparent,
                            //       Colors.white.withOpacity(.8),
                            //     ],
                            //   ),
                            // ),
                            // gradient: LinearGradient(
                            //     colors: [
                            //   Colors.white.withOpacity(.8),
                            //   Colors.transparent,
                            //   Colors.white.withOpacity(.8),
                            // ],
                            //     begin: FractionalOffset.topCenter,
                            //     end: FractionalOffset.bottomCenter)),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    bottom: TabBar(
                      indicator: BoxDecoration(
                        border: BorderDirectional(
                            bottom: BorderSide(
                                color: Colors.white,
                                width: 4,
                                style: BorderStyle.solid)),
                      ),
                      isScrollable: true,
                      tabs: category.children
                          .map<Widget>((e) => Tab(text: e.name))
                          .toList(),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                  children: category.children
                      .map((e) => ListView(
                            children: [
                              Hero(
                                tag: "searchBar",
                                child: CustomCard(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: TextField(
                                    onTap: () => Navigator.of(context)
                                        .push(SearchPage.route()),
                                    decoration: InputDecoration(
                                      hintText: "search".tr() + "...",
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.search_outlined),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ProductStaggeredGridView(
                                    products: e.allProducts),
                              )
                            ],
                          ))
                      .toList()),
            ),
          ),
        ),
      );
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Material(
  //     color: Color(0xffF9F9F9),
  //     child: Container(
  //       margin: const EdgeInsets.only(top: kToolbarHeight),
  //       padding: EdgeInsets.symmetric(horizontal: 16.0),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Align(
  //             alignment: Alignment(-1, 0),
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(vertical: 16.0),
  //               child: AutoSizeText(
  //                 'Category List',
  //                 style: TextStyle(
  //                   color: darkGrey,
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Container(
  //             padding: EdgeInsets.only(left: 16.0),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.all(Radius.circular(5)),
  //               color: Colors.white,
  //             ),
  //             child: TextField(
  //               controller: searchController,
  //               decoration: InputDecoration(
  //                   border: InputBorder.none,
  //                   hintText: 'Search',
  //                   prefixIcon: SvgPicture.asset(
  //                     'assets/icons/search_icon.svg',
  //                     fit: BoxFit.scaleDown,
  //                   )),
  //               onChanged: (value) {
  //                 if (value.isNotEmpty) {
  //                   List<HiliaCategory> tempList = List<HiliaCategory>();
  //                   // widget.categories.forEach((category) {
  //                   //   if (category.name.toLowerCase().contains(value)) {
  //                   //     tempList.add(category);
  //                   //   }
  //                   // });
  //                   setState(() {
  //                     // searchResults.clear();
  //                     // searchResults.addAll(tempList);
  //                   });
  //                   return;
  //                 } else {
  //                   setState(() {
  //                     // searchResults.clear();
  //                     // searchResults.addAll(widget.categories);
  //                   });
  //                 }
  //               },
  //             ),
  //           ),
  //           Flexible(
  //             child: ListView.builder(
  //               // itemCount: searchResults.length,
  //               itemBuilder: (_, index) => Padding(
  //                 padding: EdgeInsets.symmetric(
  //                   vertical: 16.0,
  //                 ),
  //                 child: Container(),
  //                 // StaggeredCardCard(
  //                 //   begin: searchResults[index].begin,
  //                 //   end: searchResults[index].end,
  //                 //   categoryName: searchResults[index].category,
  //                 //   assetPath: searchResults[index].image,
  //                 // ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

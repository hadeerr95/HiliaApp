import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/components.dart';
import 'package:app/screens/notifications_page.dart';
import 'package:app/screens/search_page.dart';
import 'package:app/screens/shop/check_out_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'category_page.dart';

class CategoryListPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CategoryListPage());
  }

  const CategoryListPage({Key key}) : super(key: key);
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[700]),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: AutoSizeText(
          'categories'.tr(),
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          NotificationIcon(
              onPressed: () =>
                  Navigator.of(context).push(NotificationsPage.route())),
          ShoppingCartIcon(
              onPressed: () =>
                  Navigator.of(context).push(CheckOutPage.route())),
        ],
      ),
      body: BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
        List<HiliaCategory> categories = (state.categoriesState.data
                  ..sort((a, b) => a.sequence.compareTo(b.sequence)))
                .where((e) => e.children.length > 0 && !e.suggestedProducts)
                .toList() ??
            [];
        return ListView(
          children: [
            Hero(
              tag: "searchBar",
              child: CustomCard(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: TextField(
                  onTap: () => Navigator.of(context).push(SearchPage.route()),
                  decoration: InputDecoration(
                    hintText: "search".tr() + "...",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search_outlined),
                  ),
                  readOnly: true,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                HiliaCategory category = categories[index];
                var children = [
                  Expanded(
                    flex: 3,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        width: double.infinity,
                        child: CustomCard(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            color:  Color(0xFF102c3b).withOpacity(0.8),
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: Hero(
                                      tag: 'categ${category.id}',
                                      child: category.imageWidget(),
                                    ),
                                  )),
                                  AutoSizeText(
                                    category.name,
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: CustomCard(
                        child: Container(
                          child: Wrap(
                            children: category.children
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 0.0),
                                      child: InkWell(
                                        onTap: () => Navigator.of(context).push(
                                            CategoryPage.route(category.id,
                                                childId: e.id)),
                                        child: Chip(
                                          label: AutoSizeText(
                                            e.name,
                                            style:
                                                TextStyle(color:  Color(0xFF102c3b)),
                                          ),
                                          backgroundColor: Colors.white,
                                          shadowColor: Color(0xFF102c3b),
                                          elevation: 3,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (index % 2 == 0)
                        ? children
                        : children.reversed.toList(),
                  ),
                );
              },
              itemCount: categories.length,
            ),
          ],
        );
      }),
    );
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

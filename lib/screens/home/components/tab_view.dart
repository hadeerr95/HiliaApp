import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'product_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'category_card.dart';

class CategView extends StatefulWidget {
  const CategView({
    Key key,
    @required this.category,
  }) : super(key: key);

  final HiliaCategory category;

  @override
  _CategViewState createState() => _CategViewState();
}

class _CategViewState extends State<CategView> {
  List<HiliaCategory> subCategories;
  HiliaCategory subCategory;
  List<Product> products = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    BlocProvider.of<CatalogCubit>(context).catalogStarted();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
      // if (subCategories == null)
      //   subCategories = state.getCategoriesByParentId(widget.category.id);

      // if (products.isEmpty &&
      //     subCategory == null &&
      //     state.getProductsByParentCategoryId(widget.category.id).isNotEmpty) {
      //   products = state.getProductsByParentCategoryId(widget.category.id);
      // }
      return Container(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                // body = AutoSizeText("pull up load");
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
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              subCategories?.isNotEmpty ?? false
                  ? Container(
                      margin: EdgeInsets.all(8.0),
                      height: MediaQuery.of(context).size.height / 9,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: subCategories.length + 1,
                          itemBuilder: (_, index) => InkWell(
                                child: CategoryCard(
                                  category: index == 0
                                      ? HiliaCategory(
                                          name: "all".tr(),
                                          def: Image.asset('assets/all.png'))
                                      : subCategories[index - 1],
                                ),
                                onTap: () {
                                  setState(() {
                                    // if (index == 0) {
                                    //   products =
                                    //       state.getProductsByParentCategoryId(
                                    //           widget.category.id);
                                    // } else {
                                    //   subCategory = subCategories[index - 1];
                                    //   products = state.getProductsByCategoryId(
                                    //       subCategory.id);
                                    // }
                                  });
                                },
                              )),
                    )
                  : SizedBox(),
              Builder(
                builder: (BuildContext context) {
                  return Container(
                    padding:
                        EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                    child: Column(children: [
                      ProductGridView(
                        products: products,
                        onMaxScrollExtent: () {
                          (subCategories.isNotEmpty
                                  ? subCategories
                                  : [widget.category])
                              .forEach((e) {
                            // BlocProvider.of<CatalogCubit>(context)
                            //     .productCategLoad(categId: e.id);
                          });
                          print("onMaxScrollExtent");
                        },
                      ),
                    ]),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}

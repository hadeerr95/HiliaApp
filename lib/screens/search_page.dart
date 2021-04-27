import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/product/view_product_page.dart';
import 'package:app/screens/components/widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rubber/rubber.dart';

enum SortBy { NameFromAToZ, NameFromZToA, PriceDesr, PriceIncr, None }

class SearchPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SearchPage());
  }

  const SearchPage({Key key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  // String selectedPeriod;
  // int selectedDif = 100;
  HiliaCategory selectedCateg;
  SortBy dropdownValue;
  RangeValues _currentRangeValues;

  double get highestPrice {
    List<Product> products =
        BlocProvider.of<CatalogCubit>(context).state.allProduct;
    double bp =
        products.isNotEmpty ? (products?.first?.listPrice ?? 0.0) : 100.0;
    BlocProvider.of<CatalogCubit>(context).state.allProduct.forEach((e) {
      if (e.listPrice > bp) bp = e.listPrice;
    });
    return bp;
  }

  List<Product> searchResults = [];

  TextEditingController searchController = TextEditingController();

  RubberAnimationController _controller;

  @override
  void initState() {
    _currentRangeValues = RangeValues(0, highestPrice);
    _controller = RubberAnimationController(
        vsync: this,
        halfBoundValue: AnimationControllerValue(percentage: 0.4),
        upperBoundValue: AnimationControllerValue(percentage: 0.4),
        lowerBoundValue: AnimationControllerValue(pixel: 50),
        duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

  // void _expand() {
  //   _controller.expand();
  // }

  Widget _getLowerLayer() {
    return Column(
      children: <Widget>[
        Hero(
          tag: "searchBar",
          child: CustomCard(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "search".tr() + "...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search_outlined),
                    ),
                    autofocus: true,
                    controller: searchController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        List<Product> tempList = List<Product>();
                        BlocProvider.of<CatalogCubit>(context)
                            .state
                            .allProduct
                            .forEach((product) {
                              print("PRODUCT IS ${product.toJson}");
                          if (product.name.toLowerCase().contains(value)) {
                            // if (selectedCateg == null ||
                            //     product.publicCategIds
                            //         .contains(selectedCateg.id)) {
                            //   if (product.listPrice >
                            //           _currentRangeValues.start &&
                            //       product.listPrice < _currentRangeValues.end)
                                tempList.add(product);
                            // }
                          }
                        });
                        setState(() {
                          searchResults.clear();
                          searchResults.addAll(tempList);
                        });
                        return;
                      } else {
                        print("VALUE IS EMPTY");
                        setState(() {
                          searchResults.clear();
                          searchResults.addAll(
                              BlocProvider.of<CatalogCubit>(context)
                                  .state
                                  .allProduct);
                        });
                      }
                    },
                  ),
                ),
                CloseButton(),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.orange, width: 1))),
        ),
        Flexible(
          child: Container(
            color: Colors.orange[50],
            child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (_, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context)
                          ..pop()
                          ..push(ViewProductPage.route(
                              id: searchResults[index].id));
                      },
                      title: AutoSizeText(searchResults[index].name),
                    ))),
          ),
        )
      ],
    );
  }

  Widget _getUpperLayer() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, -3),
              blurRadius: 10)
        ],
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(24), topLeft: Radius.circular(24)),
        color: Colors.white,
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                'filters'.tr(),
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: AutoSizeText(
                      "price".tr(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  RangeSlider(
                    values: _currentRangeValues,
                    min: 0,
                    max: highestPrice,
                    divisions: (highestPrice / 10).round(),
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                      });
                    },
                  ),
                ],
              ),
              Container(
                height: 50,
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return Center(
                        child: IconButton(
                            icon: Icon(Icons.delete_forever),
                            onPressed: () {
                              setState(() {
                                selectedCateg = null;
                              });
                            }),
                      );
                    }
                    index -= 1;
                    return Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedCateg =
                                  BlocProvider.of<CatalogCubit>(context)
                                      .state
                                      .getChildrenCategories[index];
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 20.0),
                              decoration: selectedCateg ==
                                      BlocProvider.of<CatalogCubit>(context)
                                          .state
                                          .getChildrenCategories[index]
                                  ? BoxDecoration(
                                      color: Color(0xffFDB846),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(45)))
                                  : BoxDecoration(),
                              child: AutoSizeText(
                                BlocProvider.of<CatalogCubit>(context)
                                    .state
                                    .getChildrenCategories[index]
                                    .name,
                                style: TextStyle(fontSize: 16.0),
                              ))),
                    ));
                  },
                  itemCount: BlocProvider.of<CatalogCubit>(context)
                          .state
                          .getChildrenCategories
                          .length +
                      1,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: AutoSizeText(
                    "sort".tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: DropdownButton<SortBy>(
                    isExpanded: true,
                    value: dropdownValue, //"Sort By",
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    hint: AutoSizeText("sort_by".tr()),
                    onChanged: (SortBy newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        if (newValue == SortBy.NameFromAToZ)
                          searchResults
                              .sort((a, b) => a.name.compareTo(b.name));
                        else if (newValue == SortBy.NameFromZToA)
                          searchResults = searchResults
                            ..sort((a, b) => b.name.compareTo(a.name));
                        else if (newValue == SortBy.PriceDesr)
                          searchResults.sort(
                              (a, b) => b.listPrice.compareTo(a.listPrice));
                        else if (newValue == SortBy.PriceIncr)
                          searchResults.sort(
                              (a, b) => a.listPrice.compareTo(b.listPrice));
                      });
                    },
                    items: <SortBy>[
                      // SortBy.None,
                      SortBy.NameFromAToZ,
                      SortBy.NameFromZToA,
                      SortBy.PriceDesr,
                      SortBy.PriceIncr
                    ].map<DropdownMenuItem<SortBy>>((SortBy value) {
                      return DropdownMenuItem<SortBy>(
                        value: value,
                        child: value == SortBy.NameFromAToZ
                            ? Container(
                                child: AutoSizeText(
                                  "sort_by_name_a_to_z".tr(),
                                  softWrap: true,
                                  maxLines: 1,
                                ),
                              )
                            : value == SortBy.NameFromZToA
                                ? Container(
                                    child: AutoSizeText(
                                      "sort_by_name_z_to_a".tr(),
                                      softWrap: true,
                                      maxLines: 1,
                                    ),
                                  )
                                : value == SortBy.PriceDesr
                                    ? Container(
                                        child: AutoSizeText(
                                          "decreasing_sort".tr(),
                                          softWrap: true,
                                          maxLines: 1,
                                        ),
                                      )
                                    : value == SortBy.PriceIncr
                                        ? Container(
                                            child: AutoSizeText(
                                              "increasing_sort".tr(),
                                              softWrap: true,
                                              maxLines: 1,
                                            ),
                                          )
                                        : AutoSizeText(""),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: RubberBottomSheet(
            lowerLayer: _getLowerLayer(), // The underlying page (Widget)
            upperLayer: _getUpperLayer(), // The bottomsheet content (Widget)
            animationController: _controller, // The one we created earlier
          ),
        );
      },
    );
  }
}

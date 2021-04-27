import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/home/home_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/screens/notifications_page.dart';
import 'package:app/screens/shop/check_out_page.dart';

import 'components/components.dart';
import 'home/components/product_list_view.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key key}) : super(key: key);

  // static Route route(Map args) {
  //   return MaterialPageRoute<void>(builder: (_) => FavoritePage());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        title: AutoSizeText(
          'favorite'.tr(),
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          NotificationIcon(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => NotificationsPage()))),
          ShoppingCartIcon(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CheckOutPage()))),
        ],
      ),
      body: BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
        state.favState.data.forEach((e) {
          if (!state.productsState.items.any((item) => item.data?.id == e))
            context.bloc<CatalogCubit>().loadProduct(e);
        });
        List<Product> products = BlocProvider.of<CatalogCubit>(context)
            .state
            .allProduct
            ?.where((e) => state.favState?.data?.contains(e.id) ?? false)
            ?.toList();
        return products?.isNotEmpty ?? false
            ? ProductListView(
                products: products,
              )
            : Center(
                child: FlatButton.icon(
                  onPressed: Navigator.of(context).canPop()
                      ? () => Navigator.of(context).pop()
                      : null,
                  icon: Icon(Icons.arrow_back),
                  label: AutoSizeText('choose_your_favorites'.tr()),
                ),
              );
      }),
    );
  }
}

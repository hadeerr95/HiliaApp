import 'package:app/app_properties.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:easy_localization/easy_localization.dart';
import 'order_view_page.dart';

class OrdersPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OrdersPage());
  }

  const OrdersPage({Key key}) : super(key: key);
  // static const List _tabs = [
  //   ["All", null],
  //   ["Quotation Sent", OrderStatus.QuotationSent],
  //   ["Sales Order", OrderStatus.SalesOrder],
  //   ["Locked Order", OrderStatus.LockedOrder],
  //   ["Cancelled Order", OrderStatus.CancelledOrder],
  // ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      // DefaultTabController(
      //   length: _tabs.length,
      //   child:
      return Scaffold(
        appBar: AppBar(
          title: AutoSizeText("my_orders".tr(),
              style: TextStyle(color: Colors.grey[700])),
          iconTheme: IconThemeData(color: yellow),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // bottom: TabBar(
          //     isScrollable: true,
          //     unselectedLabelColor: Colors.teal,
          //     indicator: BoxDecoration(
          //       border: Border.all(
          //           color: Colors.teal, width: 2, style: BorderStyle.solid),
          //       borderRadius: BorderRadius.all(Radius.circular(25)),
          //       color: Colors.teal,
          //     ),
          //     tabs: _tabs
          //         .map((e) => Tab(
          //               child: AutoSizeText(e[0]),
          //             ))
          //         .toList(),
          //         ),
        ),
        body: OrdersList(orders: state.user.orders),
        // body: TabBarView(
        //     children: _tabs
        //         .map<Widget>((tab) => Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: OrdersList(
        //                   orders: state.orders
        //                       .where((e) =>
        //                           tab[1] == null || e.orderStatus == tab[1])
        //                       .toList()),
        //             ))
        //         .toList()),
      );
    });
    // );
  }
}

class OrdersList extends StatefulWidget {
  final List<SaleOrder> orders;

  const OrdersList({Key key, @required this.orders}) : super(key: key);

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // BlocProvider.of<UserCubit>(context).loadOrders(reload: true);
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
  Widget build(BuildContext context) {
    // context.bloc<UserCubit>().loadOrders();
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      // state.orderLines.forEach((e) {
      //   print(e.toJson);
      // });
      return SmartRefresher(
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
        child: ListView.builder(
          itemBuilder: (context, index) {
            SaleOrder order = state.user?.orders?.firstWhere(
                (e) => e.id == widget.orders[index].id,
                orElse: () => null);
            return Card(
              child: ListTile(
                tileColor: Colors.white,
                title: AutoSizeText(order.name ?? ""),
                subtitle: AutoSizeText("${order.dateOrder ?? ""}"),
                trailing: AutoSizeText(
                    "${order.orderLines.fold(0.0, (pV, e) => pV + e.totalPrice)}"),
                onTap: () => Navigator.of(context)
                    .push(OrderViewPage.route(id: order.id)),
              ),
            );
          },
          itemCount: widget.orders.length,
        ),
      );
    });
  }
}

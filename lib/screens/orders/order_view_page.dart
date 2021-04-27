import 'dart:io';
import 'dart:math';

import 'package:app/app_properties.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/config.dart';
import 'package:app/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/screens/components/components.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/services/service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OrderViewPage extends StatefulWidget {
  static Route route({int id}) {
    return MaterialPageRoute<void>(builder: (_) => OrderViewPage(id: id));
  }

  final int id;

  const OrderViewPage({Key key, @required this.id}) : super(key: key);

  @override
  _OrderViewPageState createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  String errorMsg;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        SaleOrder order = state.user?.orders
            ?.firstWhere((e) => e.id == widget.id, orElse: () => null);
        if (order == null) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        // double untaxedPrice = order?.saleOrderLines
        //         ?.fold<double>(0.0, (pV, e) => pV + e.totalPrice) ??
        //     0.0;
        // appBar: AppBar(
        //   title: AutoSizeText("Order ${order?.name ?? ""}",
        //       style: TextStyle(color: yellow)),
        //   iconTheme: IconThemeData(color: yellow),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        // Container(
        //     height: 120,
        //     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        //     child: Card(
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: SingleChildScrollView(
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   AutoSizeText("Untaxed Amount:"),
        //                   AutoSizeText("Taxes:"),
        //                   SizedBox(height: 16),
        //                   AutoSizeText("Total:",
        //                       style: TextStyle(fontWeight: FontWeight.bold)),
        //                 ],
        //               ),
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   AutoSizeText("\$ $untaxedPrice"),
        //                   AutoSizeText("\$ $texes"),
        //                   SizedBox(height: 16),
        //                   AutoSizeText("\$ ${untaxedPrice + texes}",
        //                       style: TextStyle(fontWeight: FontWeight.bold)),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   )
        return Scaffold(
          appBar: AppBar(
            title: AutoSizeText("${order?.name ?? ""}",
                style: TextStyle(color: yellow)),
            iconTheme: IconThemeData(color: yellow),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          floatingActionButton: order?.orderStatus != OrderStatus.SalesOrder
              ? Opacity(
                  opacity: 0.5,
                  child: FloatingActionButton.extended(
                    icon: IconButton(
                      icon: Icon(Icons.payment),
                      onPressed: () => showPaymentPage(context, order),
                    ),
                    onPressed: null,
                    label: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () => refreshOrder(context, order),
                    ),
                  ),
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AutoSizeText("Date: ${order?.dateOrder ?? ""}"),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: BaseContact(
                      partner: order?.partnerInvoice,
                      header: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AutoSizeText(
                          "Invoicing Address",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: BaseContact(
                      partner: order?.partnerShipping,
                      header: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AutoSizeText(
                          "Shipping Address",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                ProductLines(
                  lines: order?.orderLines,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ProductLines extends StatelessWidget {
  final List<SaleOrderLine> lines;

  const ProductLines({Key key, @required this.lines}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: lines?.map((e) {
            Product p = BlocProvider.of<CatalogCubit>(context)
                .state
                .getProductByVariantId(e.variant?.id);
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  p?.imageWidget(width: 80) ?? SizedBox(),
                  SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            "${e.variant?.name ?? ""}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2, left: 2),
                            child: AutoSizeText(
                              "${p?.description ?? ""}",
                              style: TextStyle(color: Colors.black54),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AutoSizeText(e.priceUnit.toString()),
                        Chip(label: AutoSizeText("Qty ${e.productsQty}")),
                      ],
                    ),
                  )
                ],
              ),
            );
          })?.toList() ??
          [],
    );
  }
}

void showPaymentPage(BuildContext context, SaleOrder order) async {
  try {
    if (order.acquirerPaymentUrl == null || order.acquirerPaymentUrl.isEmpty)
      throw Exception();
    String url = ServerUrl + order.acquirerPaymentUrl;

    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;
    if (Platform.isIOS || sdkInt >= 20) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.grey[700]),
              title: Text(
                "payment".tr(),
                style: TextStyle(color: Colors.grey[700]),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('hilia://')) {
                  refreshOrder(context, order);
                  Navigator.of(context, rootNavigator: true).pop();
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          ),
        ),
      );
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw Exception();
      }
    }
  } catch (e) {
    print(e);
    Fluttertoast.showToast(
        msg: 'something_is_wrong'.tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    if (order.acquirerPaymentUrl != null &&
        order.acquirerPaymentUrl.isNotEmpty) {
      String url = ServerUrl + order.acquirerPaymentUrl;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                child: AutoSizeText('copy_failed_msg'.tr()),
              ),
              TextFormField(
                initialValue: url,
                readOnly: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
                child: AutoSizeText('copy'.tr()),
                onPressed: () {
                  try {
                    Clipboard.setData(ClipboardData(text: url));

                    Fluttertoast.showToast(
                        msg: 'url_copied_succeeded'.tr(),
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: 'url_copied_failed'.tr(),
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }),
            FlatButton(
                child: AutoSizeText('cancel'.tr()),
                onPressed: () => Navigator.pop(context)),
          ],
        ),
      );
    }
  }
}

void refreshOrder(BuildContext context, SaleOrder order) async {
  String errorMsg;
  try {
    showHiliaProgress(context);
    ApiService apiService = ApiService.instance;
    SaleOrder saleOrder = await apiService.getOrder(order.id);
    BlocProvider.of<AuthenticationBloc>(context)
        .add(OrderStatusChanged(saleOrder));

    Navigator.of(context, rootNavigator: true).pop();
  } on RequestFailed {
    errorMsg = "request_failed".tr();
  } on ServerProblem {
    errorMsg = "server_problem".tr();
  } on ConnectionFailure {
    errorMsg = "connection_failed".tr();
  } catch (e) {
    errorMsg = 'something_is_wrong'.tr();
  } finally {
    if (errorMsg != null) {
      Navigator.of(context, rootNavigator: true).pop();

      Fluttertoast.showToast(
          msg: errorMsg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

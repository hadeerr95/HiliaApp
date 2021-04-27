import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/components.dart';
import 'package:app/screens/components/hilia_scaffold.dart';
import 'package:app/screens/contact/address_form.dart';
import 'package:app/screens/home/components/exclusive.dart';
import 'package:app/screens/orders/order_view_page.dart';
import 'package:app/screens/payment/unpaid_page.dart';
import 'package:app/screens/product/view_product_page.dart';
import 'package:app/services/service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pedantic/pedantic.dart';

import 'components/select_address.dart';

enum CheckOutSteps {
  reviewCart,
  selectShippingMethod,
  selectAddress,
  selectpayment
}

class CheckOutPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CheckOutPage());
  }

  const CheckOutPage({Key key}) : super(key: key);
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage>
    with SingleTickerProviderStateMixin {
  List<CartItem> _cart = [];
  List<LoaderState<Product>> productsState = [];
  SaleOrder _order = SaleOrder();
  BottomBarController _bottomBarController;

  CheckOutSteps checkOutStep = CheckOutSteps.reviewCart;
  int _currentStep = 0;
  String errorMsg;

  @override
  void initState() {
    _bottomBarController = BottomBarController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
        if (_cart.isEmpty) {
          if (state.cartState.data.isNotEmpty)
            _cart = state.cartState.data;
          else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.assignment_late_outlined,
                    size: 64,
                    color: Colors.grey.withOpacity(.5),
                  ),
                  FlatButton.icon(
                      onPressed: Navigator.of(context).canPop()
                          ? () => Navigator.of(context)
                              .popUntil((predicate) => predicate.isFirst)
                          : null,
                      textColor: Colors.blue,
                      icon: Icon(Icons.arrow_back_ios),
                      label: AutoSizeText(
                        'coutinue_shopping'.tr(),
                        maxLines: 1,
                      )),
                ],
              ),
            );
          }
        }

        _cart.map((e) => e.productId).toSet().forEach((e) {
          if (!state.productsState.items.any((item) => item.data.id == e))
            unawaited(context.bloc<CatalogCubit>().loadProduct(e));
        });

        productsState = state.productsState.items
            .where((item) => _cart.any((e) => item.data.id == e.productId))
            .toList();

        List<Product> products = productsState
            .where((item) => item.data?.variants?.isNotEmpty ?? false)
            .map((e) => e.data)
            .toList();

        _order = _order.copyWith(SaleOrder(
            orderLines: _cart
                .where(
                    (e) => products.any((product) => e.productId == product.id))
                .map((e) => SaleOrderLine(
                    variant: state.getVariant(e.variantId),
                    productsQty: e.qty,
                    priceUnit: state.getVariant(e.variantId).lstPrice))
                .toList()));
        double minimumFreeShipping = context
                .bloc<AuthenticationBloc>()
                .state
                .user
                .setting
                ?.minimumAmountForFreeShipping ??
            0;
        List<Step> _steps = [
          Step(
            isActive: _currentStep == 0,
            title: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.grey[700],
            ),
            content: reviewCart(products),
            state: _currentStep == 0
                ? StepState.editing
                : order.orderLines.isNotEmpty
                    ? StepState.complete
                    : StepState.error,
          ),
          Step(
            isActive: _currentStep == 1,
            title: Icon(
              Icons.delivery_dining,
              color: Colors.grey[700],
            ),
            content: shippingMethods(),
            state: _currentStep == 1
                ? StepState.editing
                : _order.totalPrice <= minimumFreeShipping
                    ? StepState.disabled
                    : _order.shippingService?.id != null
                        ? StepState.complete
                        : StepState.error,
          ),
          Step(
            isActive: _currentStep == 2,
            title: Icon(
              Icons.location_on_outlined,
              color: Colors.grey[700],
            ),
            content: selectAddress(),
            state: _currentStep == 2
                ? StepState.editing
                : _order.partnerInvoice != null &&
                        _order.partnerShipping != null
                    ? StepState.complete
                    : StepState.error,
          ),
          Step(
            isActive: _currentStep == 3,
            title: Icon(
              Icons.payment,
              color: Colors.grey[700],
            ),
            content: paymentMethods(),
            state: _currentStep == 3
                ? StepState.editing
                : _order.paymentAcquirer != null
                    ? StepState.complete
                    : StepState.error,
          ),
        ];

        return Scaffold(
          appBar: HiliaAppBar(
            title: Text(
              "check_out".tr(),
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          body: Stepper(
            currentStep: _currentStep,
            type: StepperType.horizontal,
            onStepTapped: (i) =>
                _currentStep != i ? setState(() => _currentStep = i) : null,
            controlsBuilder: (context, {onStepCancel, onStepContinue}) {
              return SizedBox();
            },
            steps: _steps,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: GestureDetector(
            onVerticalDragUpdate: _bottomBarController.onDrag,
            onVerticalDragEnd: _bottomBarController.onDragEnd,
            child: FloatingActionButton.extended(
              label: AutoSizeText("my_order".tr()),
              elevation: 2,
              backgroundColor:  Color(0xFF102c3b),
              foregroundColor: Colors.white,
              onPressed: () => _bottomBarController.swap(),
            ),
          ),
          bottomNavigationBar: BottomExpandableAppBar(
            controller: _bottomBarController,
            expandedHeight: MediaQuery.of(context).size.height / 2,
            horizontalMargin: 16,
            shape: AutomaticNotchedShape(
                RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
            expandedBackColor: Colors.blue.withOpacity(.1),
            expandedBody: Container(
              margin: EdgeInsets.only(
                  top: 24,
                  right: 8.0,
                  left: 8.0,
                  bottom: kBottomNavigationBarHeight),
              child: ListView(
                children: [
                  CheckoutDetails(order: order),
                  order.partnerInvoice != null
                      ? BaseContact(
                          partner: order.partnerInvoice,
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText("bill_to".tr()),
                          ))
                      : SizedBox(),
                  order.partnerShipping != null
                      ? BaseContact(
                          partner: order.partnerShipping,
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText("ship_to".tr()),
                          ))
                      : SizedBox(),
                  order.paymentAcquirer != null
                      ? Card(
                          child: ListTile(
                            leading: order.paymentAcquirer.imageWidget(),
                            title: AutoSizeText(order.paymentAcquirer.name),
                            subtitle: AutoSizeText("pay_by".tr()),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            bottomAppBarBody: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: _currentStep == 0
                        ? backToHomeButton
                        : TextButton(
                            onPressed: _currentStep > 0
                                ? () {
                                    setState(() => _currentStep -=
                                        _currentStep == 2 &&
                                                order.totalPrice <=
                                                    minimumFreeShipping
                                            ? 2
                                            : 1);
                                  }
                                : null,
                            child: Row(
                              children: [
                                Icon(Icons.arrow_back_ios),
                                Expanded(
                                  child: AutoSizeText(
                                    (_currentStep == 1
                                            ? 'shopping_cart'
                                            : _currentStep == 2 &&
                                                    _order.totalPrice <=
                                                        minimumFreeShipping
                                                ? 'shopping_cart'
                                                : _currentStep == 2
                                                    ? 'delivery_and_shipping'
                                                    : _currentStep == 3
                                                        ? 'address'
                                                        : 'cancel')
                                        .tr(),
                                    maxLines: 2,
                                    maxFontSize: 18,
                                    minFontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                      child: _currentStep == 3
                          ? checkoutButton
                          : TextButton(
                              onPressed: _currentStep < _steps.length - 1
                                  ? () {
                                      setState(() => _currentStep +=
                                          _currentStep == 0 &&
                                                  order.totalPrice <=
                                                      minimumFreeShipping
                                              ? 2
                                              : 1);
                                    }
                                  : null,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      (_currentStep == 0 &&
                                                  _order.totalPrice <=
                                                      minimumFreeShipping
                                              ? 'address'
                                              : _currentStep == 0
                                                  ? 'delivery_and_shipping'
                                                  : _currentStep == 1
                                                      ? 'address'
                                                      : 'payment_method')
                                          .tr(),
                                      maxLines: 2,
                                      maxFontSize: 18,
                                      minFontSize: 8,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )),
                ),
              ],
            ),
          ),
        );
        // return SingleChildScrollView(
        //   physics: ClampingScrollPhysics(),
        //   child: ConstrainedBox(
        //     constraints:
        //         BoxConstraints(minHeight: constraints.maxHeight),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         SizedBox(
        //           height: 300,
        //           child: Scrollbar(
        //             child: ,
        //           ),
        //         ),
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: AutoSizeText(
        //     'Payment',
        //     style: TextStyle(
        //         fontSize: 20,
        //         color: darkGrey,
        //         fontWeight: FontWeight.bold),
        //   ),
        // ),
        // SizedBox(
        //   height: 250,
        //   child: Swiper(
        //     itemCount: 2,
        //     itemBuilder: (_, index) {
        //       return CreditCard();
        //     },`
        //     scale: 0.8,
        //     controller: swiperController,
        //     viewportFraction: 0.6,
        //     loop: false,
        //     fade: 0.7,
        //   ),
        // ),
        //       ],
        //     ),
        //   ),
        // );
      }),
    );
  }

  Widget shippingMethods() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (order.shippingService == null)
        order = SaleOrder(
            shippingService: state.user.setting.shippingServices
                    ?.firstWhere((element) => true, orElse: () => null)
                    ?.variants
                    ?.firstWhere((element) => true, orElse: () => null) ??
                Variant());
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              "shipping_method".tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: state.user.setting.shippingServices
                .map<Widget>((product) => CustomCard(
                        child: Column(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color:  Color(0xFF102c3b), width: 2),
                                ),
                                padding: EdgeInsets.all(2.0),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        height: double.infinity,
                                        child: Container(
                                          child: Hero(
                                              tag: 'product${product.id}',
                                              child: product.imageWidget(
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    )),
                              ),
                              title: AutoSizeText(product.name),
                              subtitle: product.description != null
                                  ? AutoSizeText(product.description)
                                  : null,
                            ),
                          ),
                          Divider(height: 0),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: product.variants
                                    .map<Widget>((variant) => InkWell(
                                          onTap: () {
                                            if (order.shippingService?.id !=
                                                variant.id)
                                              order = SaleOrder(
                                                  shippingService: variant);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: CustomCard(
                                              color: Colors.white,
                                              child: Container(
                                                color:
                                                    order.shippingService.id ==
                                                            variant.id
                                                        ? Colors.blue
                                                            .withOpacity(.5)
                                                        : Colors.grey
                                                            .withOpacity(.1),
                                                child: ListTile(
                                                  // leading: FittedBox(
                                                  //   fit: BoxFit.contain,
                                                  //   child: Icon(Icons
                                                  //       .check_circle),
                                                  // ),
                                                  title: AutoSizeText(
                                                      variant.name,
                                                      maxLines: 1),
                                                  subtitle: AutoSizeText(
                                                      variant.lstPrice
                                                          .toString(),
                                                      maxLines: 1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              )),
                        ],
                      ),
                    ])))
                .toList(),
          ),
        ],
      );
    });
  }

  Widget reviewCart(List<Product> products) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state.user != null) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              productsState.any((e) => e.status == LoaderStatus.loading) ||
                      productsState.isEmpty
                  ? LinearProgressIndicator()
                  : productsState.any((e) => e.status == LoaderStatus.failed)
                      ? Container(height: 5, color: Colors.red)
                      : SizedBox(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: (state.user.setting.minimumAmountForFreeShipping ?? 0) <
                        _order.totalPrice
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      )
                    : SizedBox(),
              ),
              CartItems(
                cart: cart,
                products: products,
                updateCart: (c) => cart = c,
                updateOrder: (o) => order = o,
              ),
              SuggestedProducts(),
            ],
          ),
        );
      }
      return SizedBox();
    });
  }

  SaleOrder get order => _order;

  set order(SaleOrder v) {
    _order = _order.copyWith(v);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  get cart => _cart;

  set cart(List<CartItem> c) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _cart = c;
      });
    });

    unawaited(context.bloc<CatalogCubit>().updateCart(c));
  }

  Widget get backToHomeButton => TextButton(
      child: AutoSizeText(
        'coutinue_shopping'.tr(),
        maxLines: 2,
        minFontSize: 8,
      ),
      onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst));

  Widget get checkoutButton =>
      BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        bool isGoodOrder = order.isGoodPartners &&
            (order.totalPrice <=
                    state.user.setting.minimumAmountForFreeShipping ||
                order.shippingService?.id != null) &&
            order.paymentAcquirer != null;
        return RaisedButton(
          color: Colors.blue,
          child: AutoSizeText(
            'check_out'.tr(),
            style: TextStyle(color: Colors.white),
          ),
          onPressed: isGoodOrder
              ? () async {
                  try {
                    errorMsg = null;
                    showHiliaProgress(context);
                    ApiService apiService = ApiService.instance;
                    SaleOrder saleOrder = await apiService.checkout(order);

                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(Checkout(saleOrder));

                    cart = [];

                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context)
                      ..popUntil((r) => r.isFirst)
                      ..push(OrderViewPage.route(id: saleOrder.id));

                    showPaymentPage(context, saleOrder);
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
              : null,
        );
      });

  Widget selectAddress() {
    return Container(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        Partner partner = state.user?.partner;
        if ((partner == null) || !(partner?.isGood ?? false)) {
          return Column(
            children: [
              state.status == AuthenticationStatus.authenticated
                  ? SizedBox()
                  : UserAuthCard(),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(8.0),
                child: AddressForm(
                  title: AutoSizeText(
                    "your_address".tr(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  partner: partner,
                ),
              ),
            ],
          );
        }
        if (order.partner?.id != null && order.partner.id != partner.id ||
            partner?.id == null) {
          order = SaleOrder(
              partner: Partner(),
              partnerInvoice: Partner(),
              partnerShipping: Partner());
        }
        order = SaleOrder(partner: partner);
        order = SaleOrder(partnerInvoice: partner);
        if (order.partnerShipping?.id == null)
          order = SaleOrder(partnerShipping: partner);
        return SelectAddress(
          order: order,
          updateOrder: (o) => order = o,
        );
      }),
    );
  }

  Widget paymentMethods() {
    return Container(child:
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "payment_method".tr(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.user.setting.acquirers
                  .map((e) => InkWell(
                      onTap: () {
                        if (order.paymentAcquirer?.id != e.id)
                          order = SaleOrder(paymentAcquirer: e);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CustomCard(
                          color: Colors.white,
                          child: Container(
                            color: order.paymentAcquirer?.id == e.id
                                ? Colors.blue.withOpacity(.5)
                                : Colors.grey.withOpacity(.1),
                            child: ListTile(
                              leading: e.imageWidget(),
                              title: AutoSizeText(e.name),
                            ),
                          ),
                        ),
                      )))
                  .toList(),
            ),
          ],
        ),
      );
    }));
  }
}

class SuggestedProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
      List<HiliaCategory> categories = state.categoriesState.data
              .where((e) => e.suggestedProducts == true)
              .toList() ??
          [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: categories
            .map((e) => e.allProducts.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(e.name),
                        ),
                        HGategList(products: e.allProducts),
                      ],
                    ),
                  )
                : SizedBox())
            .toList(),
      );
    });
  }
}

class CartItems extends StatelessWidget {
  final List<Product> products;
  final List<CartItem> cart;
  final void Function(List<CartItem>) updateCart;
  final void Function(SaleOrder) updateOrder;

  const CartItems({
    Key key,
    @required this.cart,
    @required this.products,
    @required this.updateCart,
    @required this.updateOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonBar(
          children: [
            IconButton(
                icon: Icon(
                  Icons.delete_sweep,
                  color: Colors.red,
                ),
                onPressed: () => updateCart([])),
            IconButton(
                icon: Image.asset('assets/icons/denied_wallet.png'),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => UnpaidPage()))),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        Column(
          children: products.map<Widget>((product) {
            return Card(
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context)
                        .push(ViewProductPage.route(id: product.id)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color:  Color(0xFF102c3b) , width: 2),
                          ),
                          padding: EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                height: double.infinity,
                                child: Container(
                                  child: Hero(
                                      tag: 'product${product.id}',
                                      child: product.imageWidget(
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: AutoSizeText(product.name),
                      ),
                    ),
                  ),
                  Column(
                    children: cart
                        .where((item) => item.productId == product.id)
                        .map((e) {
                      Variant variant = product.variants.firstWhere(
                          (variant) => variant.id == e.variantId,
                          orElse: () => null);
                      return Column(
                        children: [
                          Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    VariantAttributes(variant: variant),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                              variant.lstPrice.toString()),
                                          IconButton(
                                            tooltip: 'remove_product_from_cart?'
                                                .tr(),
                                            icon: Icon(
                                              Icons.delete_outline_outlined,
                                              color: Colors.red,
                                            ),
                                            onPressed: () => updateCart(cart
                                              ..removeWhere((item) =>
                                                  item.variantId ==
                                                  e.variantId)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                        ),
                                        onPressed: () {
                                          if (e.qty < 99) {
                                            int index = cart.indexWhere((e) =>
                                                e.variantId == e.variantId);
                                            cart[index] = cart[index].copyWith(
                                                qty: cart[index].qty + 1);
                                            updateCart(cart);
                                          }
                                        }),
                                    AutoSizeText(
                                      "${e.qty}",
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                        onPressed: () {
                                          if (e.qty > 1) {
                                            int index = cart.indexWhere((e) =>
                                                e.variantId == e.variantId);
                                            cart[index] = cart[index].copyWith(
                                                qty: cart[index].qty - 1);
                                            updateCart(cart);
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class NumberPickerQty extends StatelessWidget {
  const NumberPickerQty({
    Key key,
    @required this.sol,
    this.onChanged,
  }) : super(key: key);

  final SaleOrderLine sol;
  final Function(num) onChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          accentColor: Colors.black,
          textTheme: TextTheme(
              // headline: TextStyle(
              //     fontFamily: 'Montserrat',
              //     fontSize: 14,
              //     color: Colors.black,
              //     fontWeight: FontWeight.bold),
              // body1: TextStyle(
              //   fontFamily: 'Montserrat',
              //   fontSize: 12,
              //   color: Colors.grey[400],
              // ),
              )),
      child: NumberPicker.integer(
        initialValue: sol.productsQty.round(),
        minValue: 1,
        maxValue: 100,
        onChanged: onChanged,
        itemExtent: 30,
        listViewWidth: 40,
      ),
    );
  }
}

class VariantAttributes extends StatelessWidget {
  const VariantAttributes({
    Key key,
    @required this.variant,
  }) : super(key: key);

  final Variant variant;

  @override
  Widget build(BuildContext context) {
    if (variant.attributeValues?.isNotEmpty ?? false)
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: variant.attributeValues.map<Widget>((e) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(
                backgroundColor: Colors.grey.withOpacity(.1),
                avatar: e.attribute?.type == AttributeType.Color
                    ? CircleAvatar(
                        backgroundColor: colorByHtmlCode(e.htmlColor),
                      )
                    : null,
                label: AutoSizeText(e.attribute.name + ": " + e.name),
              ),
            );
          }).toList(),
        ),
      );
    else
      return SizedBox();
  }
}

class CheckoutDetails extends StatelessWidget {
  const CheckoutDetails({
    Key key,
    @required this.order,
  }) : super(key: key);

  final SaleOrder order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      double minimumFreeShipping =
          state.user.setting?.minimumAmountForFreeShipping ?? 0;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    'untaxed_price'.tr(),
                    style: TextStyle(fontSize: 16),
                  ),
                  AutoSizeText(
                    order.orderLines
                        .fold<double>(0.0, (v, e) => v + e.totalPrice)
                        .toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              order.totalPrice > minimumFreeShipping &&
                      order.shippingService?.lstPrice == null
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AutoSizeText(
                          'shipping_cost'.tr(),
                          style: TextStyle(fontSize: 16),
                        ),
                        AutoSizeText(
                          order.totalPrice > minimumFreeShipping
                              ? order.shippingService?.lstPrice?.toString()
                              : "free".tr(),
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
              // SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AutoSizeText(
                    'taxes'.tr(),
                    style: TextStyle(fontSize: 16),
                  ),
                  AutoSizeText(
                    "${0.0}",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AutoSizeText(
                    'total_price'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  AutoSizeText(
                    (order.totalPrice +
                            (order.totalPrice > minimumFreeShipping
                                ? (order?.shippingService?.lstPrice ?? 0)
                                : 0))
                        .toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

// class Scroll extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     // TODO: implement paint

//     LinearGradient grT = LinearGradient(
//         colors: [Colors.transparent, Colors.black26],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter);
//     LinearGradient grB = LinearGradient(
//         colors: [Colors.transparent, Colors.black26],
//         begin: Alignment.bottomCenter,
//         end: Alignment.topCenter);

//     canvas.drawRect(
//         Rect.fromLTRB(0, 0, size.width, 30),
//         Paint()
//           ..shader = grT.createShader(Rect.fromLTRB(0, 0, size.width, 30)));

//     canvas.drawRect(Rect.fromLTRB(0, 30, size.width, size.height - 40),
//         Paint()..color = Color.fromRGBO(50, 50, 50, 0.4));

//     canvas.drawRect(
//         Rect.fromLTRB(0, size.height - 40, size.width, size.height),
//         Paint()
//           ..shader = grB.createShader(
//               Rect.fromLTRB(0, size.height - 40, size.width, size.height)));
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     return false;
//   }
// }

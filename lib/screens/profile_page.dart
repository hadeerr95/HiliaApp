import 'package:app/app_properties.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/screens/contact/contact_details_page.dart';
import 'package:app/screens/faq_page.dart';
import 'package:app/screens/notifications_page.dart';
import 'package:app/screens/orders/orders_page.dart';
import 'package:app/screens/settings/settings_page.dart';
import 'package:app/screens/shop/check_out_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'components/widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // BlocProvider.of<UserCubit>(context).reload();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // void _onLoading() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (contaxt, authState) {
      // if (authState.status == AuthenticationStatus.authenticated)
      // context.bloc<UserCubit>().userAuth(authState.uid);
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey[700]),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: AutoSizeText(
            'account'.tr(),
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
        body: SmartRefresher(
          enablePullDown: true,
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
          // onLoading: _onLoading,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (contaxt, state) {
                      if (state.status == AuthenticationStatus.authenticated) {
                        return UserAccount();
                      } else if (state.status == AuthenticationStatus.unknown) {
                        return SizedBox();
                      } else {
                        return UserAuthCard();
                      }
                    }),
                    // ListTile(
                    //   title: AutoSizeText('my_orders'.tr()),
                    //   subtitle: AutoSizeText('order_history'.tr()),
                    //   leading: Image.asset(
                    //     'assets/icons/timer.png',
                    //     fit: BoxFit.scaleDown,
                    //     width: 30,
                    //     height: 30,
                    //   ),
                    //   trailing: Icon(Icons.chevron_right, color: yellow),
                    //   onTap: () =>
                    //       Navigator.of(context).pushNamed(NestedRoutes.order),
                    // ),
                    ListTile(
                      title: AutoSizeText('settings'.tr()),
                      subtitle: AutoSizeText('Privacy and logout'),
                      leading: Image.asset(
                        'assets/icons/settings.png',
                        fit: BoxFit.scaleDown,
                        width: 30,
                        height: 30,
                      ),
                      trailing: Icon(Icons.chevron_right, color: yellow),
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SettingsPage())),
                    ),
                    Divider(),
                    ListTile(
                      title: AutoSizeText('help_support'.tr()),
                      subtitle: AutoSizeText('Help center and legal support'),
                      leading: Image.asset('assets/icons/support.png'),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: yellow,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: AutoSizeText('faq'.tr()),
                      subtitle: AutoSizeText('Questions and Answer'),
                      leading: Image.asset('assets/icons/faq.png'),
                      trailing: Icon(Icons.chevron_right, color: yellow),
                      onTap: () => Navigator.of(context).push(FaqPage.route()),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class UserAccount extends StatelessWidget {
  const UserAccount({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (contaxt, state) {
      return Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            maxRadius: 48,
            backgroundImage: state.user?.partner?.imageProvider,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              state.user?.login ?? "",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF102c3b),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: Offset(0, 1))
                ]),
            height: 150,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     IconButton(
                  //       icon: Image.asset('assets/icons/wallet.png'),
                  //       onPressed: () =>
                  //           Navigator.of(context).push(WalletPage.route()),
                  //     ),
                  //     AutoSizeText(
                  //       'wallet'.tr(),
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     )
                  //   ],
                  // ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 70,
                          width: 70,
                          child: IconButton(
                              icon: Image.asset('assets/icons/orders.png'),
                              // icon: Icon(
                              //   Icons.location_on_outlined,
                              //   color: Colors.brown,
                              // ),
                              onPressed: () => Navigator.of(context)
                                  .push(OrdersPage.route())),
                        ),
                        AutoSizeText(
                          'my_orders'.tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 70,
                        width: 70,
                        child: IconButton(
                            icon: Image.asset('assets/icons/user-info.png'),
                            // icon: Icon(
                            //   Icons.location_on_outlined,
                            //   color: Colors.brown,
                            // ),
                            onPressed: () => Navigator.of(context)
                                .push(ContactDetailsPage.route())),
                      ),
                      AutoSizeText(
                        'contact'.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     IconButton(
                  //       icon: Image.asset('assets/icons/card.png'),
                  //       onPressed: () => Navigator.of(context)
                  //           .pushNamed(NestedRoutes.payment),
                  //     ),
                  //     AutoSizeText(
                  //       'payment'.tr(),
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     )
                  //   ],
                  // ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     IconButton(
                  //       icon: Image.asset(
                  //           'assets/icons/contact_us.png'),
                  //       onPressed: () {},
                  //     ),
                  //     AutoSizeText(
                  //       'support'.tr(),
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

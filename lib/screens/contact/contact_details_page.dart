import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/screens/components/widget.dart';
import 'package:app/screens/contact/address_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactDetailsPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ContactDetailsPage());
  }

  const ContactDetailsPage({Key key}) : super(key: key);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // BlocProvider.of<UserCubit>(context).loadPartners(reload: true);
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
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black87),
          title: AutoSizeText(
            'contact_details'.tr(),
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SmartRefresher(
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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BaseContact(
                  partner: state.user?.partner,
                  header: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [EditAddressButton(partner: state.user?.partner)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RaisedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: Dialog(
                          shape: BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: AddressDialog(
                              // partner:
                              //     Partner(parentId: state.getUserPartner().id),
                              ),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      AutoSizeText("add_an_shipping_address".tr())
                    ],
                  ),
                ),
              ),
              state.user.partner.contacts.isNotEmpty ?? false
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: Offset(0, 1))
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                "shipping_addresses".tr(),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: state.user.partner.contacts
                                  ?.map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: BaseContact(
                                        partner: e,
                                        header: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                icon: Icon(Icons.edit),
                                                color: Colors.lightBlue,
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      child: Dialog(
                                                        shape: BeveledRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: AddressDialog(
                                                          partner: e,
                                                        ),
                                                      ));
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  ?.toList(),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      );
    });
  }
}

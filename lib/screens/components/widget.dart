import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/auth/login_dialog.dart';
import 'package:app/screens/auth/signup_dialog.dart';
import 'package:app/screens/contact/address_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAuthCard extends StatelessWidget {
  const UserAuthCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      height: 80,
      child: Center(
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              child: AutoSizeText('login'.tr(), style: TextStyle(fontSize: 18)),
              onPressed: () => showDialog(
                  context: context,
                  child: Dialog(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: LoginDialog(),
                  )),
              // Navigator.of(context)
              //     .pushNamed(NestedRoutes.login),
              textColor: Colors.blue,
            ),
            FlatButton(
              child: AutoSizeText('create_account'.tr(),
                  style: TextStyle(fontSize: 18)),
              onPressed: () => showDialog(
                  context: context,
                  child: Dialog(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SignUpDialog(),
                  )),
              // Navigator.of(context)
              //     .pushNamed(NestedRoutes.signup),
              textColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class FavButton extends StatelessWidget {
  const FavButton({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
      return InkWell(
          child: Icon(
            state.favState?.data?.contains(product.id) ?? false
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.redAccent,
          ),
          onTap: () {
            state.favState?.data?.contains(product.id) ?? false
                ? context.bloc<CatalogCubit>().removeItemFromFav(product.id)
                : context.bloc<CatalogCubit>().addItemToFav(product.id);
          });
    });
  }
}

class CoustomButton extends StatelessWidget {
  const CoustomButton({
    Key key,
    @required this.icon,
    @required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.teal[50],
        ),
        child: icon,
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  final Product product;
  const PriceCard({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        color: Color(0xFF102c3b),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: AutoSizeText(
            BlocProvider.of<AuthenticationBloc>(context)
                .state
                .user
                .setting
                .priceWithCurrency(product.listPrice),
            style: TextStyle(color: Colors.white),
            softWrap: true,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class BaseContact extends StatefulWidget {
  final Partner partner;
  final Widget header;
  final Widget footer;
  BaseContact({
    Key key,
    @required this.partner,
    this.header,
    this.footer,
  }) : super(key: key);

  @override
  _BaseContactState createState() => _BaseContactState();
}

class _BaseContactState extends State<BaseContact> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.header ?? SizedBox(),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AutoSizeText(
                      "${widget.partner?.name ?? ""}",
                      maxLines: 1,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[700]),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.partner?.street != null
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      child: AutoSizeText(
                                        "${widget.partner?.street ?? ""}",
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            widget.partner?.city != null
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      child: AutoSizeText(
                                        "${widget.partner?.city ?? ""} ${widget.partner?.zip ?? ""}",
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            widget.partner?.country != null
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: AutoSizeText(
                                      "${widget.partner?.country?.name ?? ""} ${widget.partner?.state?.name ?? ""}",
                                      maxLines: 1,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      )
                    ],
                  ),
                  widget.partner?.phone != null
                      ? Row(
                          children: [
                            Icon(Icons.phone, color: Colors.grey[700]),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  "${widget.partner.phone}",
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  widget.partner?.email != null
                      ? Row(
                          children: [
                            Icon(Icons.mail, color: Colors.grey[700]),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  "${widget.partner.email}",
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Divider(height: 0),
            widget.footer ?? SizedBox(),
          ],
        ),
      );
    });
  }
}

class EditAddressButton extends StatelessWidget {
  final Partner partner;
  const EditAddressButton({
    Key key,
    this.partner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.edit),
        color: Colors.lightBlue,
        onPressed: () {
          showDialog(
              context: context,
              child: Dialog(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: AddressDialog(partner: partner),
              ));
        });
  }
}

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: AutoSizeText('', style: TextStyle(color: Colors.white)),
      child: IconButton(
          icon: Icon(Icons.notifications_outlined), onPressed: onPressed),
    );
  }
}

class ShoppingCartIcon extends StatelessWidget {
  const ShoppingCartIcon({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (contaxt, state) {
      int itemsNumber = state.cartState.data.fold<int>(0, (v, e) => v + e.qty);
      return InkWell(
          child: Badge(
            showBadge: itemsNumber > 0,
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeColor: Colors.blue,
            badgeContent: AutoSizeText(
              itemsNumber > 99 ? '+99' : itemsNumber.toString(),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart_outlined), onPressed: onPressed),
          ),
          onTap: onPressed);
    });
  }
}

class CustomCard extends StatelessWidget {
  final double width;
  final double height;
  final double eve;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsets margin;
  final Color color;
  final bool showShadow;

  const CustomCard(
      {Key key,
      this.width,
      this.height,
      this.child,
      this.borderRadius = const BorderRadius.all(Radius.circular(15)),
      this.margin = const EdgeInsets.all(8),
      this.color = Colors.white,
      this.eve = 3,
      this.showShadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, eve), // changes position of shadow
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: child,
        ));
  }
}

class ConnectionFailed extends StatelessWidget {
  const ConnectionFailed({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.width / 1.5,
          width: MediaQuery.of(context).size.width / 1.5,
          child: ClipRRect(
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width / 1.5)),
              child: Container(
                padding: EdgeInsets.all(24.0),
                color: Colors.grey[200],
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 64,
                      color: Colors.grey[600],
                    ),
                    Expanded(
                      child: AutoSizeText("${'connection_failed'.tr()}!",
                          maxLines: 1,
                          minFontSize: 10,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: AutoSizeText(
                          "${'check_connection_try_again'.tr()}.",
                          minFontSize: 8,
                          maxLines: 2),
                    ),
                    FlatButton(
                      onPressed: onPressed,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AutoSizeText(
                          "retry".tr(),
                          maxFontSize: 16,
                          minFontSize: 12,
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class ColorOption extends StatelessWidget {
  final Color color;
  final bool active;
  final bool enable;

  const ColorOption(this.color,
      {Key key, this.active = false, this.enable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: enable
              ? active
                  ? Border.all(color: Colors.blueAccent, width: 2)
                  : null
              : Border.all(color: Colors.red, width: 2),
          color: color,
        ),
        child: enable ? null : Icon(Icons.close, color: Colors.red),
      ),
    );
  }
}

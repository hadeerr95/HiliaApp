import 'package:app/app_properties.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/models/models.dart';
import 'package:app/screens/components/components.dart';
import 'package:app/services/service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddressForm extends StatefulWidget {
  final Widget title;
  final Function onConfirm;
  final Partner partner;

  const AddressForm({Key key, this.title, this.onConfirm, this.partner})
      : super(key: key);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Partner partner;
  String errorMsg;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    partner = Partner(
      id: partner?.id ?? widget.partner?.id,
      city: partner?.city ?? widget.partner?.city,
      country: partner?.country ?? widget.partner?.country,
      email: partner?.email ?? widget.partner?.email,
      phone: partner?.phone ?? widget.partner?.phone,
      name: partner?.name ?? widget.partner?.name,
      state: partner?.state ?? widget.partner?.state,
      street: partner?.street ?? widget.partner?.street,
      zip: partner?.zip ?? widget.partner?.zip,
      type: partner?.type ??
              widget.partner?.type ??
              widget.partner?.parent?.id != null
          ? 'delivery'
          : null,
      parent: partner?.parent ?? widget.partner?.parent,
    );
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (partner.country == null) {
        partner = partner.copyWith(Partner(
            country: state.user.setting.countries?.firstWhere(
                (e) => e.code.toLowerCase() == "om",
                orElse: () => null)));
      }
      Widget confirm = InkWell(
        onTap: () async {
          // if (_formKey.currentState.validate()) {
          try {
            errorMsg = null;
            showHiliaProgress(context);
            ApiService apiService = ApiService.instance;
            if (widget.partner?.id != null) {
              Partner p = await apiService.updatePartner(partner);
              context.bloc<AuthenticationBloc>().add(UpdatePartner(p));
            } else {
              Partner p = await apiService.createPartner(partner);
              context.bloc<AuthenticationBloc>().add(CreatePartner(p));
            }

            context.bloc<AuthenticationBloc>().add(AuthenticationReload());
            if (widget.onConfirm != null) widget.onConfirm();
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
          // }
        },
        child: Container(
          height: 60,
          width: width / 1.5,
          decoration: BoxDecoration(
              gradient: mainButton,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
          child: Center(
            child: AutoSizeText("confirm".tr(),
                style: const TextStyle(
                    color: const Color(0xfffefefe),
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0)),
          ),
        ),
      );
      return Form(
        // key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          widget.title,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  // controller: TextEditingController(),
                  decoration: InputDecoration(
                      // border: InputBorder.none,
                      // contentPadding: EdgeInsets.zero,
                      labelText: 'your_name'.tr()),
                  // style: TextStyle(fontSize: 12, color: Colors.grey[600]),

                  initialValue: partner.name,
                  onChanged: (value) {
                    partner = partner.copyWith(Partner(name: value));
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: "email".tr()),
                  keyboardType: TextInputType.emailAddress,
                  initialValue: partner.email,
                  onChanged: (value) {
                    partner = partner.copyWith(Partner(email: value));
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: "phone".tr()),
                  keyboardType: TextInputType.phone,
                  initialValue: partner.phone,
                  onChanged: (value) {
                    partner = partner.copyWith(Partner(phone: value));
                  },
                ),
                SizedBox(height: 16),
                // TextFormField(
                //   decoration: InputDecoration(hintText: "Company Name"),
                // ),
                TextFormField(
                  decoration: InputDecoration(labelText: "street".tr()),
                  initialValue: partner.street,
                  onChanged: (value) {
                    partner = partner.copyWith(Partner(street: value));
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: "city".tr()),
                  initialValue: partner.city,
                  onChanged: (value) {
                    partner = partner.copyWith(Partner(city: value));
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: "Zip / Postal Code"),
                  keyboardType: TextInputType.number,
                  initialValue: partner.zip,
                  onChanged: (value) {
                    partner = partner.copyWith(Partner(zip: value));
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  hint: AutoSizeText("country".tr()),
                  isExpanded: true,
                  value: partner.country?.id,
                  items: state.user.setting.countries
                      .map((e) => DropdownMenuItem<int>(
                            child: AutoSizeText(e.name),
                            value: e.id,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      partner = partner.copyWith(Partner(
                          country: state.user.setting.countries?.firstWhere(
                              (e) => e.id == value,
                              orElse: () => null),
                          state: CountryState()));
                    });
                  },
                  // decoration: InputDecoration(hintText: "Country"),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  hint: AutoSizeText("state".tr()),
                  isExpanded: true,
                  value: partner.state?.id,
                  items: partner.country != null
                      ? (state.user.setting.countries
                              .firstWhere((e) => e.id == partner?.country?.id))
                          .states
                          .map((e) => DropdownMenuItem<int>(
                                child: AutoSizeText(e.name),
                                value: e.id,
                              ))
                          .toList()
                      : null,
                  onChanged: (value) {
                    setState(() {
                      partner = partner.copyWith(Partner(
                          state: partner.country.states?.firstWhere(
                              (e) => e.id == value,
                              orElse: () => null)));
                    });
                  },
                  // decoration: InputDecoration(hintText: "Country"),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          confirm
        ]),
      );
    });
  }
}

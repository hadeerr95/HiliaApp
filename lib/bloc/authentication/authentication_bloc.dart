import 'dart:async';

import 'package:app/models/models.dart';
import 'package:app/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
    );
    // _orderStatusSubscription = _authenticationRepository.orderStatus().listen(
    //       (status) => add(OrderStatusChanged(status)),
    //     );
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<User> _userSubscription;
  StreamSubscription<Map> _orderStatusSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is OrderStatusChanged) {
      yield _mapOrderStatusChangedToState(event);
    } else if (event is Checkout) {
      yield _mapCheckoutToState(event);
    } else if (event is CreatePartner) {
      yield _mapCreatePartnerToState(event);
    } else if (event is UpdatePartner) {
      yield _mapUpdatePartnerToState(event);
    } else if (event is AuthenticationReload) {
      unawaited(_authenticationRepository.refreshUser());
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _orderStatusSubscription?.cancel();
    return super.close();
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) {
    if (event?.user?.id != null) {
      return AuthenticationState.authenticated(event.user);
    } else {
      if (event.user != null)
        return AuthenticationState.guest(event.user);
      else
        return const AuthenticationState.unauthenticated();
    }
  }

  AuthenticationState _mapOrderStatusChangedToState(
    OrderStatusChanged event,
  ) {
    print(event.order.orderStatus);
    // if (state.user != null &&
    //     event.status['state'] == 'done' &&
    //     state.user.saleOrder?.id != null) {
    if (event.order.orderStatus == OrderStatus.SalesOrder) {
      User user = User(saleOrder: SaleOrder(), orders: [
        ...state.user.orders..removeWhere((e) => e.id == event.order.id),
        event.order
      ]);

      add(AuthenticationReload());
      if (state.status == AuthenticationStatus.authenticated)
        return AuthenticationState.authenticated(state.user.copyWith((user)));
      else if (state.status == AuthenticationStatus.guest)
        return AuthenticationState.guest(state.user.copyWith(user));
    }
    return state;
  }

  AuthenticationState _mapCheckoutToState(
    Checkout event,
  ) {
    User user = User(saleOrder: event.order, orders: [
      ...state.user.orders..removeWhere((e) => e.id == event.order.id),
      event.order
    ]);

    if (state.status == AuthenticationStatus.authenticated)
      return AuthenticationState.authenticated(state.user.copyWith((user)));
    else if (state.status == AuthenticationStatus.guest)
      return AuthenticationState.guest(state.user.copyWith(user));
    else
      return state;
  }

  AuthenticationState _mapCreatePartnerToState(CreatePartner event) {
    User user;
    if (state.user?.partner != null) {
      List<Partner> contacts = <Partner>[
        event.partner,
        ...state.user.partner.contacts,
      ];
      user = User(
          partner: state.user.partner.copyWith(Partner(contacts: contacts)));
    } else
      user = User(partner: event.partner);

    if (state.status == AuthenticationStatus.authenticated)
      return AuthenticationState.authenticated(state.user.copyWith((user)));
    else if (state.status == AuthenticationStatus.guest)
      return AuthenticationState.guest(state.user.copyWith(user));
    else
      return state;
  }

  AuthenticationState _mapUpdatePartnerToState(UpdatePartner event) {
    User user;
    if (state.user.partner.id == event.partner.id) {
      user = User(partner: state.user.partner.copyWith(event.partner));
    } else {
      Partner p = state.user.partner.contacts
          .firstWhere((e) => e.id == event.partner.id, orElse: () => Partner());
      List<Partner> contacts = [
        p.copyWith(event.partner),
        ...state.user.partner.contacts
          ..removeWhere((e) => e.id == event.partner.id)
      ];
      user = User(
          partner: state.user.partner.copyWith(Partner(contacts: contacts)));
    }
    if (state.status == AuthenticationStatus.authenticated)
      return AuthenticationState.authenticated(state.user.copyWith(user));
    else if (state.status == AuthenticationStatus.guest)
      return AuthenticationState.guest(state.user.copyWith(user));
    else
      return state;
  }
}

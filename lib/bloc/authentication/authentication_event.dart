part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class OrderStatusChanged extends AuthenticationEvent {
  const OrderStatusChanged(this.order);

  final SaleOrder order;

  @override
  List<Object> get props => [order];
}

class Checkout extends AuthenticationEvent {
  const Checkout(this.order);

  final SaleOrder order;

  @override
  List<Object> get props => [order];
}

class CreatePartner extends AuthenticationEvent {
  const CreatePartner(this.partner);

  final Partner partner;

  @override
  List<Object> get props => [partner];
}

class UpdatePartner extends AuthenticationEvent {
  const UpdatePartner(this.partner);

  final Partner partner;

  @override
  List<Object> get props => [partner];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}

class AuthenticationReload extends AuthenticationEvent {}

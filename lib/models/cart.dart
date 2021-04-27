part of 'models.dart';

class CartItem extends Equatable {
  final int productId;
  final int variantId;
  final int qty;

  const CartItem({this.productId, this.variantId, this.qty});

  factory CartItem.fromJson(Map json) => CartItem(
        productId: json['product_id'],
        variantId: json['varinat_id'],
        qty: json['qty'],
      );

  Map get toJson => Map.from({
        'product_id': productId,
        'varinat_id': variantId,
        'qty': qty,
      });

  CartItem copyWith({int qty}) => CartItem(
        productId: this.productId,
        variantId: this.variantId,
        qty: qty ?? this.qty,
      );

  @override
  List<Object> get props => [productId, variantId, qty];
}

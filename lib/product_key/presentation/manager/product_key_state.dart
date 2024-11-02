part of 'product_key_cubit.dart';

@immutable
final class ProductKeyInitial extends ProductKeyState {}

abstract class ProductKeyState extends Equatable {
  const ProductKeyState();

  @override
  List<Object> get props => [];
}

class ProductKeyLoading extends ProductKeyState {}

class ProductKeyValid extends ProductKeyState {}

class ProductKeyInvalid extends ProductKeyState {}

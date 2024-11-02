import 'package:equatable/equatable.dart';

class ProductKey extends Equatable {
  final String key;
  final String? assignedTo;
  final String? phoneNumber;

  const ProductKey({
    required this.key,
    this.assignedTo,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [key, assignedTo, phoneNumber];
}

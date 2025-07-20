import 'package:json_annotation/json_annotation.dart';
import 'package:goodbuy/domain/entities/product.dart';

part 'product_dto.g.dart';

/// DTO representando um Produto a partir da API do FakeStore
@JsonSerializable()
class ProductDto {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  ProductDto({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}

extension ProductDtoX on ProductDto {
  Product toDomain() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
    );
  }
}

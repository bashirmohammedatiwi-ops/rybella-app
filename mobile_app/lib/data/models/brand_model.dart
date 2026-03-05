class BrandModel {
  final int id;
  final String nameAr;
  final String slug;
  final String? image;

  BrandModel({required this.id, required this.nameAr, required this.slug, this.image});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String?,
    );
  }
}

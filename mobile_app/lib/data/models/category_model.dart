class CategoryModel {
  final int id;
  final String nameAr;
  final String slug;
  final String? image;
  final String? icon;
  final int? parentId;
  final List<CategoryModel>? children;

  CategoryModel({
    required this.id,
    required this.nameAr,
    required this.slug,
    this.image,
    this.icon,
    this.parentId,
    this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      slug: json['slug'] as String,
      image: json['image'] as String?,
      icon: json['icon'] as String?,
      parentId: json['parent_id'] as int?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BannerModel {
  final int id;
  final String? titleAr;
  final String image;
  final String? link;

  BannerModel({
    required this.id,
    this.titleAr,
    required this.image,
    this.link,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int,
      titleAr: json['title_ar'] as String?,
      image: json['image'] as String,
      link: json['link'] as String?,
    );
  }
}

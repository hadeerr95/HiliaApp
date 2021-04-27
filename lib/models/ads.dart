part of 'models.dart';

class Ads extends Equatable {
  final int id;
  final String name;
  final ImageProvider imageProvider;
  final String url;

  const Ads({
    this.id,
    this.name,
    this.imageProvider,
    this.url,
  });

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      id: json["id"],
      name: json["name"],
      imageProvider: json[FieldImage] != null
          ? ImageBites.imageFromString(json[FieldImage])
          : null,
      url: json["url"],
    );
  }
  Ads copyWith(Ads item) => Ads(
        id: item.id ?? this.name,
        name: item.name ?? this.name,
        imageProvider: item.imageProvider ?? this.imageProvider,
        url: item.url ?? this.url,
      );

  Image imageWidget({BoxFit fit, double width, double height}) {
    try {
      return Image(
        image: imageProvider,
        fit: fit,
        width: width,
        height: height,
      );
    } catch (e) {
      return Image.asset('assets/icons/icon_hilia_3_1.png');
    }
  }

  @override
  List<Object> get props => [
        id,
        name,
        imageProvider,
        url,
      ];
}

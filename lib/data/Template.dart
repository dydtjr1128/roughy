class Template {
  String imagePath;
  bool isFavorite;

  Template({this.imagePath, this.isFavorite}) {
    this.isFavorite = false;
  }

  Template.fromJson(Map<String, dynamic> json)
      : imagePath = json['imagePath'],
        isFavorite = json['isFavorite'];

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'isFavorite': isFavorite,
      };
}

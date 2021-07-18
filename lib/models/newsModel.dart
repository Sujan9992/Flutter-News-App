class NewsModel {
  String title;
  String description;
  String publishedAt;
  String urlToImage;
  String author;
  bool fav;

  NewsModel({
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.urlToImage,
    required this.author,
    this.fav = true,
  });
}

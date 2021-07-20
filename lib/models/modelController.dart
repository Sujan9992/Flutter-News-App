import 'package:get/get.dart';
import 'package:rest_api/models/newsModel.dart';
import 'package:rest_api/services/api.dart';

class NewsController extends GetxController {
  var isLoading = true.obs;
  var newsList = <NewsModel>[].obs;
  int page = 1;
  // int get pageNo => page.value;

  @override
  void onInit() {
    super.onInit();
    fetchNews(page);
  }

  // pagePlus() {
  //   page++;
  //   print(page);
  // }

  void fetchNews(page) async {
    var items = await ApiFetch(page: page).getNews();
    try {
      isLoading(true);
      for (var item in items) {
        newsList.add(
          NewsModel(
            title: item['title'] ?? '',
            description: item['description'] ?? '',
            publishedAt: item['publishedAt'] ?? '',
            urlToImage: item['urlToImage'] ?? '',
            author: item['author'] ?? '',
          ),
        );
      }
    } finally {
      isLoading(false);
    }
  }
}

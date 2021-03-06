import 'dart:convert';
import 'package:http/http.dart';

class ApiFetch {
  int page;
  ApiFetch({required this.page});
  Future<List> getNews() async {
    final String url =
        'https://newsapi.org/v2/everything?apikey=apiKey&domains=wsj.com&pageSize=10&page=$page&language=en';
    var res = await get(
      Uri.parse(url),
    );
    if (res.statusCode == 200) {
      Map<String, dynamic> results = jsonDecode(res.body);
      List<dynamic> body = results['articles'];
      return body;
    } else {
      throw ('Unable to fetch data.');
    }
  }
}

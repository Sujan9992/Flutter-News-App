import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_api/database/databaseHelper.dart';
import 'package:rest_api/models/modelController.dart';

// ignore: must_be_immutable
class PageDetail extends StatelessWidget {
  final List<dynamic> detail;
  final int index;

  NewsController _control = Get.find<NewsController>();

  PageDetail(this.detail, this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          onPressed: () async {
            var stateChange = _control.newsList[index];
            stateChange.fav = !stateChange.fav;
            _control.newsList[index] = stateChange;
            await DatabaseHelper.instance.insert(
              {
                DatabaseHelper.title: detail[index].title,
                DatabaseHelper.description: detail[index].description,
                DatabaseHelper.urlToImage: detail[index].urlToImage,
                DatabaseHelper.author: detail[index].author,
                DatabaseHelper.publishedAt: detail[index].publishedAt,
              },
            );
            Get.snackbar(
              'News Added.',
              'This news has been succefully added to favorite page.',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          backgroundColor: Colors.grey[850],
          child: Icon(
            Icons.favorite,
            color: _control.newsList[index].fav ? Colors.white : Colors.red,
            size: 30.0,
          ),
        );
      }),
      appBar: AppBar(
        title: Text(
          detail[index].title,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.all(
            10.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    15.0,
                  ),
                  child: Image.network(
                    detail[index].urlToImage,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: Text(
                      detail[index].author ?? 'Unknown',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Text(
                      detail[index].publishedAt,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
              Container(
                child: Text(
                  detail[index].description,
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

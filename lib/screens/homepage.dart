import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_api/models/modelController.dart';
import 'package:rest_api/screens/detailsPage.dart';
import 'package:rest_api/screens/favoritePage.dart';
import 'package:rest_api/services/api.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ScrollController _scrollController = ScrollController();
  NewsController controller = Get.put(NewsController());

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels ==
  //         _scrollController.position.maxScrollExtent) {
  //       getMoreData();
  //     } else if (_scrollController.position.pixels ==
  //         _scrollController.position.minScrollExtent) {
  //       getPreviousData();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _scrollController.dispose();
  // }

  // void getMoreData() {
  //   page++;
  //   setState(() {});
  //   ApiFetch.getNews(page).then(
  //     (value) => _scrollController.jumpTo(0.1),
  //   );
  // }

  // void getPreviousData() {
  //   if (page >= 2) {
  //     page--;
  //     setState(() {});
  //     ApiFetch.getNews(page).then(
  //       (value) => _scrollController
  //           .jumpTo(_scrollController.position.maxScrollExtent - 0.1),
  //     );
  //   } else {
  //     page = 1;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData.dark(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'News',
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Latest News',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Favorite News',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              Container(
                child: Scrollbar(
                  interactive: true,
                  controller: _scrollController,
                  child: Obx(
                    () {
                      if (controller.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: controller.newsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 5.0, 10.0, 0),
                                child: Container(
                                  margin: EdgeInsets.all(10.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade600
                                            .withOpacity(0.5),
                                        blurRadius: 5,
                                        offset: Offset.fromDirection(0, 4),
                                        spreadRadius: 3.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        splashColor: Colors.red,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PageDetail(
                                                  controller.newsList, index),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Container(
                                                    height: 180.0,
                                                    width: double.infinity,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                              placeholder:
                                                                  'assets/1494.gif',
                                                              image: controller
                                                                  .newsList[
                                                                      index]
                                                                  .urlToImage),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        controller
                                                            .newsList[index]
                                                            .title,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[300],
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              controller.newsList[index].author,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
              ),
              LocalData(),
            ],
          ),
        ),
      ),
    );
  }
}

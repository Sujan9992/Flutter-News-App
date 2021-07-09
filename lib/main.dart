import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rest_api/databaseHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScrollController _scrollController = ScrollController();
  int page = 1;

  Future<List> getNews(page) async {
    final String url =
        'https://newsapi.org/v2/everything?apikey=fb1fe456b3af4227b24584a13b567a65&domains=wsj.com&pageSize=10&page=$page&language=en';
    Response res = await get(
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData();
      } else if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        getPreviousData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void getMoreData() {
    page++;
    setState(() {});
    getNews(page).then(
      (value) => _scrollController.jumpTo(0.1),
    );
  }

  void getPreviousData() {
    if (page >= 2) {
      page--;
      setState(() {});
      getNews(page).then(
        (value) => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent - 0.1),
      );
    } else {
      page = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                child: FutureBuilder(
                  future: getNews(page),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      List? body = snapshot.data;
                      return Scrollbar(
                        interactive: true,
                        controller: _scrollController,
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: body!.length,
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
                                              builder: (context) =>
                                                  PageDetail(body, index),
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
                                                              image: body[
                                                                      index][
                                                                  'urlToImage']),
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
                                                        body[index]['title'],
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              body[index]['author'] ?? 'Sujan',
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
                            }),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
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

class PageDetail extends StatefulWidget {
  final List<dynamic> detail;
  final int index;

  PageDetail(this.detail, this.index);

  @override
  _PageDetailState createState() => _PageDetailState();
}

class _PageDetailState extends State<PageDetail> {
  bool isPressed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigator.pop(context);
          if (widget.detail[widget.index]['_id'] == null) {
            await DatabaseHelper.instance.insert(
              {
                DatabaseHelper.title: widget.detail[widget.index]['title'],
                DatabaseHelper.description: widget.detail[widget.index]
                    ['description'],
                DatabaseHelper.urlToImage: widget.detail[widget.index]
                    ['urlToImage'],
                DatabaseHelper.author: widget.detail[widget.index]['author'],
                DatabaseHelper.publishedAt: widget.detail[widget.index]
                    ['publishedAt'],
              },
            );
          }
          setState(() {
            isPressed = !isPressed;
          });
        },
        backgroundColor: Colors.grey[850],
        child: Icon(
          Icons.favorite,
          color: isPressed ? Colors.white : Colors.red,
          size: 30.0,
        ),
      ),
      appBar: AppBar(
        title: Text(
          widget.detail[widget.index]['title'],
        ),
      ),
      body: SafeArea(
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
                    widget.detail[widget.index]['urlToImage'],
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
                      widget.detail[widget.index]['author'] ?? 'Sujan',
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
                      widget.detail[widget.index]['publishedAt'],
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
                  widget.detail[widget.index]['description'],
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

class LocalData extends StatefulWidget {
  const LocalData({Key? key}) : super(key: key);

  @override
  _LocalDataState createState() => _LocalDataState();
}

class _LocalDataState extends State<LocalData> {
  Future<List> getLocalData() async {
    List<Map<String, dynamic>> query = await DatabaseHelper.instance.queryAll();
    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getLocalData(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            List? body = snapshot.data;
            return ListView.builder(
              itemCount: body!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onLongPress: () async {
                    await DatabaseHelper.instance.delete(body[index]['_id']);
                    HapticFeedback.heavyImpact();
                    Fluttertoast.showToast(
                      msg: 'News deleted.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey[600],
                      textColor: Colors.grey[300],
                      fontSize: 15.0,
                    );
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset.fromDirection(0, 4),
                          spreadRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                            child: Image.network(
                              body[index]['urlToImage'],
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
                                body[index]['author'],
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
                                body[index]['publishedAt'],
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
                            body[index]['description'],
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

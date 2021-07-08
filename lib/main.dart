import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rest_api/databaseHelper.dart';

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
    print('Generating more data.');
    print(page);
    page++;
    setState(() {});
  }

  void getPreviousData() {
    print('Get Previous data.');
    print(page);
    if (page >= 2) {
      page--;
      setState(() {});
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
                      return ListView.builder(
                          controller: _scrollController,
                          itemCount: body!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
                              child: Container(
                                margin: EdgeInsets.all(10.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.grey.shade600.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: Offset.fromDirection(0, 4),
                                      spreadRadius: 3.0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(20.0),
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
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 180.0,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    //let's add the height

                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            body[index]
                                                                ['urlToImage']),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      12.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    body[index]['title'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  body[index]['description'],
                                                  style: TextStyle(
                                                    color: Colors.grey[350],
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            child: Icon(
                                              Icons.share,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.white,
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
                DatabaseHelper.content: widget.detail[widget.index]['content'],
                DatabaseHelper.urlToImage: widget.detail[widget.index]
                    ['urlToImage'],
                DatabaseHelper.author: widget.detail[widget.index]['author'],
                DatabaseHelper.publishedAt: widget.detail[widget.index]
                    ['publishedAt'],
              },
            );
          }
          // await DatabaseHelper.instance.delete(10);
          // List<Map<String, dynamic>> query =

          //     await DatabaseHelper.instance.queryAll();
          // print(i);
          // print(query);
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
                      widget.detail[widget.index]['author'],
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
                  widget.detail[widget.index]['content'],
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
                    print('Long Press');
                    await DatabaseHelper.instance.delete(body[index]['_id']);
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
                            body[index]['content'],
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

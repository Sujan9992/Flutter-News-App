import 'package:flutter/material.dart';
import 'package:rest_api/database/databaseHelper.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

import 'package:flutter/material.dart';
import 'package:rest_api/database/databaseHelper.dart';

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
                      widget.detail[widget.index]['author'] ?? 'Unknown',
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

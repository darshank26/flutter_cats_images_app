import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Random Cats',
      home: MyHomePage(title: 'Flutter Random Cats'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _url = "https://api.thecatapi.com/v1/images/search/";
  StreamController _streamController;
  Stream _stream;
  Response response;

  getCatImages() async {
    _streamController.add("waiting");
    response = await get(_url);
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    getCatImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return getCatImages();
          },
          child: Center(
            child: StreamBuilder(
              stream: _stream,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.data == "waiting") {
                  return Center(child: Text("Waiting of the image....."));
                }
                return Center(
                  child: ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int i) {
                        return Center(
                          child: ListBody(
                            children: [
                              Center(
                                child: Card(
                                    elevation: 8.0,
                                    child: Center(
                                        child: Image.network(
                                            snapshot.data[i]['url']))),
                              )
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ));
  }
}

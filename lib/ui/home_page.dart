import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset;

  Future<Map> _getGif() async {
    http.Response response;

    if (_search == null)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=iu66qr3hw0XJUKk6JNBHIXmfoYMQqC8G&limit=20&rating=G");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=iu66qr3hw0XJUKk6JNBHIXmfoYMQqC8G&q=$_search&limit=20&offset=$_offset&rating=G&lang=en");

    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGif().then((ret) {
      print(ret);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                  labelText: "Pesquise seu gif aqui",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

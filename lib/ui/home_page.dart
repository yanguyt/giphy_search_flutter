import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giphy_app/ui/gifPage.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGif() async {
    http.Response response;

    if (_search == null || _search.isEmpty)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=iu66qr3hw0XJUKk6JNBHIXmfoYMQqC8G&limit=20&rating=G");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=iu66qr3hw0XJUKk6JNBHIXmfoYMQqC8G&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");

    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGif().then((ret) {});
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
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
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
          Expanded(
            child: FutureBuilder(
              future: _getGif(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGrid(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getGifQuantity(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGrid(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]
                    ["fixed_height"]["url"]);
              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["data"][index])));
              },
              child: FadeInImage.memoryNetwork(
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                placeholder: kTransparentImage,
                height: 300,
                fit: BoxFit.cover,
              ));
        } else {
          return Container(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _offset = 1;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 70,
                    color: Colors.white,
                  ),
                  Text("Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 20))
                ],
              ),
            ),
          );
        }
      },
      itemCount: _getGifQuantity(snapshot.data["data"]),
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
    );
  }
}

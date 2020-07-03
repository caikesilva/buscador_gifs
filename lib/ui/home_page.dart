import 'dart:convert';

import 'package:buscador_de_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controllerInput = TextEditingController();
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    Response response;
    if (_search == null || _search.isEmpty) {
      response = await get(
          "https://api.giphy.com/v1/gifs/trending?api_key=PJbzLQLOXAYaStlhjMWLZBOjfobvd4NK&limit=20&rating=G");
    } else {
      response = await get(
          "https://api.giphy.com/v1/gifs/search?api_key=PJbzLQLOXAYaStlhjMWLZBOjfobvd4NK&q=$_search&limit=19&offset=$_offset&rating=G&lang=pt");
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network(
            "https://pmcvariety.files.wordpress.com/2016/10/giphy-logo-e1477932075273.png?w=867", height: 90,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controllerInput,
                    decoration: InputDecoration(
                      labelText: "Pesquise Aqui",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    
                    textAlign: TextAlign.center,
                    onSubmitted: (text) {
                      setState(() {
                        _search = text;
                      });
                    },
                  ),
                  Padding(padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(5)),
                        RaisedButton(
                          color: Colors.deepPurple,
                          onPressed: (){},
                            child: Text("Filtros", style: TextStyle(fontSize: 18.0, color: Colors.white, backgroundColor: Colors.deepPurple),
                          ),
                        ),
                      ],
                    ) 
                  ), 
                ],
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: _getGifs(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Container(
                            width: 80.0,
                            height: 80.0,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Container();
                          } else {
                            return _createGifTable(context, snapshot);
                          }
                      }
                    }))
          ],
        ));
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(15.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 15.0, mainAxisSpacing: 15.0),
        itemCount: _getCount(snapshot.data['data']),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data['data'].length)
            return GestureDetector(
              child: Stack(
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  FadeInImage.memoryNetwork( 
                    fadeInCurve: Curves.bounceIn,
                    placeholder: kTransparentImage,
                    image: snapshot.data['data'][index]['images']['fixed_height']['url'],
                    height: 300.0,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GifPage(snapshot.data['data'][index]))
                );
              },
              onLongPress: (){
                Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    Text(
                      "Carregar Mais...",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
        });
  }
}

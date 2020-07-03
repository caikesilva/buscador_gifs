import 'package:buscador_de_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:buscador_de_gifs/ui/home_page.dart';

String UrlMelhores = "https://api.giphy.com/v1/gifs/trending?api_key=PJbzLQLOXAYaStlhjMWLZBOjfobvd4NK&limit=20&rating=G";
String UrlPesquisa = "https://api.giphy.com/v1/gifs/search?api_key=PJbzLQLOXAYaStlhjMWLZBOjfobvd4NK&q=&limit=25&offset=25&rating=G&lang=pt";

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      
    )
  );
}


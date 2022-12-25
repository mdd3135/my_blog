import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_blog/values.dart';
import 'package:http/http.dart' as http;

import 'homePage.dart';

main() async {
  await http.get(Uri.parse("${Values.serverUrl}/visit_query?artical=total")).then(((response) {
    var visitResponse = utf8.decode(response.bodyBytes);
    Map<String, dynamic> visitMap = jsonDecode(visitResponse);
    Values.visit = visitMap["count"];
  }));
  await http.get(Uri.parse("${Values.serverUrl}/type_query")).then((response) {
    var typeResponse = utf8.decode(response.bodyBytes);
    Map<String, dynamic> typeMap = jsonDecode(typeResponse);
    List<dynamic> content = typeMap["content"];
    for (int i = 0; i < content.length; i++) {
      Map<String, dynamic> tmp = content[i];
      Values.articalType.add({"type_id": tmp["type_id"], "type": tmp["type"], "count": 0});
    }
  });
  await http.get(Uri.parse("${Values.serverUrl}/artical_query")).then((articalResponse) {
    var articalResonse = utf8.decode(articalResponse.bodyBytes);
    Map<String, dynamic> articalMap = jsonDecode(articalResonse);
    List<dynamic> content = articalMap["content"];
    for (int i = 0; i < content.length; i++) {
      Map<String, dynamic> tmp = content[i];
      Values.articalItem.add({
        "title": tmp["title"],
        "subtitle": tmp["discription"],
        "create_time": tmp["create_time"],
        "picture": tmp["picture"],
        "content_md": tmp["content_md"],
        "type_id": tmp["type_id"]
      });
      for (int i = 0; i < Values.articalType.length; i++) {
        Map<String, dynamic> typeMap = Values.articalType[i];
        if (typeMap["type_id"].toString() == tmp["type_id"].toString()) {
          Values.articalType[i]["count"]++;
          break;
        }
      }
    }
    for (int i = 0; i < content.length; i++) {
      Map<String, dynamic> tmp = content[i];
      Values.allArtical.add({
        "title": tmp["title"],
        "subtitle": tmp["discription"],
        "create_time": tmp["create_time"],
        "picture": tmp["picture"],
        "content_md": tmp["content_md"],
        "type_id": tmp["type_id"]
      });
    }
  });
  Values.articalType.add({"type_id": 0, "type": "全部", "count": Values.articalItem.length});
  Values.articalType = Values.articalType.reversed.toList();
  Values.articalItem = Values.articalItem.reversed.toList();

  for (int i = 0; i < Values.allArtical.length; i++) {
    Values.goRouteList.add(GoRoute(
      path: Values.allArtical[i]["create_time"],
      pageBuilder: (context, state) => NoTransitionPage(
          child: HomePage(
        initIndex: 4,
        createTime: Values.allArtical[i]["create_time"],
      )),
    ));
  }
  Values.initRouter(Values.goRouteList);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Values.router,
    );
  }
}

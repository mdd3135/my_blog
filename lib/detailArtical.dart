import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:my_blog/values.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailArtical extends StatefulWidget {
  const DetailArtical({
    super.key,
    required this.detail,
  });

  final String detail;

  @override
  State<DetailArtical> createState() => _DetailArticalState();
}

class _DetailArticalState extends State<DetailArtical> {
  @override
  Widget build(BuildContext context) {
    if (widget.detail.isEmpty) {
      return Container();
    }
    return SingleChildScrollView(
        child: Center(
            child: Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              color: Colors.black,
              child: Opacity(
                opacity: 0.5,
                child: Image.network(
                  "${Values.serverUrl}/file/${getPicture()}",
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                        style:
                            const TextStyle(color: Colors.white, fontSize: 36),
                        getTitle()),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const WidgetSpan(
                              child: Icon(
                            color: Colors.white,
                            Icons.access_time,
                          )),
                          TextSpan(
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                              text: getDateTime()),
                        ],
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const WidgetSpan(
                            child: Icon(
                          color: Colors.white,
                          Icons.class_outlined,
                        )),
                        TextSpan(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            text: getType()),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(16, 33, 149, 243),
          ),
          margin: const EdgeInsets.all(20),
          width: 800,
          child: FutureBuilder(
              future: getTextData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                      styleSheet: Values.markdownStyleSheet,
                      shrinkWrap: true,
                      onTapLink: (text, url, title) {
                        launchUrl(Uri.parse(url!));
                      },
                      selectable: true,
                      data: snapshot.data.toString());
                }
                return Container();
              }),
        ),
      ],
    )));
  }

  Future<String> getTextData() async {
    String md = "";
    for (int i = 0; i < Values.articalItem.length; i++) {
      if (Values.articalItem[i]["create_time"] == widget.detail) {
        md = Values.articalItem[i]["content_md"];
        break;
      }
    }
    var response = await http.get(Uri.parse("${Values.serverUrl}/file/$md"));
    return utf8.decode(response.bodyBytes);
  }

  String getTitle() {
    try {
      String title = "";
      for (int i = 0; i < Values.articalItem.length; i++) {
        if (Values.articalItem[i]["create_time"] == widget.detail) {
          title = Values.articalItem[i]["title"];
          return title;
        }
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  String getPicture() {
    try {
      String picture = "";
      for (int i = 0; i < Values.articalItem.length; i++) {
        if (Values.articalItem[i]["create_time"] == widget.detail) {
          picture = Values.articalItem[i]["picture"];
          return picture;
        }
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  String getDateTime() {
    try {
      var dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(widget.detail));
      String month = dateTime.month < 10
          ? "0${dateTime.month}"
          : dateTime.month.toString();
      String day =
          dateTime.day < 10 ? "0${dateTime.day}" : dateTime.day.toString();
      String hour =
          dateTime.hour < 10 ? "0${dateTime.hour}" : dateTime.hour.toString();
      String second = dateTime.second < 10
          ? "0${dateTime.second}"
          : dateTime.second.toString();
      String res = "${dateTime.year}年$month月$day日 $hour:$second";
      return res;
    } catch (e) {
      return "";
    }
  }

  String getType() {
    try {
      String type_id = "";
      for (int i = 0; i < Values.articalItem.length; i++) {
        if (Values.articalItem[i]["create_time"] == widget.detail) {
          type_id = Values.articalItem[i]["type_id"];
          break;
        }
      }
      for (int i = 0; i < Values.articalType.length; i++) {
        if (Values.articalType[i]["type_id"].toString() == type_id) {
          return Values.articalType[i]["type"];
        }
      }
      return "";
    } catch (e) {
      return "";
    }
  }
}

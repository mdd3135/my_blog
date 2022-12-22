import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_blog/values.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                  "${Values.serverUrl}/file/about.jpg",
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                        style: TextStyle(color: Colors.white, fontSize: 36),
                        "关于作者"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                              child: Icon(
                            color: Colors.white,
                            Icons.access_time,
                          )),
                          TextSpan(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              text: "2022年12月20日 16:06"),
                        ],
                      ),
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
          height: height,
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
    String md = "about.md";
    var response = await http.get(Uri.parse("${Values.serverUrl}/file/$md"));
    return utf8.decode(response.bodyBytes);
  }
}

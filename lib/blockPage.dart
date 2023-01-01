import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_blog/values.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BlockPage extends StatefulWidget {
  const BlockPage({super.key});

  @override
  State<BlockPage> createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
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
                  "${Values.serverUrl}/file/block.png",
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              child: const Text(
                style: TextStyle(color: Colors.white, fontSize: 36),
                "恭喜你发现隐藏的新大陆",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(16, 33, 149, 243),
          ),
          margin: const EdgeInsets.all(20),
          width: 800,
          height: height,
          child: FutureBuilder(
              future: getTextData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                      physics: const NeverScrollableScrollPhysics(),
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
    String md = "block.md";
    var response = await http.get(Uri.parse("${Values.serverUrl}/file/$md"));
    return utf8.decode(response.bodyBytes);
  }
}

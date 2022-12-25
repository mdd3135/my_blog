import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_blog/messageWidget.dart';
import 'package:http/http.dart' as http;
import 'package:my_blog/values.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, String>> messageItem = [];

  @override
  void initState() {
    getItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.topCenter,
      child: SingleChildScrollView(
        child: Container(
          alignment: AlignmentDirectional.topCenter,
          width: 800,
          margin: const EdgeInsets.all(20),
          child: MessageWidget(messageItem: messageItem, artical: "total"),
        ),
      ),
    );
  }

  void getItem() async {
    await http.get(Uri.parse("${Values.serverUrl}/message_query")).then((response) {
      var response2 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> responseMap = jsonDecode(response2);
      List<dynamic> content = responseMap["content"];
      for (int i = 0; i < content.length; i++) {
        Map<String, dynamic> tmp = content[i];
        messageItem.add({
          "artical": tmp["artical"],
          "create_time": tmp["create_time"],
          "name": tmp["name"],
          "content": tmp["content"]
        });
      }
      messageItem = messageItem.reversed.toList();
    });
    setState(() {});
  }
}

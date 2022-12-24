import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_blog/values.dart';
import 'package:http/http.dart' as http;

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    super.key,
    required this.messageItem,
    required this.artical,
  });
  final List<Map<String, String>> messageItem;
  final String artical;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  String name = "";
  String content = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(16, 33, 149, 243),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: TextFormField(
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("昵称"),
                  ),
                  onChanged: ((value) {
                    name = value;
                  }),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 20, right: 20),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("在此留下你的足迹吧～"),
                  ),
                  onChanged: ((value) {
                    content = value;
                  }),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: _onPressed,
                    child: const Text("发送", style: TextStyle(fontSize: 20)),
                  ))
            ],
          ),
        ),
        Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(16, 33, 149, 243),
              borderRadius: BorderRadius.circular(10),
            ),
            child: widget.messageItem.isEmpty
                ? Container(
                    width: 800,
                    margin: const EdgeInsets.all(20),
                    child: const Text(
                      "暂无留言，快来留下你的足迹吧～",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.messageItem.length * 2,
                    itemBuilder: (context, index) {
                      int realIndex = index ~/ 2;
                      if (index % 2 == 1) {
                        return index == widget.messageItem.length * 2 - 1
                            ? Container()
                            : const Divider();
                      } else {
                        return ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "用户: ${widget.messageItem[realIndex]["name"]}    时间: ${getTime(widget.messageItem[realIndex]["create_time"])}",
                                style: const TextStyle(
                                    fontFamily: "SourceHanSansCN",
                                    fontSize: 16,
                                    color: Colors.green),
                              ),
                              Text(
                                "留言: ${widget.messageItem[realIndex]["content"]}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              widget.messageItem[realIndex]["artical"] ==
                                      "total"
                                  ? const Text("")
                                  : Container(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: TextButton(
                                          onPressed: () {
                                            Values.router.go(
                                                "/detail/${widget.messageItem[realIndex]["artical"]}");
                                          },
                                          child: Text(
                                            "链接: ${getTitle(widget.messageItem[realIndex]["artical"])}",
                                            style:
                                                const TextStyle(fontSize: 16),
                                          )),
                                    )
                            ],
                          ),
                        );
                      }
                    },
                  ))
      ],
    );
  }

  String getTitle(String? articalId) {
    for (int i = 0; i < Values.allArtical.length; i++) {
      if (articalId == Values.allArtical[i]['create_time']) {
        return Values.allArtical[i]["title"];
      }
    }
    return "";
  }

  String getTime(String? timeStamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.toString()));
    String year = dateTime.year.toString();
    String month =
        dateTime.month < 10 ? "0${dateTime.month}" : dateTime.month.toString();
    String day =
        dateTime.day < 10 ? "0${dateTime.day}" : dateTime.day.toString();
    String hour =
        dateTime.hour < 10 ? "0${dateTime.hour}" : dateTime.hour.toString();
    String minute = dateTime.minute < 10
        ? "0${dateTime.minute}"
        : dateTime.minute.toString();
    return "$year年$month月$day日 $hour:$minute";
  }

  void _onPressed() {
    if (name == "") {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text("提示"),
                content: const Text(
                  "请输入昵称噢～",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("确定", style: TextStyle(fontSize: 16)),
                  )
                ],
              )));
    } else if (content == "") {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text("提示"),
                content: const Text(
                  "请输入留言内容噢～",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("确定", style: TextStyle(fontSize: 16)),
                  )
                ],
              )));
    } else {
      Map<String, String> mp = {
        "name": name,
        "artical": widget.artical,
        "content": content
      };
      http
          .post(Uri.parse("${Values.serverUrl}/message_add"), body: mp)
          .then((value) {
        var response = utf8.decode(value.bodyBytes);
        Map<String, dynamic> responseMap = jsonDecode(response);
        String create_time = responseMap["create_time"];
        mp.addAll({"create_time": create_time});
        widget.messageItem.insert(0, mp);
        setState(() {});
        showDialog(
            context: context,
            builder: ((context) => AlertDialog(
                  title: const Text("提示"),
                  content: const Text(
                    "发送成功，感谢您的留言～",
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("确定", style: TextStyle(fontSize: 16)),
                    )
                  ],
                )));
      });
    }
  }
}

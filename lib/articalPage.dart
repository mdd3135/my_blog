import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_blog/values.dart';

class ArticalPage extends StatefulWidget {
  const ArticalPage({super.key});

  @override
  State<ArticalPage> createState() => _ArticalPageState();
}

class _ArticalPageState extends State<ArticalPage> {
  // late Timer _timer;
  String searchText = '';

  @override
  void initState() {
    for (int i = 0; i < Values.articalItem.length; i++) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1340),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          width >= 900
              ? ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 250,
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, left: 20),
                          child: TextFormField(
                              decoration: InputDecoration(
                                  suffix: IconButton(
                                    onPressed: () {
                                      _onSearchPressed(searchText);
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                  border: const UnderlineInputBorder(),
                                  hintText: "在此搜索")),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const Text(
                            "文章分类",
                            style: TextStyle(fontSize: 20),
                          )),
                      Flexible(
                          child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 20, left: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(16, 33, 149, 243),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: Values.articalType.length * 2,
                                itemBuilder: (context, index) {
                                  int realIndex = index ~/ 2;
                                  if (index % 2 == 1) {
                                    return index ==
                                            Values.articalType.length * 2 - 1
                                        ? const Text("")
                                        : const Divider();
                                  } else {
                                    return ListTile(
                                      onTap: () {
                                        _onTypeTap(Values.articalType[realIndex]
                                                ["type_id"]
                                            .toString());
                                      },
                                      title: Text(Values.articalType[realIndex]
                                          ["type"]),
                                      trailing: Text(Values
                                          .articalType[realIndex]["count"]
                                          .toString()),
                                    );
                                  }
                                },
                              ))),
                    ],
                  ),
                )
              : const Text(""),
          Flexible(
            child: Container(
                margin: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(16, 33, 149, 243),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: Values.articalItem.length * 2,
                  itemBuilder: (context, index) {
                    int realIndex = index ~/ 2;
                    if (index % 2 == 1) {
                      return index == Values.articalItem.length * 2 - 1
                          ? const Text("")
                          : const Divider();
                    } else {
                      return ListTile(
                        onTap: () {
                          _onArticalPressed(
                              Values.articalItem[realIndex]["create_time"]);
                        },
                        leading: Image(
                            image: NetworkImage(
                                "${Values.serverUrl}/file/${Values.articalItem[realIndex]["picture"]}")),
                        title: Text(Values.articalItem[realIndex]["title"]),
                        subtitle: Text(
                          Values.articalItem[realIndex]["subtitle"],
                          maxLines: 5,
                        ),
                        trailing: Text(
                            "${getDateTime(Values.articalItem[realIndex]["create_time"])}\n${getType(Values.articalItem[realIndex]["create_time"])}"),
                      );
                    }
                  },
                )),
          ),
          width >= 1200
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const Text(
                            "随机文章",
                            style: TextStyle(fontSize: 20),
                          )),
                      Flexible(
                          child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 20, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(32, 33, 149, 243),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: Values.randomArtical.length * 2,
                                itemBuilder: (context, index) {
                                  int realIndex = index ~/ 2;
                                  if (index % 2 == 1) {
                                    return index ==
                                            Values.randomArtical.length * 2 - 1
                                        ? const Text("")
                                        : const Divider();
                                  } else {
                                    return ListTile(
                                      title: Text(Values
                                          .randomArtical[realIndex]["title"]),
                                      trailing: const Icon(Icons.abc),
                                    );
                                  }
                                },
                              )))
                    ],
                  ),
                )
              : const Text(""),
        ]),
      ),
    );
  }

  void _onArticalPressed(String subpath) {
    Values.router.go("/detail/$subpath");
  }

  String getDateTime(String createTime) {
    try {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(createTime));
      String res = "${dateTime.year}年${dateTime.month}月${dateTime.day}日";
      return res;
    } catch (e) {
      return "";
    }
  }

  String getType(String create_time) {
    try {
      String type_id = "";
      for (int i = 0; i < Values.articalItem.length; i++) {
        if (Values.articalItem[i]["create_time"] == create_time) {
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

  void _onSearchPressed(String test) {}

  void _onTypeTap(String type_id) {
    Values.articalItem = [];
    for (int i = 0; i < Values.allArtical.length; i++) {
      if (Values.allArtical[i]["type_id"] == type_id) {
        Values.articalItem.add(Values.allArtical[i]);
      } else if (type_id == "0") {
        Values.articalItem.add(Values.allArtical[i]);
      }
    }
    Values.articalItem = Values.articalItem.reversed.toList();
    setState(() {});
  }
}

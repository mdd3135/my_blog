import 'package:flutter/material.dart';
import 'package:my_blog/detailArtical.dart';
import 'package:my_blog/values.dart';

import 'aboutPage.dart';
import 'articalPage.dart';
import 'messagePage.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    required this.initIndex,
    this.createTime = "",
  });
  int initIndex;
  String createTime;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget body;
  late Widget title;

  @override
  void initState() {
    if (widget.initIndex == 0) {
      Values.router.go("/artical");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (widget.initIndex == 0) {
      body = const ArticalPage();
      title = InkWell(
        onTap: () {
          setState(() {
            Values.articalItem = Values.allArtical.reversed.toList();
          });
          Values.router.go("/artical");
        },
        child: const Text("旦旦的个人博客——文章"),
      );
    } else if (widget.initIndex == 1) {
      body = const AboutPage();
      title = InkWell(
        onTap: () {
          setState(() {
            Values.articalItem = Values.allArtical.reversed.toList();
          });
          Values.router.go("/artical");
        },
        child: const Text("旦旦的个人博客——关于"),
      );
    } else if (widget.initIndex == 2) {
      body = const MessagePage();
      title = InkWell(
        onTap: () {
          setState(() {
            Values.articalItem = Values.allArtical.reversed.toList();
          });
          Values.router.go("/artical");
        },
        child: const Text("旦旦的个人博客——留言板"),
      );
    } else if (widget.initIndex == 4) {
      body = DetailArtical(
        detail: widget.createTime,
      );
      title = InkWell(
          onTap: () {
            setState(() {
              Values.articalItem = Values.allArtical.reversed.toList();
            });
            Values.router.go("/artical");
          },
          child: const Text("旦旦的个人博客——详情"));
    }

    return MaterialApp(
      theme: ThemeData(fontFamily: "SourceHanSansCN"),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: title,
          actions: width > 600
              ? <Widget>[
                  IconButton(
                      tooltip: "文章",
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      onPressed: () {
                        Values.router.go("/artical");
                      },
                      icon: Icon(widget.initIndex == 0
                          ? Icons.library_books
                          : Icons.library_books_outlined)),
                  IconButton(
                      tooltip: "关于",
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      onPressed: () {
                        Values.router.go("/about");
                      },
                      icon: Icon(widget.initIndex == 1
                          ? Icons.contact_support
                          : Icons.contact_support_outlined)),
                  IconButton(
                      tooltip: "留言板",
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      onPressed: () {
                        Values.router.go("/message");
                      },
                      icon: Icon(widget.initIndex == 2
                          ? Icons.message
                          : Icons.message_outlined)),
                ]
              : null,
        ),
        drawer: width > 600
            ? null
            : Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(color: Colors.blue),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "导航",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          const Expanded(child: Text("")),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "本站已运行${DateTime.now().difference(Values.dateTime).inDays}天",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Text(
                            "访问次数: ${Values.visit}",
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(widget.initIndex == 0
                          ? Icons.library_books
                          : Icons.library_books_outlined),
                      title: const Text("文章"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Values.router.go("/artical");
                      },
                    ),
                    ListTile(
                      leading: Icon(widget.initIndex == 1
                          ? Icons.contact_support
                          : Icons.contact_support_outlined),
                      title: const Text("关于"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Values.router.go("/about");
                      },
                    ),
                    ListTile(
                      leading: Icon(widget.initIndex == 2
                          ? Icons.message
                          : Icons.message_outlined),
                      title: const Text("留言板"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Values.router.go("/message");
                      },
                    ),
                  ],
                ),
              ),
        body: body,
      ),
    );
  }
}

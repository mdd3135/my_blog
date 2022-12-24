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
  Widget build(BuildContext context) {
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
      theme: ThemeData(
          fontFamily: "SourceHanSansCN"),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: title,
          actions: [
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
          ],
        ),
        body: body,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import 'homePage.dart';

class Values {
  static List<Map<String, dynamic>> allArtical = [];
  static List<Map<String, dynamic>> articalItem = [];
  static List<Map<String, dynamic>> articalType = [];
  static List<Map<String, dynamic>> randomArtical = [];
  static String fontUrl = "https://gitee.com/mao-dan-dan/blog/raw/master/SourceHanSansCN-Regular.otf";
  static String randomImgUrl = "https://source.unsplash.com/random/1920x1080/?animation";
  static String serverUrl = "https://mdd-e.vip.cpolar.top";
  static String detail = "";
  static int visit = 0;
  static DateTime dateTime = DateTime.parse("2022-12-14");
  static List<GoRoute> goRouteList = <GoRoute>[];
  static MarkdownStyleSheet markdownStyleSheet = MarkdownStyleSheet.fromTheme(ThemeData(
      fontFamily: "SourceHanSansCN",
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 20),
        headlineSmall: TextStyle(fontSize: 28),
        titleLarge: TextStyle(fontSize: 26),
        titleMedium: TextStyle(fontSize: 24),
        bodyLarge: TextStyle(fontSize: 22),
      )));

  static late GoRouter router;

  static void initRouter(List<RouteBase> routeList) {
    router = GoRouter(routes: <RouteBase>[
      GoRoute(
          path: "/",
          pageBuilder: (context, state) => NoTransitionPage(
                  child: HomePage(
                initIndex: 0,
              )),
          routes: <RouteBase>[
            GoRoute(
              path: "artical",
              pageBuilder: (context, state) => NoTransitionPage(
                  child: HomePage(
                initIndex: 0,
              )),
            ),
            GoRoute(
              path: "about",
              pageBuilder: (context, state) => NoTransitionPage(
                  child: HomePage(
                initIndex: 1,
              )),
            ),
            GoRoute(
              path: "message",
              pageBuilder: (context, state) => NoTransitionPage(
                  child: HomePage(
                initIndex: 2,
              )),
            ),
            GoRoute(
              path: "my",
              pageBuilder: (context, state) => NoTransitionPage(
                  child: HomePage(
                initIndex: 3,
              )),
            ),
            GoRoute(
                path: "detail",
                pageBuilder: (context, state) => NoTransitionPage(
                        child: HomePage(
                      initIndex: 4,
                    )),
                routes: routeList),
          ]),
    ]);
  }
}

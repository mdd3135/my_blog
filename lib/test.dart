import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_blog/values.dart';

void main() async {
  await http.get(Uri.parse("${Values.serverUrl}/file/2.md")).then((response) {
    String responseBody = utf8.decode(response.bodyBytes);
    print(responseBody);
  });
}

import 'package:http/http.dart';
import 'dart:convert';

import '../constants.dart';

Future<List> getBrandSuggestions(String pattern) async {
  try {
    String route = 'api/brand/search/$pattern';
    final response = await get(Uri.http(Backend.direction, route),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body;
    } else {
      return [];
    }
  } catch (e) {
    return [e.toString()];
  }
}

Future<String> createBrand(String name) async {
  try {
    String route = 'api/brand/';
    final response = await post(Uri.http(Backend.direction, route),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{"name": name}));
    if (response.statusCode == 200) {
      return 'Brand created successfully';
    } else if (response.statusCode == 400) {
      return 'Brand already exist';
    } else {
      return 'Error creating brand';
    }
  } catch (e) {
    return e.toString();
  }
}
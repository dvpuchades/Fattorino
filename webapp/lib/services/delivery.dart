import 'dart:convert';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:webapp/models/delivery.dart';
import 'package:webapp/models/user.dart';

import '../constants.dart';

Future<String> createDelivery(
    String address,
    String city,
    String postcode,
    String phone,
    String customer,
    double amount,
    String restaurantId,
    LatLng? coordinates) async {
  try {
    String route = 'api/delivery';
    double? latitude = coordinates?.latitude;
    double? longitude = coordinates?.longitude;
    final response = await post(Uri.http(Backend.direction, route),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': User.getInstance().token
        },
        body: jsonEncode(<String, dynamic>{
          "address": address,
          "city": city,
          "postcode": postcode,
          "amount": amount,
          "customer": customer,
          "phone": phone,
          "restaurant": restaurantId,
          "longitude": longitude,
          "latitude": latitude
        }));
    if (response.statusCode == 200) {
      return '';
    } else {
      return 'Error processing the delivery';
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> updateDeliveryDealer(Delivery delivery) async {
  //try {
  String route = 'api/delivery/${delivery.id}';
  final response = await put(Uri.http(Backend.direction, route),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': User.getInstance().token
      },
      body: jsonEncode(<String, dynamic>{"dealer": delivery.dealer}));
  if (response.statusCode == 200) {
    return '';
  } else {
    return 'Error updating delivery';
  }
  // } catch (e) {
  //   return e.toString();
  // }
}

Future<List> getDeliveries() async {
  try {
    String route = 'api/delivery';
    final response =
        await get(Uri.http(Backend.direction, route), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': User.getInstance().token
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

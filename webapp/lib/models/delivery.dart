class Delivery {
  late String id;
  late String address;
  late String city;
  late String? postcode;
  late String? customer;
  late String? phone;
  late String restaurant;

  late double? amount;

  late DateTime initTime;
  late DateTime? finishTime;
  late String? dealer;

  Delivery(
      {required this.id,
      required this.address,
      required this.city,
      required this.restaurant,
      required this.initTime,
      this.postcode,
      this.customer,
      this.phone,
      this.dealer,
      this.amount = 0.0,
      this.finishTime});

  Delivery.fromJson(var json) {
    id = json['_id'];
    address = json['address'];
    restaurant = json['restaurant'];
    city = json['city'];
    initTime = DateTime.parse(json['initTime']);
    amount = (json['amount'] ?? 0.0);
    customer = (json['customer'] ?? '');
    dealer = (json['dealer'] ?? '');
    phone = (json['phone'] ?? '');
    postcode = (json['postcode'] ?? '');
  }
}

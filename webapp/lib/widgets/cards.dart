import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webapp/models/delivery.dart';

import '../constants.dart';

class DeliveryCard extends StatefulWidget {
  const DeliveryCard({Key? key, required this.delivery}) : super(key: key);

  final Delivery delivery;

  @override
  _DeliveryCardState createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {
  int _minutes = 0;
  String? _state;
  Timer? _timer;
  String? _amount;
  double _height = 180;

  String _getDeliveryState() {
    if (widget.delivery.dealer != '') {
      if (widget.delivery.finishTime != null) return 'Delivered';
      return 'On its way';
    }
    return 'In kitchen';
  }

  void _getDeliveryMinutes() {
    if (_state != 'Delivered') {
      _minutes = DateTime.now().difference(widget.delivery.initTime).inMinutes;
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        setState(() {
          _minutes =
              DateTime.now().difference(widget.delivery.initTime).inMinutes;
        });
      });
    } else {
      _minutes = widget.delivery.finishTime!
          .difference(widget.delivery.initTime)
          .inMinutes;
    }
  }

  @override
  void initState() {
    _getDeliveryMinutes();
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _state = _getDeliveryState();
    if (widget.delivery.amount == -1) {
      _amount = '';
    } else {
      _amount = widget.delivery.amount.toString() + ' €';
    }
    return Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 30, right: 30),
        child: SizedBox(
            height: _height,
            width: 330,
            child: Container(
                color: ThemeColors.black,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, left: 50),
                                  child: const Icon(
                                    Icons.fastfood,
                                    size: 30,
                                    color: ThemeColors.white,
                                  )),
                              Flexible(
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 15, right: 30, left: 5),
                                      child: Text(
                                        widget.delivery.address +
                                            '\n' +
                                            widget.delivery.postcode!,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: const NormalTextStyle(),
                                      ))),
                            ],
                          )),
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 30),
                              child: Text(_state!,
                                  textAlign: TextAlign.left,
                                  style: const NormalTextStyle())),
                          Container(
                              margin: const EdgeInsets.only(right: 30),
                              child: Text(
                                widget.delivery.city,
                                textAlign: TextAlign.right,
                                style: const NormalTextStyle(),
                              )),
                        ],
                      )),
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.only(left: 30, bottom: 15),
                              child: Text(_minutes.toString() + ' minutes ago',
                                  textAlign: TextAlign.left,
                                  style: const NormalTextStyle())),
                          Container(
                              margin:
                                  const EdgeInsets.only(right: 30, bottom: 15),
                              child: Text(
                                _amount!,
                                textAlign: TextAlign.right,
                                style: const NormalTextStyle(),
                              )),
                        ],
                      ))
                    ]))));
  }
}

class NotificationCard extends StatefulWidget {
  const NotificationCard({Key? key, required this.notification})
      : super(key: key);

  final Notification notification;

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 30, right: 30),
        child: SizedBox(
            height: 150,
            width: 330,
            child: Container(
                color: ThemeColors.green,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 25),
                            child: const Icon(
                              Icons.mail,
                              size: 30,
                              color: ThemeColors.white,
                            )),
                      ),
                      Flexible(
                          flex: 5,
                          child: Column(children: [
                            Flexible(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 15, right: 30),
                                    child: Text(
                                      "New add in request",
                                      textAlign: TextAlign.right,
                                      style: const NormalTextStyle(),
                                    ))),
                            Flexible(
                                flex: 3,
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "Someone wants to work in your restaurant",
                                        textAlign: TextAlign.left,
                                        style: const NormalTextStyle()))),
                          ]))
                    ]))));
  }
}

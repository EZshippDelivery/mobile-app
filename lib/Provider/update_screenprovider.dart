import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ezshipp/Provider/update_order_povider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../APIs/new_orderlist.dart';
import '../utils/http_requests.dart';
import '../utils/variables.dart';

class UpdateScreenProvider extends ChangeNotifier {
  int inProgresOrderCount = 0;
  Timer? timer;
  int pageNumber = 1;

  List<NewOrderList> customerOrders = [];

  bool islastpageloaded1 = false;

  getInProgressOrderCount(BuildContext context) async {
    try {
      final response =
          await HTTPRequest.getRequest(Variables.uri(path: "/customer/${Variables.driverId}/orders/count"));
      var responseJson = Variables.returnResponse(context,response);
      if (responseJson != null) {
        inProgresOrderCount = responseJson;
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection',Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  updateScreen() {
    notifyListeners();
  }

  settimer(BuildContext context) {
    UpdateOrderProvider updateOrderProvider = Provider.of(context, listen: false);
    timer = Timer.periodic(const Duration(seconds: 10), (time) {
      getInProgressOrderCount(context);
      if (inProgresOrderCount > 0) {
        inProgressOrders(context);
        for (int i = 0; i < customerOrders.length; i++) {
          updateOrderProvider.customerOrders[i] = customerOrders[i];
        }
        notifyListeners();
      } else {
        time.cancel();
      }
    });
  }
  

  inProgressOrders(BuildContext context) async {
    try {
      final response =
          await HTTPRequest.getRequest(Variables.uri(path: "/customer/${Variables.driverId}/neworders/$pageNumber/20"));

      var responseJson = Variables.returnResponse(context,response);
      if (responseJson != null) {
        if (responseJson["data"].isNotEmpty) {
          if (pageNumber == 1) {
            customerOrders = List.generate(
                responseJson["data"].length, (index) => NewOrderList.fromMap(responseJson["data"][index]));
          } else if (pageNumber > 1) {
            customerOrders.addAll(responseJson["data"].map((e) => NewOrderList.fromMap(e)).toList());
          }
          islastpageloaded1 = false;
        } else {
          islastpageloaded1 = true;
        }
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  bikerRating(BuildContext context,int driverid, int orderid, int rating) async {
    try {
      Map body = {
        "carryingBag": true,
        "customerId": Variables.driverId,
        "deliveredProperly": true,
        "driverId": driverid,
        "notes": rating == 1
            ? "Very bad"
            : rating == 2
                ? "Bad"
                : rating == 3
                    ? "Not bad"
                    : rating == 4
                        ? "Good"
                        : "Very Good",
        "orderId": orderid,
        "rating": rating,
        "wearingTShirt": true
      };
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/biker/rating"), jsonEncode(body));
      Variables.returnResponse(context, response);
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }
}

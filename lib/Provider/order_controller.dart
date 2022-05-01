import 'dart:convert';
import 'dart:io';

import 'package:ezshipp/Provider/biker_controller.dart';
import 'package:flutter/material.dart';

import '../APIs/new_orderlist.dart';
import '../utils/http_requests.dart';
import '../utils/variables.dart';

class OrderController extends BikerController {
  bool loading4 = true;

  updateOrder(bool mounted, BuildContext context, String body, int orderid) async {
    Map<String, dynamic>? responseJson;
    try {
      final response = await HTTPRequest.putRequest(Variables.uri(path: "/order/$orderid"), body);
      if (!mounted) return;
      responseJson = Variables.returnResponse(context, response);
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading4 = false;
    notifyListeners();
    if (responseJson != null) return responseJson;
  }

  findOrderbyBarcode(bool mounted, BuildContext context, String value, int statusId) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "/order/find/barcode/$value"));
      if (response.statusCode == 500) {
        if (!mounted) return;
        Variables.showtoast(context, "Invalid Barcode", Icons.cancel_outlined);
      } else if (response.statusCode == 200) {
        var body = NewOrderList.fromJson(response.body);
        Variables.updateOrderMap.driverId = body.bikerId;
        Variables.updateOrderMap.newDriverId = Variables.driverId;
        Variables.updateOrderMap.barcode = value;
        Variables.getLiveLocation(statusId: statusId);
        if (!mounted) return;
        Variables.updateOrderMap.distance = (await getDistance(
            mounted,
            context,
            jsonEncode({
              "latitude": Variables.updateOrderMap.latitude,
              "longitude": Variables.updateOrderMap.longitude,
              "orderId": body.id
            })))!;
        Variables.updateOrderMap.zoneId = Variables.centers.indexWhere((element) => element.indexOf(body.zonedAt));
        Variables.updateOrderMap.collectAt = body.collectAt;
        if (!mounted) return;
        updateOrder(mounted, context, Variables.updateOrderMap.toJson(), body.id);
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  update(var data) {
    var obj = NewOrderList.fromMap(data);
    if (acceptedList.isNotEmpty) {
      for (var i in acceptedList) {
        if (i.orderSeqId == obj.orderSeqId) {
          acceptedList[acceptedList.indexOf(i)] = obj;
        }
      }
    }
    notifyListeners();
  }
}

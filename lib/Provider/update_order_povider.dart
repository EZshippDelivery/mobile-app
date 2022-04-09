import 'dart:convert';
import 'dart:io';

import 'package:ezshipp/APIs/my_orderlist.dart';
import 'package:flutter/material.dart';

import '../APIs/new_orderlist.dart';
import '../utils/http_requests.dart';
import '../utils/variables.dart';

class UpdateOrderProvider extends ChangeNotifier {
  List<NewOrderList> newOrderList = [], customerOrders = [];
  List<NewOrderList> deliveredList = [], acceptedList = [];
  bool loading = true, loading2 = true, loading3 = true, loading4 = true;
  late MyOrderList myorders;
  bool islastpageloaded = false, islastpageloaded1 = false;
  DateTime start = DateTime.now().subtract(const Duration(days: 7)), end = DateTime.now();

  Future<dynamic> gethttp(BuildContext context, String url) async {}

  newOrders(
    BuildContext context,
  ) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "/biker/orders/${Variables.driverId}/true"));
      List? responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        newOrderList = List.generate(responseJson.length, (index) => NewOrderList.fromMap(responseJson[index]));
        newOrderList = newOrderList.reversed.toList();
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading = false;
    notifyListeners();
  }

  update(BuildContext context, String body, int orderid) async {
    loading = true;
    try {
      final response = await HTTPRequest.putRequest(Variables.uri(path: "/order/$orderid"), body);
      Variables.returnResponse(context, response);
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading = false;
    notifyListeners();
  }

  findOrderbyBarcode(BuildContext context, String value, int statusId) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "/order/find/barcode/$value"));
      if (response.statusCode == 500) {
        Variables.showtoast(context, "Invalid Barcode", Icons.cancel_outlined);
      } else if (response.statusCode == 200) {
        var body = NewOrderList.fromJson(response.body);
        Variables.updateOrderMap.driverId = body.bikerId;
        Variables.updateOrderMap.newDriverId = Variables.driverId;
        Variables.updateOrderMap.barcode = value;
        Variables.getLiveLocation(statusId: statusId);
        Variables.updateOrderMap.distance = (await getDistance(
            context,
            jsonEncode({
              "latitude": Variables.updateOrderMap.latitude,
              "longitude": Variables.updateOrderMap.longitude,
              "orderId": body.id
            })))!;
        Variables.updateOrderMap.zoneId = Variables.centers.indexWhere((element) => element.indexOf(body.zonedAt));
        Variables.updateOrderMap.collectAt = body.collectAt;
        update(context, Variables.updateOrderMap.toJson(), body.id);
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  delivered(BuildContext context, driverid, int pagenumber, String startdate, String enddate) async {
    try {
      var body = MyOrderList(pageNumber: pagenumber, startDate: startdate, endDate: enddate);
      final response =
          await HTTPRequest.postRequest(Variables.uri(path: "/biker/orders/completed/$driverid"), body.toJson());
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        if (responseJson["data"].isNotEmpty) {
          deliveredList.addAll(responseJson["data"].map((e) => NewOrderList.fromMap(e)).toList());
          islastpageloaded = false;
        } else {
          islastpageloaded = true;
        }
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading3 = false;
    notifyListeners();
  }

  accepted(BuildContext context, int pagenumber, bool iscustomer) async {
    try {
      final response = iscustomer
          ? await HTTPRequest.getRequest(Variables.uri(path: "/customer/${Variables.driverId}/myorders/$pagenumber/20"))
          : await HTTPRequest.getRequest(
              Variables.uri(path: "/biker/orders/acceptedandinprogressorders/${Variables.driverId}/$pagenumber/20"));
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        if (responseJson["data"].isNotEmpty) {
          if (iscustomer && pagenumber == 1) {
            customerOrders = List.generate(
                responseJson["data"].length, (index) => NewOrderList.fromMap(responseJson["data"][index]));
          } else if (!iscustomer && pagenumber == 1) {
            acceptedList = List.generate(
                responseJson["data"].length, (index) => NewOrderList.fromMap(responseJson["data"][index]));
          } else if (iscustomer && pagenumber > 1) {
            customerOrders.addAll(responseJson["data"].map((e) => NewOrderList.fromMap(e)).toList());
          } else {
            acceptedList.addAll(responseJson["data"].map<NewOrderList>((e) => NewOrderList.fromMap(e)).toList());
          }
          islastpageloaded1 = false;
        } else {
          islastpageloaded1 = true;
        }
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading2 = false;
    notifyListeners();
  }

  setTime(BuildContext context, DateTime? value, bool end, int pageNumber) async {
    if (end) {
      this.end = value ?? this.end;
    } else {
      start = value ?? start;
    }
    await delivered(context, Variables.driverId, pageNumber, start.toString(), this.end.toString());
  }

  Future<double?> getDistance(BuildContext context, String body) async {
    try {
      final response =
          await HTTPRequest.postRequest(Variables.uri(path: "/biker/orders/${Variables.driverId}/distance"), body);
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        return responseJson[0]["distance"];
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    return null;
  }

  getRecentOrders(
    BuildContext context,
  ) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "/customer/${Variables.driverId}/orders"));
      List? responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        customerOrders = List.generate(responseJson.length, (index) => NewOrderList.fromMap(responseJson[index]));
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading4 = false;
    notifyListeners();
  }
}

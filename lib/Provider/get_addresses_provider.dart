import 'dart:convert';
import 'dart:io';

import 'package:ezshipp/APIs/add_address.dart';
import 'package:ezshipp/APIs/create_order.dart';
import 'package:ezshipp/APIs/get_top_addresses.dart';
import 'package:ezshipp/APIs/new_orderlist.dart';
import 'package:ezshipp/Provider/update_order_povider.dart';
import 'package:ezshipp/utils/http_requests.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class GetAddressesProvider extends ChangeNotifier {
  List<GetAllAddresses> getallAdresses = [];
  AddAddress addAddress = AddAddress.fromMap({}), addAddress1 = AddAddress.fromMap({});
  int? pickAddressId, dropAddressId;
  CreateOrder createOrder = CreateOrder.fromMap({});

  int delivery = 0;

  getAllAddresses(BuildContext context) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "/customer/${Variables.driverId}/address"));
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        getallAdresses = responseJson.map<GetAllAddresses>((e) => GetAllAddresses.fromMap(e)).toList();
        getallAdresses.sort((a, b) => a.addressType.compareTo(b.addressType));
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  saveAllAddresses(BuildContext context, AddAddress something, int index) async {
    var check = getallAdresses
        .where((element) =>
            something.address1 == element.address1 &&
            something.type == element.addressType &&
            something.latitude.toStringAsFixed(3) == element.latitude.toStringAsFixed(3) &&
            something.longitude.toStringAsFixed(3) == element.longitude.toStringAsFixed(3) &&
            something.landmark == element.landmark)
        .toList();
    if (check.isEmpty) {
      final response = await addAddresses(context, something.toJson());
      if (response != null) {
        if (index == 0) {
          createOrder.pickAddressId = response;
        } else {
          createOrder.deliveryAddressId = response;
        }
      }
    } else {
      if (index == 0) {
        createOrder.pickAddressId = check.first.addressId;
      } else {
        createOrder.deliveryAddressId = check.first.addressId;
      }
    }
    if (createOrder.deliveryAddressId > 0 && createOrder.pickAddressId > 0) getOrderCost(context);
  }

  getOrderCost(BuildContext context) async {
    Map<String, dynamic> map = {
      "bookingType": "SAMEDAY",
      "customerId": Variables.driverId,
      "deliveryAddressId": createOrder.deliveryAddressId,
      "pickAddressId": createOrder.pickAddressId
    };
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/customer/order/cost"), jsonEncode(map));
      createOrder.deliveryCharge = Variables.returnResponse(context, response) ?? 0;
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  addAddresses(BuildContext context, String body) async {
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/customer/address/add"), body);
      return Variables.returnResponse(context, response);
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  void deleteAddress(BuildContext context, getAddress) async {
    var removedAddress = getallAdresses.removeAt(getallAdresses.indexOf(getAddress));
    Variables.showtoast(context, "Address ID is ${removedAddress.addressId}", Icons.info_outline_rounded);
    try {
      final response =
          await delete(Variables.uri(path: "/customer/${Variables.driverId}/address/${removedAddress.addressId}"));
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        getallAdresses = responseJson.map((e) => GetAllAddresses.fromMap(e)).toList();
        getallAdresses.sort((a, b) => a.addressType.compareTo(b.addressType));
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  void setAddressType(String upperCase, {bool isdelivery = false}) {
    if (isdelivery) {
      addAddress1.type = upperCase;
    } else {
      addAddress.type = upperCase;
    }
    notifyListeners();
  }

  void setAddress(Map<String, dynamic> address, {bool isdelivery = false}) {
    if (isdelivery) {
      addAddress1 = AddAddress.fromMap(address);
    } else {
      addAddress = AddAddress.fromMap(address);
    }
    notifyListeners();
  }

  createOrderPost(BuildContext context, UpdateOrderProvider update) async {
    try {
      final response =
          await HTTPRequest.postRequest(Variables.uri(path: "/customer/order/create"), createOrder.toJson());
      final responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        update.customerOrders.insert(0, NewOrderList.fromMap(responseJson));
        Variables.showtoast(context, "Order creted successfully", Icons.check);
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }
}

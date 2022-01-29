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
import 'package:provider/provider.dart';

class GetAddressesProvider extends ChangeNotifier {
  List<GetAllAddresses> getallAdresses = [];
  int customerId = 18;
  AddAddress addAddress = AddAddress.fromMap({}), addAddress1 = AddAddress.fromMap({});
  int? pickAddressId, dropAddressId;
  CreateOrder createOrder = CreateOrder.fromMap({});

  int delivery = 0;

  getAllAddresses() async {
    try {
      final string = await Variables.pref.read(key: "savedAddress");
      final list = string != null ? jsonDecode(string) : [];
      if (list.isEmpty) {
        final response = await HTTPRequest.getRequest(Variables.uri(path: "/customer/$customerId/address"));
        var responseJson = Variables.returnResponse(response);
        if (responseJson != null) {
          getallAdresses = responseJson.map<GetAllAddresses>((e) => GetAllAddresses.fromMap(e)).toList();
          getallAdresses.sort((a, b) => a.addressType.compareTo(b.addressType));
          var value = getallAdresses.map((e) => e.toJson()).toList();
          Variables.pref.write(key: "savedAddress", value: jsonEncode(value));
        }
      } else {
        getallAdresses = list.map<GetAllAddresses>((e) => GetAllAddresses.fromJson(e)).toList();
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }

  saveAllAddresses(AddAddress something, int index) async {
    var check = getallAdresses
        .where((element) =>
            something.address1 == element.address1 &&
            something.type == element.addressType &&
            something.latitude.toStringAsFixed(3) == element.latitude.toStringAsFixed(3) &&
            something.longitude.toStringAsFixed(3) == element.longitude.toStringAsFixed(3) &&
            something.landmark == element.landmark)
        .toList();
    if (check.isEmpty) {
      final response = await addAddresses(something.toJson());
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
    if (createOrder.deliveryAddressId > 0 && createOrder.pickAddressId > 0) getOrderCost();
  }

  getOrderCost() async {
    Map<String, dynamic> map = {
      "bookingType": "SAMEDAY",
      "customerId": Variables.driverId,
      "deliveryAddressId": createOrder.deliveryAddressId,
      "pickAddressId": createOrder.pickAddressId
    };
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/customer/order/cost"), jsonEncode(map));
      createOrder.deliveryCharge = Variables.returnResponse(response) ?? 0;
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }

  addAddresses(body) async {
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/customer/address/add"), body);
      return Variables.returnResponse(response);
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }

  void deleteAddress(getAddress) async {
    var removedAddress = getallAdresses.removeAt(getallAdresses.indexOf(getAddress));
    Variables.showtoast("Address ID is ${removedAddress.addressId}");
    try {
      final response = await delete(Variables.uri(path: "/customer/$customerId/address/${removedAddress.addressId}"));
      var responseJson = Variables.returnResponse(response);
      if (responseJson != null) {
        getallAdresses = responseJson.map((e) => GetAllAddresses.fromMap(e)).toList();
        getallAdresses.sort((a, b) => a.addressType.compareTo(b.addressType));
      }
    } on SocketException {
      Variables.showtoast('No Internet connection');
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

  void createOrderPost(BuildContext context) async {
    try {
      final response =
          await HTTPRequest.postRequest(Variables.uri(path: "/customer/order/create"), createOrder.toJson());
      UpdateOrderProvider update = Provider.of(context, listen: false);
      update.customerOrders.insert(0, NewOrderList.fromMap(Variables.returnResponse(response)));
      Variables.showtoast("Order creted successfully");
    } on SocketException {
      Variables.showtoast('No Internet connection');
    }
    notifyListeners();
  }
}

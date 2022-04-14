import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ezshipp/Provider/biker_controller.dart';
import 'package:flutter/material.dart';

import '../APIs/add_address.dart';
import '../APIs/create_order.dart';
import '../APIs/get_customerprofile.dart';
import '../APIs/get_top_addresses.dart';
import '../APIs/new_orderlist.dart';
import '../APIs/update_customer_profile.dart';
import '../utils/http_requests.dart';
import '../utils/variables.dart';
import '../widgets/textfield.dart';

class CustomerController extends BikerController {
  AddAddress addAddress = AddAddress.fromMap({}), addAddress1 = AddAddress.fromMap({});
  List<GetAllAddresses> getFirstTenAddress = [];
  List<NewOrderList> customerOrders = [];
  CustomerDetails? customerProfile;
  CreateOrder? createNewOrder;

  bool loading4 = true;
  String customer = "/customer/";
  int inProgresOrderCount = 0;
  String plan = '';

  getCustomer(BuildContext context) async {
    final colorIndex = await Variables.read(key: "color_index");
    index = colorIndex == null ? Random().nextInt(Colors.primaries.length) : int.parse(colorIndex);
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "$customer${Variables.driverId}"));
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        customerProfile = CustomerDetails.fromMap(responseJson);
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    if (customerProfile != null) {
      plan = customerProfile!.premium ? "Premium" : "Standard";
      decorationImage = customerProfile!.profileUrl.isEmpty
          ? null
          : DecorationImage(image: MemoryImage(base64Decode(customerProfile!.profileUrl)));
      super.setName(customerProfile!.name);
      fullName = customerProfile!.name;
    }
    notifyListeners();
  }

  update(BuildContext context) async {
    try {
      var json = UpdateCustomerProfile(
          customerId: Variables.driverId,
          deviceToken: Variables.deviceInfo['deviceToken']!,
          email: TextFields.data["Email id"]!,
          firstName: TextFields.data["First Name"]!,
          lastName: TextFields.data["Last Name"]!,
          receiveEmail: customerProfile!.receiveEmail,
          receivePush: customerProfile!.receivePush,
          receiveSMS: customerProfile!.receiveSMS);
      final response =
          await HTTPRequest.putRequest(Variables.uri(path: "$customer${Variables.driverId}"), json.toJson());
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        Variables.showtoast(context, "Updating profile successfully", Icons.check);
        await getCustomer(context);
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  getFirstTenAddresses(BuildContext context) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "$customer${Variables.driverId}/address"));
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        getFirstTenAddress = responseJson.map<GetAllAddresses>((e) => GetAllAddresses.fromMap(e)).toList();
        getFirstTenAddress.sort((a, b) => a.addressType.compareTo(b.addressType));
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  saveAllAddresses(BuildContext context, AddAddress something, int index) async {
    var check = getFirstTenAddress
        .where((element) =>
            something.address1 == element.address1 &&
            something.type == element.addressType &&
            something.latitude.toStringAsFixed(3) == element.latitude.toStringAsFixed(3) &&
            something.longitude.toStringAsFixed(3) == element.longitude.toStringAsFixed(3) &&
            something.landmark == element.landmark)
        .toList();
    if (check.isEmpty) {
      final response = await addCustomerAddress(context, something.toJson());
      if (response != null) {
        if (index == 0) {
          createNewOrder!.pickAddressId = response;
        } else {
          createNewOrder!.deliveryAddressId = response;
        }
      }
    } else {
      if (index == 0) {
        createNewOrder!.pickAddressId = check.first.addressId;
      } else {
        createNewOrder!.deliveryAddressId = check.first.addressId;
      }
    }
    if (createNewOrder!.deliveryAddressId > 0 && createNewOrder!.pickAddressId > 0) calculateOrderCost(context);
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

  getCustomerOrderHistory(
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

  getCustomerOrders(BuildContext context) async {
    try {
      final response =
          await HTTPRequest.getRequest(Variables.uri(path: "$customer${Variables.driverId}/myorders/$pagenumber/20"));
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        Variables.orderscount = responseJson["totalCount"];
        if (responseJson["data"].isNotEmpty) {
          if (pagenumber > 1) {
            customerOrders.addAll(responseJson["data"].map((e) => NewOrderList.fromMap(e)).toList());
          } else if (pagenumber == 1) {
            customerOrders = List.generate(
                responseJson["data"].length, (index) => NewOrderList.fromMap(responseJson["data"][index]));
            isLastPage = false;
          } else {
            isLastPage = true;
          }
        }
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    loading2 = false;
    notifyListeners();
  }

  getCustomerNewOrders(BuildContext context) async {
    try {
      final response =
          await HTTPRequest.getRequest(Variables.uri(path: "/customer/${Variables.driverId}/neworders/$pagenumber/20"));

      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        if (responseJson["data"].isNotEmpty) {
          if (pagenumber == 1) {
            customerOrders = List.generate(
                responseJson["data"].length, (index) => NewOrderList.fromMap(responseJson["data"][index]));
          } else if (pagenumber > 1) {
            customerOrders.addAll(responseJson["data"].map((e) => NewOrderList.fromMap(e)).toList());
          }
          isLastPage = false;
        } else {
          isLastPage = true;
        }
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  getCustomerInProgressOrderCount(BuildContext context) async {
    try {
      final response = await HTTPRequest.getRequest(Variables.uri(path: "$customer${Variables.driverId}/orders/count"));
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        inProgresOrderCount = responseJson;
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  settimer(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 10), (time) {
      getCustomerInProgressOrderCount(context);
      if (inProgresOrderCount > 0) {
        getCustomerNewOrders(context);
        for (int i = 0; i < customerOrders.length; i++) {
          customerOrders[i] = customerOrders[i];
        }
        notifyListeners();
      } else {
        time.cancel();
      }
    });
  }

  addCustomerAddress(BuildContext context, String body) async {
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/customer/address/add"), body);
      return Variables.returnResponse(context, response);
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  calculateOrderCost(BuildContext context) async {
    Map<String, dynamic> map = {
      "bookingType": "SAMEDAY",
      "customerId": Variables.driverId,
      "deliveryAddressId": createNewOrder!.deliveryAddressId,
      "pickAddressId": createNewOrder!.pickAddressId
    };
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/customer/order/cost"), jsonEncode(map));
      createNewOrder!.deliveryCharge = Variables.returnResponse(context, response) ?? 0;
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  creatOrder(BuildContext context) async {
    try {
      final response =
          await HTTPRequest.postRequest(Variables.uri(path: "/customer/order/create"), createNewOrder!.toJson());
      final responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) {
        customerOrders.insert(0, NewOrderList.fromMap(responseJson));
        Variables.showtoast(context, "Order creted successfully", Icons.check);
      }
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    notifyListeners();
  }

  challengeOTP(BuildContext context, String body) async {
    try {
      final response = await HTTPRequest.postRequest(Variables.uri(path: "/customer/otp/generate"), body);
      var responseJson = Variables.returnResponse(context, response);
      if (responseJson != null) Variables.showtoast(context, "OTP send", Icons.check);
    } on SocketException catch (e) {
      Variables.showtoast(
          context, 'No Internet connection\n${e.message}', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
  }

  verifyOTP(BuildContext context, body) async {
    Map? responseJson;
    try {
      final response = await HTTPRequest.getRequest(
          Variables.uri(path: "/customer/otp/validate", queryParameters: body as Map<String, dynamic>));
      responseJson = Variables.returnResponse(context, response);
    } on SocketException {
      Variables.showtoast(context, 'No Internet connection', Icons.signal_cellular_connected_no_internet_4_bar_rounded);
    }
    return responseJson;
  }
}

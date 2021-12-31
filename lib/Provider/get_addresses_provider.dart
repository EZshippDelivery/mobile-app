import 'dart:io';

import 'package:ezshipp/APIs/add_address.dart';
import 'package:ezshipp/APIs/get_top_addresses.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class GetAddressesProvider extends ChangeNotifier {
  List<dynamic> getallAdresses = [];
  int customerId = 18;
  AddAddress addAddress = AddAddress.fromMap({});

  getAllAddresses() async {
    try {
      final response = await get(Variables.uri(path: "/customer/$customerId/address"));
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

  addAddresses(body) async {
    try {
      final response = await post(Variables.uri(path: "/customer/address/add"), body: body, headers: Variables.headers);
      Variables.returnResponse(response);
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

  void setAddressType(String upperCase) {
    addAddress.type = upperCase;
    notifyListeners();
  }
}

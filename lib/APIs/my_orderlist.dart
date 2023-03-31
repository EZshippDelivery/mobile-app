import 'dart:convert';

import 'package:collection/collection.dart';

class MyOrderList {
  final List<int> bikers = [0];
  final List<int> bookingTypes = [0];
  final bool clientOrders = true;
  final int customerId = 0;
  final String customerName = "string";
  final String customerPhone = "string";
  final String endDate;
  final String operator = "string";
  final int orderId = 0;
  final String orderSeqId = "string";
  int pageNumber;
  final int pageSize = 20;
  final List<int> paymentTypes = [0];
  final String receiverPhone = "string";
  final int sort = 0;
  final List<String> sortFields = ["statusId"];
  final String startDate;
  final List<int> statuses = [0];
  MyOrderList({
    required this.endDate,
    required this.pageNumber,
    required this.startDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'bikers': bikers,
      'bookingTypes': bookingTypes,
      'clientOrders': clientOrders,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'endDate': endDate,
      'operator': operator,
      'orderId': orderId,
      'orderSeqId': orderSeqId,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'paymentTypes': paymentTypes,
      'receiverPhone': receiverPhone,
      'sort': sort,
      'sortFields': sortFields,
      'startDate': startDate,
      'statuses': statuses,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'MyOrderList(bikers: $bikers, bookingTypes: $bookingTypes, clientOrders: $clientOrders, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, endDate: $endDate, operator: $operator, orderId: $orderId, orderSeqId: $orderSeqId, pageNumber: $pageNumber, pageSize: $pageSize, paymentTypes: $paymentTypes, receiverPhone: $receiverPhone, sort: $sort, sortFields: $sortFields, startDate: $startDate, statuses: $statuses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is MyOrderList &&
        listEquals(other.bikers, bikers) &&
        listEquals(other.bookingTypes, bookingTypes) &&
        other.clientOrders == clientOrders &&
        other.customerId == customerId &&
        other.customerName == customerName &&
        other.customerPhone == customerPhone &&
        other.endDate == endDate &&
        other.operator == operator &&
        other.orderId == orderId &&
        other.orderSeqId == orderSeqId &&
        other.pageNumber == pageNumber &&
        other.pageSize == pageSize &&
        listEquals(other.paymentTypes, paymentTypes) &&
        other.receiverPhone == receiverPhone &&
        other.sort == sort &&
        listEquals(other.sortFields, sortFields) &&
        other.startDate == startDate &&
        listEquals(other.statuses, statuses);
  }

  @override
  int get hashCode {
    return bikers.hashCode ^
        bookingTypes.hashCode ^
        clientOrders.hashCode ^
        customerId.hashCode ^
        customerName.hashCode ^
        customerPhone.hashCode ^
        endDate.hashCode ^
        operator.hashCode ^
        orderId.hashCode ^
        orderSeqId.hashCode ^
        pageNumber.hashCode ^
        pageSize.hashCode ^
        paymentTypes.hashCode ^
        receiverPhone.hashCode ^
        sort.hashCode ^
        sortFields.hashCode ^
        startDate.hashCode ^
        statuses.hashCode;
  }
}

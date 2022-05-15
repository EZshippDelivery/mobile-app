import 'dart:convert';

class CustomerOrdersList {
  final int bikerId;
  final String bikerName;
  final int bikerPhone;
  final String bikerProfileUrl;
  final String bookingType;
  final int codCharge;
  final bool collectAtPickup;
  final String customerName;
  final String customerPhone;
  final int deliveryCharge;
  final double distance;
  final String dropAddress;
  final int dropAddressId;
  final String dropFlatNumber;
  final String dropLandmark;
  final double dropLatitude;
  final double dropLongitude;
  final String externalId;
  final bool feedbackSubmitted;
  final int id;
  final String item;
  final String itemDescription;
  final String itemImage;
  final String orderCreatedTime;
  final String orderSeqId;
  final String orderType;
  final String paymentType;
  final String pickAddress;
  final int pickAddressId;
  final String pickFlatNumber;
  final String pickLandmark;
  final double pickLatitude;
  final double pickLongitude;
  final String receiverName;
  final String receiverPhone;
  final String senderName;
  final String senderPhone;
  final String status;
  final int statusId;
  final int totalCharge;
  CustomerOrdersList({
    required this.bikerId,
    required this.bikerName,
    required this.bikerPhone,
    required this.bikerProfileUrl,
    required this.bookingType,
    required this.codCharge,
    required this.collectAtPickup,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryCharge,
    required this.distance,
    required this.dropAddress,
    required this.dropAddressId,
    required this.dropFlatNumber,
    required this.dropLandmark,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.externalId,
    required this.feedbackSubmitted,
    required this.id,
    required this.item,
    required this.itemDescription,
    required this.itemImage,
    required this.orderCreatedTime,
    required this.orderSeqId,
    required this.orderType,
    required this.paymentType,
    required this.pickAddress,
    required this.pickAddressId,
    required this.pickFlatNumber,
    required this.pickLandmark,
    required this.pickLatitude,
    required this.pickLongitude,
    required this.receiverName,
    required this.receiverPhone,
    required this.senderName,
    required this.senderPhone,
    required this.status,
    required this.statusId,
    required this.totalCharge,
  });

  CustomerOrdersList copyWith({
    int? bikerId,
    String? bikerName,
    int? bikerPhone,
    String? bikerProfileUrl,
    String? bookingType,
    int? codCharge,
    bool? collectAtPickup,
    String? customerName,
    String? customerPhone,
    int? deliveryCharge,
    double? distance,
    String? dropAddress,
    int? dropAddressId,
    String? dropFlatNumber,
    String? dropLandmark,
    double? dropLatitude,
    double? dropLongitude,
    String? externalId,
    bool? feedbackSubmitted,
    int? id,
    String? item,
    String? itemDescription,
    String? itemImage,
    String? orderCreatedTime,
    String? orderSeqId,
    String? orderType,
    String? paymentType,
    String? pickAddress,
    int? pickAddressId,
    String? pickFlatNumber,
    String? pickLandmark,
    double? pickLatitude,
    double? pickLongitude,
    String? receiverName,
    String? receiverPhone,
    String? senderName,
    String? senderPhone,
    String? status,
    int? statusId,
    int? totalCharge,
  }) {
    return CustomerOrdersList(
      bikerId: bikerId ?? this.bikerId,
      bikerName: bikerName ?? this.bikerName,
      bikerPhone: bikerPhone ?? this.bikerPhone,
      bikerProfileUrl: bikerProfileUrl ?? this.bikerProfileUrl,
      bookingType: bookingType ?? this.bookingType,
      codCharge: codCharge ?? this.codCharge,
      collectAtPickup: collectAtPickup ?? this.collectAtPickup,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      distance: distance ?? this.distance,
      dropAddress: dropAddress ?? this.dropAddress,
      dropAddressId: dropAddressId ?? this.dropAddressId,
      dropFlatNumber: dropFlatNumber ?? this.dropFlatNumber,
      dropLandmark: dropLandmark ?? this.dropLandmark,
      dropLatitude: dropLatitude ?? this.dropLatitude,
      dropLongitude: dropLongitude ?? this.dropLongitude,
      externalId: externalId ?? this.externalId,
      feedbackSubmitted: feedbackSubmitted ?? this.feedbackSubmitted,
      id: id ?? this.id,
      item: item ?? this.item,
      itemDescription: itemDescription ?? this.itemDescription,
      itemImage: itemImage ?? this.itemImage,
      orderCreatedTime: orderCreatedTime ?? this.orderCreatedTime,
      orderSeqId: orderSeqId ?? this.orderSeqId,
      orderType: orderType ?? this.orderType,
      paymentType: paymentType ?? this.paymentType,
      pickAddress: pickAddress ?? this.pickAddress,
      pickAddressId: pickAddressId ?? this.pickAddressId,
      pickFlatNumber: pickFlatNumber ?? this.pickFlatNumber,
      pickLandmark: pickLandmark ?? this.pickLandmark,
      pickLatitude: pickLatitude ?? this.pickLatitude,
      pickLongitude: pickLongitude ?? this.pickLongitude,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      senderName: senderName ?? this.senderName,
      senderPhone: senderPhone ?? this.senderPhone,
      status: status ?? this.status,
      statusId: statusId ?? this.statusId,
      totalCharge: totalCharge ?? this.totalCharge,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'bikerId': bikerId});
    result.addAll({'bikerName': bikerName});
    result.addAll({'bikerPhone': bikerPhone});
    result.addAll({'bikerProfileUrl': bikerProfileUrl});
    result.addAll({'bookingType': bookingType});
    result.addAll({'codCharge': codCharge});
    result.addAll({'collectAtPickup': collectAtPickup});
    result.addAll({'customerName': customerName});
    result.addAll({'customerPhone': customerPhone});
    result.addAll({'deliveryCharge': deliveryCharge});
    result.addAll({'distance': distance});
    result.addAll({'dropAddress': dropAddress});
    result.addAll({'dropAddressId': dropAddressId});
    result.addAll({'dropFlatNumber': dropFlatNumber});
    result.addAll({'dropLandmark': dropLandmark});
    result.addAll({'dropLatitude': dropLatitude});
    result.addAll({'dropLongitude': dropLongitude});
    result.addAll({'externalId': externalId});
    result.addAll({'feedbackSubmitted': feedbackSubmitted});
    result.addAll({'id': id});
    result.addAll({'item': item});
    result.addAll({'itemDescription': itemDescription});
    result.addAll({'itemImage': itemImage});
    result.addAll({'orderCreatedTime': orderCreatedTime});
    result.addAll({'orderSeqId': orderSeqId});
    result.addAll({'orderType': orderType});
    result.addAll({'paymentType': paymentType});
    result.addAll({'pickAddress': pickAddress});
    result.addAll({'pickAddressId': pickAddressId});
    result.addAll({'pickFlatNumber': pickFlatNumber});
    result.addAll({'pickLandmark': pickLandmark});
    result.addAll({'pickLatitude': pickLatitude});
    result.addAll({'pickLongitude': pickLongitude});
    result.addAll({'receiverName': receiverName});
    result.addAll({'receiverPhone': receiverPhone});
    result.addAll({'senderName': senderName});
    result.addAll({'senderPhone': senderPhone});
    result.addAll({'status': status});
    result.addAll({'statusId': statusId});
    result.addAll({'totalCharge': totalCharge});

    return result;
  }

  factory CustomerOrdersList.fromMap(Map<String, dynamic> map) {
    return CustomerOrdersList(
      bikerId: map['bikerId']?.toInt() ?? 0,
      bikerName: map['bikerName'] ?? '',
      bikerPhone: map['bikerPhone']?.toInt() ?? 0,
      bikerProfileUrl: map['bikerProfileUrl'] ?? '',
      bookingType: map['bookingType'] ?? '',
      codCharge: map['codCharge']?.toInt() ?? 0,
      collectAtPickup: map['collectAtPickup'] ?? false,
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      deliveryCharge: map['deliveryCharge']?.toInt() ?? 0,
      distance: map['distance'] ?? 0,
      dropAddress: map['dropAddress'] ?? '',
      dropAddressId: map['dropAddressId']?.toInt() ?? 0,
      dropFlatNumber: map['dropFlatNumber'] ?? '',
      dropLandmark: map['dropLandmark'] ?? '',
      dropLatitude: map['dropLatitude']?.toInt() ?? 0,
      dropLongitude: map['dropLongitude']?.toInt() ?? 0,
      externalId: map['externalId'] ?? '',
      feedbackSubmitted: map['feedbackSubmitted'] ?? false,
      id: map['id']?.toInt() ?? 0,
      item: map['item'] ?? '',
      itemDescription: map['itemDescription'] ?? '',
      itemImage: map['itemImage'] ?? '',
      orderCreatedTime: map['orderCreatedTime'] ?? '',
      orderSeqId: map['orderSeqId'] ?? '',
      orderType: map['orderType'] ?? '',
      paymentType: map['paymentType'] ?? '',
      pickAddress: map['pickAddress'] ?? '',
      pickAddressId: map['pickAddressId']?.toInt() ?? 0,
      pickFlatNumber: map['pickFlatNumber'] ?? '',
      pickLandmark: map['pickLandmark'] ?? '',
      pickLatitude: map['pickLatitude']?.toInt() ?? 0,
      pickLongitude: map['pickLongitude']?.toInt() ?? 0,
      receiverName: map['receiverName'] ?? '',
      receiverPhone: map['receiverPhone'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhone: map['senderPhone'] ?? '',
      status: map['status'] ?? '',
      statusId: map['statusId']?.toInt() ?? 0,
      totalCharge: map['totalCharge']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerOrdersList.fromJson(String source) => CustomerOrdersList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CustomerOrdersList(bikerId: $bikerId, bikerName: $bikerName, bikerPhone: $bikerPhone, bikerProfileUrl: $bikerProfileUrl, bookingType: $bookingType, codCharge: $codCharge, collectAtPickup: $collectAtPickup, customerName: $customerName, customerPhone: $customerPhone, deliveryCharge: $deliveryCharge, distance: $distance, dropAddress: $dropAddress, dropAddressId: $dropAddressId, dropFlatNumber: $dropFlatNumber, dropLandmark: $dropLandmark, dropLatitude: $dropLatitude, dropLongitude: $dropLongitude, externalId: $externalId, feedbackSubmitted: $feedbackSubmitted, id: $id, item: $item, itemDescription: $itemDescription, itemImage: $itemImage, orderCreatedTime: $orderCreatedTime, orderSeqId: $orderSeqId, orderType: $orderType, paymentType: $paymentType, pickAddress: $pickAddress, pickAddressId: $pickAddressId, pickFlatNumber: $pickFlatNumber, pickLandmark: $pickLandmark, pickLatitude: $pickLatitude, pickLongitude: $pickLongitude, receiverName: $receiverName, receiverPhone: $receiverPhone, senderName: $senderName, senderPhone: $senderPhone, status: $status, statusId: $statusId, totalCharge: $totalCharge)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerOrdersList &&
        other.bikerId == bikerId &&
        other.bikerName == bikerName &&
        other.bikerPhone == bikerPhone &&
        other.bikerProfileUrl == bikerProfileUrl &&
        other.bookingType == bookingType &&
        other.codCharge == codCharge &&
        other.collectAtPickup == collectAtPickup &&
        other.customerName == customerName &&
        other.customerPhone == customerPhone &&
        other.deliveryCharge == deliveryCharge &&
        other.distance == distance &&
        other.dropAddress == dropAddress &&
        other.dropAddressId == dropAddressId &&
        other.dropFlatNumber == dropFlatNumber &&
        other.dropLandmark == dropLandmark &&
        other.dropLatitude == dropLatitude &&
        other.dropLongitude == dropLongitude &&
        other.externalId == externalId &&
        other.feedbackSubmitted == feedbackSubmitted &&
        other.id == id &&
        other.item == item &&
        other.itemDescription == itemDescription &&
        other.itemImage == itemImage &&
        other.orderCreatedTime == orderCreatedTime &&
        other.orderSeqId == orderSeqId &&
        other.orderType == orderType &&
        other.paymentType == paymentType &&
        other.pickAddress == pickAddress &&
        other.pickAddressId == pickAddressId &&
        other.pickFlatNumber == pickFlatNumber &&
        other.pickLandmark == pickLandmark &&
        other.pickLatitude == pickLatitude &&
        other.pickLongitude == pickLongitude &&
        other.receiverName == receiverName &&
        other.receiverPhone == receiverPhone &&
        other.senderName == senderName &&
        other.senderPhone == senderPhone &&
        other.status == status &&
        other.statusId == statusId &&
        other.totalCharge == totalCharge;
  }

  @override
  int get hashCode {
    return bikerId.hashCode ^
        bikerName.hashCode ^
        bikerPhone.hashCode ^
        bikerProfileUrl.hashCode ^
        bookingType.hashCode ^
        codCharge.hashCode ^
        collectAtPickup.hashCode ^
        customerName.hashCode ^
        customerPhone.hashCode ^
        deliveryCharge.hashCode ^
        distance.hashCode ^
        dropAddress.hashCode ^
        dropAddressId.hashCode ^
        dropFlatNumber.hashCode ^
        dropLandmark.hashCode ^
        dropLatitude.hashCode ^
        dropLongitude.hashCode ^
        externalId.hashCode ^
        feedbackSubmitted.hashCode ^
        id.hashCode ^
        item.hashCode ^
        itemDescription.hashCode ^
        itemImage.hashCode ^
        orderCreatedTime.hashCode ^
        orderSeqId.hashCode ^
        orderType.hashCode ^
        paymentType.hashCode ^
        pickAddress.hashCode ^
        pickAddressId.hashCode ^
        pickFlatNumber.hashCode ^
        pickLandmark.hashCode ^
        pickLatitude.hashCode ^
        pickLongitude.hashCode ^
        receiverName.hashCode ^
        receiverPhone.hashCode ^
        senderName.hashCode ^
        senderPhone.hashCode ^
        status.hashCode ^
        statusId.hashCode ^
        totalCharge.hashCode;
  }
}

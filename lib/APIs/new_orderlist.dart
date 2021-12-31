import 'dart:convert';

class NewOrderList {
  final String acceptedTime;
  final int additionalWeightCharge;
  final String barCode;
  String bikerComments;
  final String bikerCommentsUpdatedBy;
  final int bikerId;
  final String bikerName;
  final int bikerPhone;
  final String bikerProfileUrl;
  final String bookingType;
  final int bookingTypeId;
  final String cancellationReason;
  final String cancelledBy;
  final int codCharge;
  final String collectAt;
  final bool collectAtPickup;
  final String commentsUpdatedBy;
  final bool customerCancelled;
  final String customerName;
  final String customerPhone;
  final int dateTime;
  final String deliveredAt;
  final String deliveredBy;
  final String deliveredTime;
  final int deliveryCharge;
  final String dropAddress;
  final int dropAddressId;
  final String dropFlatNumber;
  final String dropLandmark;
  final double dropLatitude;
  final double dropLongitude;
  final String dropZone;
  final bool feedbackSubmitted;
  final int id;
  final String item;
  final String itemDescription;
  final String itemImage;
  final int itemWeight;
  final String orderComments;
  final int orderCount;
  final DateTime orderCreatedTime;
  final String orderSeqId;
  final String orderType;
  final String paymentType;
  final String pickAddress;
  final int pickAddressId;
  final double pickDistance;
  final double pickDuration;
  final String pickFlatNumber;
  final String pickLandmark;
  final double pickLatitude;
  final double pickLongitude;
  final double pickToDropDistance;
  final double pickToDropDuration;
  final String pickZone;
  final String pickedBy;
  final String pickedTime;
  final String receiverName;
  final String receiverPhone;
  final String senderName;
  final String senderPhone;
  final String status;
  final int statusId;
  final String statusUpdatedBy;
  final int totalCharge;
  final double totalDuration;
  final String zonedAt;
  NewOrderList({
    required this.acceptedTime,
    required this.additionalWeightCharge,
    required this.barCode,
    required this.bikerComments,
    required this.bikerCommentsUpdatedBy,
    required this.bikerId,
    required this.bikerName,
    required this.bikerPhone,
    required this.bikerProfileUrl,
    required this.bookingType,
    required this.bookingTypeId,
    required this.cancellationReason,
    required this.cancelledBy,
    required this.codCharge,
    required this.collectAt,
    required this.collectAtPickup,
    required this.commentsUpdatedBy,
    required this.customerCancelled,
    required this.customerName,
    required this.customerPhone,
    required this.dateTime,
    required this.deliveredAt,
    required this.deliveredBy,
    required this.deliveredTime,
    required this.deliveryCharge,
    required this.dropAddress,
    required this.dropAddressId,
    required this.dropFlatNumber,
    required this.dropLandmark,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.dropZone,
    required this.feedbackSubmitted,
    required this.id,
    required this.item,
    required this.itemDescription,
    required this.itemImage,
    required this.itemWeight,
    required this.orderComments,
    required this.orderCount,
    required this.orderCreatedTime,
    required this.orderSeqId,
    required this.orderType,
    required this.paymentType,
    required this.pickAddress,
    required this.pickAddressId,
    required this.pickDistance,
    required this.pickDuration,
    required this.pickFlatNumber,
    required this.pickLandmark,
    required this.pickLatitude,
    required this.pickLongitude,
    required this.pickToDropDistance,
    required this.pickToDropDuration,
    required this.pickZone,
    required this.pickedBy,
    required this.pickedTime,
    required this.receiverName,
    required this.receiverPhone,
    required this.senderName,
    required this.senderPhone,
    required this.status,
    required this.statusId,
    required this.statusUpdatedBy,
    required this.totalCharge,
    required this.totalDuration,
    required this.zonedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'acceptedTime': acceptedTime,
      'additionalWeightCharge': additionalWeightCharge,
      'barCode': barCode,
      'bikerComments': bikerComments,
      'bikerCommentsUpdatedBy': bikerCommentsUpdatedBy,
      'bikerId': bikerId,
      'bikerName': bikerName,
      'bikerPhone': bikerPhone,
      'bikerProfileUrl': bikerProfileUrl,
      'bookingType': bookingType,
      'bookingTypeId': bookingTypeId,
      'cancellationReason': cancellationReason,
      'cancelledBy': cancelledBy,
      'codCharge': codCharge,
      'collectAt': collectAt,
      'collectAtPickup': collectAtPickup,
      'commentsUpdatedBy': commentsUpdatedBy,
      'customerCancelled': customerCancelled,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'dateTime': dateTime,
      'deliveredAt': deliveredAt,
      'deliveredBy': deliveredBy,
      'deliveredTime': deliveredTime,
      'deliveryCharge': deliveryCharge,
      'dropAddress': dropAddress,
      'dropAddressId': dropAddressId,
      'dropFlatNumber': dropFlatNumber,
      'dropLandmark': dropLandmark,
      'dropLatitude': dropLatitude,
      'dropLongitude': dropLongitude,
      'dropZone': dropZone,
      'feedbackSubmitted': feedbackSubmitted,
      'id': id,
      'item': item,
      'itemDescription': itemDescription,
      'itemImage': itemImage,
      'itemWeight': itemWeight,
      'orderComments': orderComments,
      'orderCount': orderCount,
      'orderCreatedTime': orderCreatedTime.toString(),
      'orderSeqId': orderSeqId,
      'orderType': orderType,
      'paymentType': paymentType,
      'pickAddress': pickAddress,
      'pickAddressId': pickAddressId,
      'pickDistance': pickDistance,
      'pickDuration': pickDuration,
      'pickFlatNumber': pickFlatNumber,
      'pickLandmark': pickLandmark,
      'pickLatitude': pickLatitude,
      'pickLongitude': pickLongitude,
      'pickToDropDistance': pickToDropDistance,
      'pickToDropDuration': pickToDropDuration,
      'pickZone': pickZone,
      'pickedBy': pickedBy,
      'pickedTime': pickedTime,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'senderName': senderName,
      'senderPhone': senderPhone,
      'status': status,
      'statusId': statusId,
      'statusUpdatedBy': statusUpdatedBy,
      'totalCharge': totalCharge,
      'totalDuration': totalDuration,
      'zonedAt': zonedAt,
    };
  }

  factory NewOrderList.fromMap(Map<String, dynamic> map) {
    return NewOrderList(
      acceptedTime: map['acceptedTime'] ?? '',
      additionalWeightCharge: map['additionalWeightCharge']?.toInt() ?? 0,
      barCode: map['barCode'] ?? '',
      bikerComments: map['bikerComments'] ?? '',
      bikerCommentsUpdatedBy: map['bikerCommentsUpdatedBy'] ?? '',
      bikerId: map['bikerId']?.toInt() ?? 0,
      bikerName: map['bikerName'] ?? '',
      bikerPhone: map['bikerPhone']?.toInt() ?? 0,
      bikerProfileUrl: map['bikerProfileUrl'] ?? '',
      bookingType: map['bookingType'] ?? '',
      bookingTypeId: map['bookingTypeId']?.toInt() ?? 0,
      cancellationReason: map['cancellationReason'] ?? '',
      cancelledBy: map['cancelledBy'] ?? '',
      codCharge: map['codCharge']?.toInt() ?? 0,
      collectAt: map['collectAt'] ?? '',
      collectAtPickup: map['collectAtPickup'] ?? false,
      commentsUpdatedBy: map['commentsUpdatedBy'] ?? '',
      customerCancelled: map['customerCancelled'] ?? false,
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      dateTime: map['dateTime']?.toInt() ?? 0,
      deliveredAt: map['deliveredAt'] ?? '',
      deliveredBy: map['deliveredBy'] ?? '',
      deliveredTime: map['deliveredTime'] ?? '',
      deliveryCharge: map['deliveryCharge']?.toInt() ?? 0,
      dropAddress: map['dropAddress'] ?? '',
      dropAddressId: map['dropAddressId']?.toInt() ?? 0,
      dropFlatNumber: map['dropFlatNumber'] ?? '',
      dropLandmark: map['dropLandmark'] ?? '',
      dropLatitude: map['dropLatitude'] ?? 0,
      dropLongitude: map['dropLongitude'] ?? 0,
      dropZone: map['dropZone'] ?? '',
      feedbackSubmitted: map['feedbackSubmitted'] ?? false,
      id: map['id']?.toInt() ?? 0,
      item: map['item'] ?? '',
      itemDescription: map['itemDescription'] ?? '',
      itemImage: map['itemImage'] ?? '',
      itemWeight: map['itemWeight']?.toInt() ?? 0,
      orderComments: map['orderComments'] ?? '',
      orderCount: map['orderCount']?.toInt() ?? 0,
      orderCreatedTime: DateTime.parse(map['orderCreatedTime']),
      orderSeqId: map['orderSeqId'] ?? '',
      orderType: map['orderType'] ?? '',
      paymentType: map['paymentType'] ?? '',
      pickAddress: map['pickAddress'] ?? '',
      pickAddressId: map['pickAddressId']?.toInt() ?? 0,
      pickDistance: map['pickDistance'] ?? 0,
      pickDuration: map['pickDuration'] ?? 0,
      pickFlatNumber: map['pickFlatNumber'] ?? '',
      pickLandmark: map['pickLandmark'] ?? '',
      pickLatitude: map['pickLatitude'] ?? 0,
      pickLongitude: map['pickLongitude'] ?? 0,
      pickToDropDistance: map['pickToDropDistance'] ?? 0,
      pickToDropDuration: map['pickToDropDuration'] ?? 0,
      pickZone: map['pickZone'] ?? '',
      pickedBy: map['pickedBy'] ?? '',
      pickedTime: map['pickedTime'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPhone: map['receiverPhone'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhone: map['senderPhone'] ?? '',
      status: map['status'] ?? '',
      statusId: map['statusId']?.toInt() ?? 0,
      statusUpdatedBy: map['statusUpdatedBy'] ?? '',
      totalCharge: map['totalCharge']?.toInt() ?? 0,
      totalDuration: map['totalDuration'] ?? 0,
      zonedAt: map['zonedAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewOrderList.fromJson(String source) => NewOrderList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NewOrder(acceptedTime: $acceptedTime, additionalWeightCharge: $additionalWeightCharge, barCode: $barCode, bikerComments: $bikerComments, bikerCommentsUpdatedBy: $bikerCommentsUpdatedBy, bikerId: $bikerId, bikerName: $bikerName, bikerPhone: $bikerPhone, bikerProfileUrl: $bikerProfileUrl, bookingType: $bookingType, bookingTypeId: $bookingTypeId, cancellationReason: $cancellationReason, cancelledBy: $cancelledBy, codCharge: $codCharge, collectAt: $collectAt, collectAtPickup: $collectAtPickup, commentsUpdatedBy: $commentsUpdatedBy, customerCancelled: $customerCancelled, customerName: $customerName, customerPhone: $customerPhone, dateTime: $dateTime, deliveredAt: $deliveredAt, deliveredBy: $deliveredBy, deliveredTime: $deliveredTime, deliveryCharge: $deliveryCharge, dropAddress: $dropAddress, dropAddressId: $dropAddressId, dropFlatNumber: $dropFlatNumber, dropLandmark: $dropLandmark, dropLatitude: $dropLatitude, dropLongitude: $dropLongitude, dropZone: $dropZone, feedbackSubmitted: $feedbackSubmitted, id: $id, item: $item, itemDescription: $itemDescription, itemImage: $itemImage, itemWeight: $itemWeight, orderComments: $orderComments, orderCount: $orderCount, orderCreatedTime: $orderCreatedTime, orderSeqId: $orderSeqId, orderType: $orderType, paymentType: $paymentType, pickAddress: $pickAddress, pickAddressId: $pickAddressId, pickDistance: $pickDistance, pickDuration: $pickDuration, pickFlatNumber: $pickFlatNumber, pickLandmark: $pickLandmark, pickLatitude: $pickLatitude, pickLongitude: $pickLongitude, pickToDropDistance: $pickToDropDistance, pickToDropDuration: $pickToDropDuration, pickZone: $pickZone, pickedBy: $pickedBy, pickedTime: $pickedTime, receiverName: $receiverName, receiverPhone: $receiverPhone, senderName: $senderName, senderPhone: $senderPhone, status: $status, statusId: $statusId, statusUpdatedBy: $statusUpdatedBy, totalCharge: $totalCharge, totalDuration: $totalDuration, zonedAt: $zonedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NewOrderList &&
        other.acceptedTime == acceptedTime &&
        other.additionalWeightCharge == additionalWeightCharge &&
        other.barCode == barCode &&
        other.bikerComments == bikerComments &&
        other.bikerCommentsUpdatedBy == bikerCommentsUpdatedBy &&
        other.bikerId == bikerId &&
        other.bikerName == bikerName &&
        other.bikerPhone == bikerPhone &&
        other.bikerProfileUrl == bikerProfileUrl &&
        other.bookingType == bookingType &&
        other.bookingTypeId == bookingTypeId &&
        other.cancellationReason == cancellationReason &&
        other.cancelledBy == cancelledBy &&
        other.codCharge == codCharge &&
        other.collectAt == collectAt &&
        other.collectAtPickup == collectAtPickup &&
        other.commentsUpdatedBy == commentsUpdatedBy &&
        other.customerCancelled == customerCancelled &&
        other.customerName == customerName &&
        other.customerPhone == customerPhone &&
        other.dateTime == dateTime &&
        other.deliveredAt == deliveredAt &&
        other.deliveredBy == deliveredBy &&
        other.deliveredTime == deliveredTime &&
        other.deliveryCharge == deliveryCharge &&
        other.dropAddress == dropAddress &&
        other.dropAddressId == dropAddressId &&
        other.dropFlatNumber == dropFlatNumber &&
        other.dropLandmark == dropLandmark &&
        other.dropLatitude == dropLatitude &&
        other.dropLongitude == dropLongitude &&
        other.dropZone == dropZone &&
        other.feedbackSubmitted == feedbackSubmitted &&
        other.id == id &&
        other.item == item &&
        other.itemDescription == itemDescription &&
        other.itemImage == itemImage &&
        other.itemWeight == itemWeight &&
        other.orderComments == orderComments &&
        other.orderCount == orderCount &&
        other.orderCreatedTime == orderCreatedTime &&
        other.orderSeqId == orderSeqId &&
        other.orderType == orderType &&
        other.paymentType == paymentType &&
        other.pickAddress == pickAddress &&
        other.pickAddressId == pickAddressId &&
        other.pickDistance == pickDistance &&
        other.pickDuration == pickDuration &&
        other.pickFlatNumber == pickFlatNumber &&
        other.pickLandmark == pickLandmark &&
        other.pickLatitude == pickLatitude &&
        other.pickLongitude == pickLongitude &&
        other.pickToDropDistance == pickToDropDistance &&
        other.pickToDropDuration == pickToDropDuration &&
        other.pickZone == pickZone &&
        other.pickedBy == pickedBy &&
        other.pickedTime == pickedTime &&
        other.receiverName == receiverName &&
        other.receiverPhone == receiverPhone &&
        other.senderName == senderName &&
        other.senderPhone == senderPhone &&
        other.status == status &&
        other.statusId == statusId &&
        other.statusUpdatedBy == statusUpdatedBy &&
        other.totalCharge == totalCharge &&
        other.totalDuration == totalDuration &&
        other.zonedAt == zonedAt;
  }

  @override
  int get hashCode {
    return acceptedTime.hashCode ^
        additionalWeightCharge.hashCode ^
        barCode.hashCode ^
        bikerComments.hashCode ^
        bikerCommentsUpdatedBy.hashCode ^
        bikerId.hashCode ^
        bikerName.hashCode ^
        bikerPhone.hashCode ^
        bikerProfileUrl.hashCode ^
        bookingType.hashCode ^
        bookingTypeId.hashCode ^
        cancellationReason.hashCode ^
        cancelledBy.hashCode ^
        codCharge.hashCode ^
        collectAt.hashCode ^
        collectAtPickup.hashCode ^
        commentsUpdatedBy.hashCode ^
        customerCancelled.hashCode ^
        customerName.hashCode ^
        customerPhone.hashCode ^
        dateTime.hashCode ^
        deliveredAt.hashCode ^
        deliveredBy.hashCode ^
        deliveredTime.hashCode ^
        deliveryCharge.hashCode ^
        dropAddress.hashCode ^
        dropAddressId.hashCode ^
        dropFlatNumber.hashCode ^
        dropLandmark.hashCode ^
        dropLatitude.hashCode ^
        dropLongitude.hashCode ^
        dropZone.hashCode ^
        feedbackSubmitted.hashCode ^
        id.hashCode ^
        item.hashCode ^
        itemDescription.hashCode ^
        itemImage.hashCode ^
        itemWeight.hashCode ^
        orderComments.hashCode ^
        orderCount.hashCode ^
        orderCreatedTime.hashCode ^
        orderSeqId.hashCode ^
        orderType.hashCode ^
        paymentType.hashCode ^
        pickAddress.hashCode ^
        pickAddressId.hashCode ^
        pickDistance.hashCode ^
        pickDuration.hashCode ^
        pickFlatNumber.hashCode ^
        pickLandmark.hashCode ^
        pickLatitude.hashCode ^
        pickLongitude.hashCode ^
        pickToDropDistance.hashCode ^
        pickToDropDuration.hashCode ^
        pickZone.hashCode ^
        pickedBy.hashCode ^
        pickedTime.hashCode ^
        receiverName.hashCode ^
        receiverPhone.hashCode ^
        senderName.hashCode ^
        senderPhone.hashCode ^
        status.hashCode ^
        statusId.hashCode ^
        statusUpdatedBy.hashCode ^
        totalCharge.hashCode ^
        totalDuration.hashCode ^
        zonedAt.hashCode;
  }
}

class OrderCreatedTime {
  final int date;
  final int day;
  final int hours;
  final int minutes;
  final int month;
  final int nanos;
  final int seconds;
  final int time;
  final int timezoneOffset;
  final int year;
  OrderCreatedTime({
    required this.date,
    required this.day,
    required this.hours,
    required this.minutes,
    required this.month,
    required this.nanos,
    required this.seconds,
    required this.time,
    required this.timezoneOffset,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'day': day,
      'hours': hours,
      'minutes': minutes,
      'month': month,
      'nanos': nanos,
      'seconds': seconds,
      'time': time,
      'timezoneOffset': timezoneOffset,
      'year': year,
    };
  }

  factory OrderCreatedTime.fromMap(Map<String, dynamic> map) {
    return OrderCreatedTime(
      date: map['date']?.toInt() ?? 0,
      day: map['day']?.toInt() ?? 0,
      hours: map['hours']?.toInt() ?? 0,
      minutes: map['minutes']?.toInt() ?? 0,
      month: map['month']?.toInt() ?? 0,
      nanos: map['nanos']?.toInt() ?? 0,
      seconds: map['seconds']?.toInt() ?? 0,
      time: map['time']?.toInt() ?? 0,
      timezoneOffset: map['timezoneOffset']?.toInt() ?? 0,
      year: map['year']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderCreatedTime.fromJson(String source) => OrderCreatedTime.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderCreatedTime(date: $date, day: $day, hours: $hours, minutes: $minutes, month: $month, nanos: $nanos, seconds: $seconds, time: $time, timezoneOffset: $timezoneOffset, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderCreatedTime &&
        other.date == date &&
        other.day == day &&
        other.hours == hours &&
        other.minutes == minutes &&
        other.month == month &&
        other.nanos == nanos &&
        other.seconds == seconds &&
        other.time == time &&
        other.timezoneOffset == timezoneOffset &&
        other.year == year;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        day.hashCode ^
        hours.hashCode ^
        minutes.hashCode ^
        month.hashCode ^
        nanos.hashCode ^
        seconds.hashCode ^
        time.hashCode ^
        timezoneOffset.hashCode ^
        year.hashCode;
  }
}

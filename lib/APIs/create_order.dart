import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';

class CreateOrder {
  double amount;
  String bookingType;
  int codAmount;
  bool collectAtPickUp;
  int customerId;
  int deliveryAddressId;
  double deliveryCharge;
  String externalId;
  String itemDescription;
  String itemImageUrl;
  String itemName;
  int offerId;
  String orderSource;
  String orderType;
  String payType;
  String paymentId;
  int pickAddressId;
  String receiverName;
  String receiverPhone;
  String senderName;
  String senderPhone;
  int lastModifiedBy;
  int createdBy;
  CreateOrder({
    required this.amount,
    required this.bookingType,
    required this.codAmount,
    required this.collectAtPickUp,
    required this.customerId,
    required this.deliveryAddressId,
    required this.deliveryCharge,
    required this.externalId,
    required this.itemDescription,
    required this.itemImageUrl,
    required this.itemName,
    required this.offerId,
    required this.orderSource,
    required this.orderType,
    required this.payType,
    required this.paymentId,
    required this.pickAddressId,
    required this.receiverName,
    required this.receiverPhone,
    required this.senderName,
    required this.senderPhone,
    required this.lastModifiedBy,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'bookingType': bookingType,
      'codAmount': codAmount,
      'collectAtPickUp': collectAtPickUp,
      'customerId': customerId,
      'deliveryAddressId': deliveryAddressId,
      'deliveryCharge': deliveryCharge,
      'externalId': externalId,
      'itemDescription': itemDescription,
      'itemImageUrl': itemImageUrl,
      'itemName': itemName,
      'offerId': offerId,
      'orderSource': orderSource,
      'orderType': orderType,
      'payType': payType,
      'paymentId': paymentId,
      'pickAddressId': pickAddressId,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'senderName': senderName,
      'senderPhone': senderPhone,
      'lastModifiedBy': lastModifiedBy,
      'createdBy': createdBy,
    };
  }

  factory CreateOrder.fromMap(Map<String, dynamic> map) {
    return CreateOrder(
      amount: map['amount']?.toInt() ?? 0,
      bookingType: map['bookingType'] ?? '',
      codAmount: map['codAmount']?.toInt() ?? 0,
      collectAtPickUp: map['collectAtPickUp'] ?? false,
      customerId: map['customerId']?.toInt() ?? 0,
      deliveryAddressId: map['deliveryAddressId']?.toInt() ?? 0,
      deliveryCharge: map['deliveryCharge']?.toInt() ?? 0,
      externalId: map['externalId'] ?? '',
      itemDescription: map['itemDescription'] ?? '',
      itemImageUrl: map['itemImageUrl'] ?? '',
      itemName: map['itemName'] ?? '',
      offerId: map['offerId']?.toInt() ?? 0,
      orderSource: map['orderSource'] ?? '',
      orderType: map['orderType'] ?? '',
      payType: map['payType'] ?? '',
      paymentId: map['paymentId'] ?? '',
      pickAddressId: map['pickAddressId']?.toInt() ?? 0,
      receiverName: map['receiverName'] ?? '',
      receiverPhone: map['receiverPhone'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhone: map['senderPhone'] ?? '',
      lastModifiedBy: map['lastModifiedBy']?.toInt() ?? 0,
      createdBy: map['createdBy']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateOrder.fromJson(String source) => CreateOrder.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreateOrder(amount: $amount, bookingType: $bookingType, codAmount: $codAmount, collectAtPickUp: $collectAtPickUp, customerId: $customerId, deliveryAddressId: $deliveryAddressId, deliveryCharge: $deliveryCharge, externalId: $externalId, itemDescription: $itemDescription, itemImageUrl: $itemImageUrl, itemName: $itemName, offerId: $offerId, orderSource: $orderSource, orderType: $orderType, payType: $payType, paymentId: $paymentId, pickAddressId: $pickAddressId, receiverName: $receiverName, receiverPhone: $receiverPhone, senderName: $senderName, senderPhone: $senderPhone, lastModifiedBy: $lastModifiedBy, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateOrder &&
        other.amount == amount &&
        other.bookingType == bookingType &&
        other.codAmount == codAmount &&
        other.collectAtPickUp == collectAtPickUp &&
        other.customerId == customerId &&
        other.deliveryAddressId == deliveryAddressId &&
        other.deliveryCharge == deliveryCharge &&
        other.externalId == externalId &&
        other.itemDescription == itemDescription &&
        other.itemImageUrl == itemImageUrl &&
        other.itemName == itemName &&
        other.offerId == offerId &&
        other.orderSource == orderSource &&
        other.orderType == orderType &&
        other.payType == payType &&
        other.paymentId == paymentId &&
        other.pickAddressId == pickAddressId &&
        other.receiverName == receiverName &&
        other.receiverPhone == receiverPhone &&
        other.senderName == senderName &&
        other.senderPhone == senderPhone &&
        other.lastModifiedBy == lastModifiedBy &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        bookingType.hashCode ^
        codAmount.hashCode ^
        collectAtPickUp.hashCode ^
        customerId.hashCode ^
        deliveryAddressId.hashCode ^
        deliveryCharge.hashCode ^
        externalId.hashCode ^
        itemDescription.hashCode ^
        itemImageUrl.hashCode ^
        itemName.hashCode ^
        offerId.hashCode ^
        orderSource.hashCode ^
        orderType.hashCode ^
        payType.hashCode ^
        paymentId.hashCode ^
        pickAddressId.hashCode ^
        receiverName.hashCode ^
        receiverPhone.hashCode ^
        senderName.hashCode ^
        senderPhone.hashCode ^
        lastModifiedBy.hashCode ^
        createdBy.hashCode;
  }
}

import 'dart:convert';

class UpdateOrder {
  String barcode;
  String cancelReason;
  int cancelReasonId;
  String collectAt;
  String deliveredAt;
  double distance;
  String driverComments;
  int driverId;
  final int exceededWeight;
  double latitude;
  double longitude;
  int newDriverId;
  String orderComments;
  String signUrl;
  int statusId;
  final int waitingTime;
  int zoneId;
  UpdateOrder({
    required this.barcode,
    required this.cancelReason,
    required this.cancelReasonId,
    required this.collectAt,
    required this.deliveredAt,
    required this.distance,
    required this.driverComments,
    required this.driverId,
    required this.exceededWeight,
    required this.latitude,
    required this.longitude,
    required this.newDriverId,
    required this.orderComments,
    required this.signUrl,
    required this.statusId,
    required this.waitingTime,
    required this.zoneId,
  });

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'cancelReason': cancelReason,
      'cancelReasonId': cancelReasonId,
      'collectAt': collectAt,
      'deliveredAt': deliveredAt,
      'distance': distance,
      'driverComments': driverComments,
      'driverId': driverId,
      'exceededWeight': exceededWeight,
      'latitude': latitude,
      'longitude': longitude,
      'newDriverId': newDriverId,
      'orderComments': orderComments,
      'signUrl': signUrl,
      'statusId': statusId,
      'waitingTime': waitingTime,
      'zoneId': zoneId,
    };
  }

  factory UpdateOrder.fromMap(Map<String, dynamic> map) {
    return UpdateOrder(
      barcode: map['barcode'] ?? '',
      cancelReason: map['cancelReason'] ?? '',
      cancelReasonId: map['cancelReasonId']?.toInt() ?? 0,
      collectAt: map['collectAt'] ?? '',
      deliveredAt: map['deliveredAt'] ?? '',
      distance: map['distance'] ?? 0,
      driverComments: map['driverComments'] ?? '',
      driverId: map['driverId']?.toInt() ?? 0,
      exceededWeight: map['exceededWeight']?.toInt() ?? 0,
      latitude: map['latitude'] ?? 0,
      longitude: map['longitude'] ?? 0,
      newDriverId: map['newDriverId']?.toInt() ?? 0,
      orderComments: map['orderComments'] ?? '',
      signUrl: map['signUrl'] ?? '',
      statusId: map['statusId']?.toInt() ?? 0,
      waitingTime: map['waitingTime']?.toInt() ?? 0,
      zoneId: map['zoneId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateOrder.fromJson(String source) => UpdateOrder.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateOrder(barcode: $barcode, cancelReason: $cancelReason, cancelReasonId: $cancelReasonId, collectAt: $collectAt, deliveredAt: $deliveredAt, distance: $distance, driverComments: $driverComments, driverId: $driverId, exceededWeight: $exceededWeight, latitude: $latitude, longitude: $longitude, newDriverId: $newDriverId, orderComments: $orderComments, signUrl: $signUrl, statusId: $statusId, waitingTime: $waitingTime, zoneId: $zoneId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateOrder &&
        other.barcode == barcode &&
        other.cancelReason == cancelReason &&
        other.cancelReasonId == cancelReasonId &&
        other.collectAt == collectAt &&
        other.deliveredAt == deliveredAt &&
        other.distance == distance &&
        other.driverComments == driverComments &&
        other.driverId == driverId &&
        other.exceededWeight == exceededWeight &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.newDriverId == newDriverId &&
        other.orderComments == orderComments &&
        other.signUrl == signUrl &&
        other.statusId == statusId &&
        other.waitingTime == waitingTime &&
        other.zoneId == zoneId;
  }

  @override
  int get hashCode {
    return barcode.hashCode ^
        cancelReason.hashCode ^
        cancelReasonId.hashCode ^
        collectAt.hashCode ^
        deliveredAt.hashCode ^
        distance.hashCode ^
        driverComments.hashCode ^
        driverId.hashCode ^
        exceededWeight.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        newDriverId.hashCode ^
        orderComments.hashCode ^
        signUrl.hashCode ^
        statusId.hashCode ^
        waitingTime.hashCode ^
        zoneId.hashCode;
  }
}

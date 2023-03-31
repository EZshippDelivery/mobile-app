import 'dart:convert';

class Profile {
  final String? aadhaarNumber;
  final bool active;
  final int bikerId;
  final String deviceToken;
  final String email;
  final int lastOrderAmount;
  final String? licenseNumber;
  final String? licenseUrl;
  final String name;
  final String? numberPlate;
  final int phone;
  final String? profileUrl;
  final String? shift;
  final int todayEarnings;
  final int totalOrdersDelivered;
  Profile({
    required this.aadhaarNumber,
    required this.active,
    required this.bikerId,
    required this.deviceToken,
    required this.email,
    required this.lastOrderAmount,
    required this.licenseNumber,
    required this.licenseUrl,
    required this.name,
    required this.numberPlate,
    required this.phone,
    required this.profileUrl,
    required this.shift,
    required this.todayEarnings,
    required this.totalOrdersDelivered,
  });

  Map<String, dynamic> toMap() {
    return {
      'aadhaarNumber': aadhaarNumber,
      'active': active,
      'bikerId': bikerId,
      'deviceToken': deviceToken,
      'email': email,
      'lastOrderAmount': lastOrderAmount,
      'licenseNumber': licenseNumber,
      'licenseUrl': licenseUrl,
      'name': name,
      'numberPlate': numberPlate,
      'phone': phone,
      'profileUrl': profileUrl,
      'shift': shift,
      'todayEarnings': todayEarnings,
      'totalOrdersDelivered': totalOrdersDelivered,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      aadhaarNumber: map['aadhaarNumber'] ?? '',
      active: map['active'] ?? false,
      bikerId: map['bikerId']?.toInt() ?? 0,
      deviceToken: map['deviceToken'] ?? '',
      email: map['email'] ?? '',
      lastOrderAmount: map['lastOrderAmount']?.toInt() ?? 0,
      licenseNumber: map['licenseNumber'] ?? '',
      licenseUrl: map['licenseUrl'] ?? '',
      name: map['name'] ?? '',
      numberPlate: map['numberPlate'] ?? '',
      phone: map['phone']?.toInt() ?? 0,
      profileUrl: map['profileUrl'] ?? '',
      shift: map['shift'] ?? '',
      todayEarnings: map['todayEarnings']?.toInt() ?? 0,
      totalOrdersDelivered: map['totalOrdersDelivered']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) => Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(aadhaarNumber: $aadhaarNumber, active: $active, bikerId: $bikerId, deviceToken: $deviceToken, email: $email, lastOrderAmount: $lastOrderAmount, licenseNumber: $licenseNumber, licenseUrl: $licenseUrl, name: $name, numberPlate: $numberPlate, phone: $phone, profileUrl: $profileUrl, shift: $shift, todayEarnings: $todayEarnings, totalOrdersDelivered: $totalOrdersDelivered)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile &&
        other.aadhaarNumber == aadhaarNumber &&
        other.active == active &&
        other.bikerId == bikerId &&
        other.deviceToken == deviceToken &&
        other.email == email &&
        other.lastOrderAmount == lastOrderAmount &&
        other.licenseNumber == licenseNumber &&
        other.licenseUrl == licenseUrl &&
        other.name == name &&
        other.numberPlate == numberPlate &&
        other.phone == phone &&
        other.profileUrl == profileUrl &&
        other.shift == shift &&
        other.todayEarnings == todayEarnings &&
        other.totalOrdersDelivered == totalOrdersDelivered;
  }

  @override
  int get hashCode {
    return aadhaarNumber.hashCode ^
        active.hashCode ^
        bikerId.hashCode ^
        deviceToken.hashCode ^
        email.hashCode ^
        lastOrderAmount.hashCode ^
        licenseNumber.hashCode ^
        licenseUrl.hashCode ^
        name.hashCode ^
        numberPlate.hashCode ^
        phone.hashCode ^
        profileUrl.hashCode ^
        shift.hashCode ^
        todayEarnings.hashCode ^
        totalOrdersDelivered.hashCode;
  }
}

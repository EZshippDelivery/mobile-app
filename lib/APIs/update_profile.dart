import 'dart:convert';

class UpdateProfile {
  final String aadhaarNumber;
  final String aadhaarUrl;
  final bool active;
  final String deviceToken;
  final String email;
  final String firstName;
  final String imageUrl;
  final String lastName;
  final String license;
  final String licenseUrl;
  final int phoneNumber;
  final int shiftId;
  final String vehicleRegn;
  UpdateProfile({
    required this.aadhaarNumber,
    required this.aadhaarUrl,
    required this.active,
    required this.deviceToken,
    required this.email,
    required this.firstName,
    required this.imageUrl,
    required this.lastName,
    required this.license,
    required this.licenseUrl,
    required this.phoneNumber,
    required this.shiftId,
    required this.vehicleRegn,
  });

  Map<String, dynamic> toMap() {
    return {
      'aadhaarNumber': aadhaarNumber,
      'aadhaarUrl': aadhaarUrl,
      'active': active,
      'deviceToken': deviceToken,
      'email': email,
      'firstName': firstName,
      'imageUrl': imageUrl,
      'lastName': lastName,
      'license': license,
      'licenseUrl': licenseUrl,
      'phoneNumber': phoneNumber,
      'shiftId': shiftId,
      'vehicleRegn': vehicleRegn,
    };
  }

  factory UpdateProfile.fromMap(Map<String, dynamic> map) {
    return UpdateProfile(
      aadhaarNumber: map['aadhaarNumber'] ?? '',
      aadhaarUrl: map['aadhaarUrl'] ?? '',
      active: map['active'] ?? false,
      deviceToken: map['deviceToken'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      lastName: map['lastName'] ?? '',
      license: map['license'] ?? '',
      licenseUrl: map['licenseUrl'] ?? '',
      phoneNumber: map['phoneNumber']?.toInt() ?? 0,
      shiftId: map['shiftId']?.toInt() ?? 0,
      vehicleRegn: map['vehicleRegn'] ?? '',
    );
  }

  factory UpdateProfile.fromMap1(Map<String, dynamic> previous, Map<String, dynamic> update) {
    int shiftId = 0;
    if (previous["shift"].contains(RegExp("^[mM]"))) {
      shiftId = 2;
    } else if (previous["shift"].contains(RegExp("^[aA]"))) {
      shiftId = 3;
    } else if (previous["shift"].contains(RegExp("^[nN]"))) {
      shiftId = 4;
    }
    return UpdateProfile(
      aadhaarNumber: previous['aadhaarNumber'] ?? '',
      aadhaarUrl: previous['aadhaarUrl'] ?? '',
      active: previous['active'] ?? false,
      deviceToken: previous['deviceToken'] ?? '',
      email: update['Email id'] ?? '',
      firstName: update['First Name'] ?? '',
      imageUrl: previous['imageUrl'] ?? '',
      lastName: update['Last Name'] ?? '',
      license: previous['licenseNumber'] ?? '',
      licenseUrl: previous['licenseUrl'] ?? '',
      phoneNumber: update['Phone Number']?.toInt() ?? 0,
      shiftId: shiftId,
      vehicleRegn: previous['numberPlate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateProfile.fromJson(String source) => UpdateProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateProfile(aadhaarNumber: $aadhaarNumber, aadhaarUrl: $aadhaarUrl, active: $active, deviceToken: $deviceToken, email: $email, firstName: $firstName, imageUrl: $imageUrl, lastName: $lastName, license: $license, licenseUrl: $licenseUrl, phoneNumber: $phoneNumber, shiftId: $shiftId, vehicleRegn: $vehicleRegn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateProfile &&
        other.aadhaarNumber == aadhaarNumber &&
        other.aadhaarUrl == aadhaarUrl &&
        other.active == active &&
        other.deviceToken == deviceToken &&
        other.email == email &&
        other.firstName == firstName &&
        other.imageUrl == imageUrl &&
        other.lastName == lastName &&
        other.license == license &&
        other.licenseUrl == licenseUrl &&
        other.phoneNumber == phoneNumber &&
        other.shiftId == shiftId &&
        other.vehicleRegn == vehicleRegn;
  }

  @override
  int get hashCode {
    return aadhaarNumber.hashCode ^
        aadhaarUrl.hashCode ^
        active.hashCode ^
        deviceToken.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        imageUrl.hashCode ^
        lastName.hashCode ^
        license.hashCode ^
        licenseUrl.hashCode ^
        phoneNumber.hashCode ^
        shiftId.hashCode ^
        vehicleRegn.hashCode;
  }
}

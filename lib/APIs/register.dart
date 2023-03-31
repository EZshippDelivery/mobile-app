import 'dart:convert';

class Register {
  final String deviceId;
  final String deviceMake;
  final String deviceModel;
  final String deviceToken;
  final String deviceType;
  final String email;
  final String firstName;
  final String lastName;
  final String os;
  final String password;
  final String phone;
  final String userType;
  final bool webSignUp = false;
  Register({
    required this.deviceId,
    required this.deviceMake,
    required this.deviceModel,
    required this.deviceToken,
    required this.deviceType,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.os,
    required this.password,
    required this.phone,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'deviceMake': deviceMake,
      'deviceModel': deviceModel,
      'deviceToken': deviceToken,
      'deviceType': deviceType,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'os': os,
      'password': password,
      'phone': phone,
      'userType': userType,
      'webSignUp': webSignUp,
    };
  }

  factory Register.fromMap(Map<String, dynamic> map) {
    return Register(
      deviceId: map['deviceId'] ?? '',
      deviceMake: map['deviceMake'] ?? '',
      deviceModel: map['deviceModel'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      deviceType: map['deviceType'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      os: map['os'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      userType: map['userType'] ?? '',
    );
  }
  factory Register.from2Maps(Map<String, dynamic> deviceInfo, Map<String, dynamic> userDetails) {
    return Register(
      deviceId: deviceInfo['deviceId'] ?? '',
      deviceMake: deviceInfo['deviceMake'] ?? '',
      deviceModel: deviceInfo['deviceModel'] ?? '',
      deviceToken: deviceInfo['deviceToken'] ?? '',
      deviceType: deviceInfo['deviceType'] ?? '',
      email: userDetails['Email id'] ?? '',
      firstName: userDetails['First Name'] ?? '',
      lastName: userDetails['Last Name'] ?? '',
      os: deviceInfo['OS'] ?? '',
      password: userDetails['Password'] ?? '',
      phone: userDetails['Phone number'] ?? '',
      userType: deviceInfo['userType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Register.fromJson(String source) => Register.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Register(deviceId: $deviceId, deviceMake: $deviceMake, deviceModel: $deviceModel, deviceToken: $deviceToken, deviceType: $deviceType, email: $email, firstName: $firstName, lastName: $lastName, os: $os, password: $password, phone: $phone, userType: $userType, webSignUp: $webSignUp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Register &&
      other.deviceId == deviceId &&
      other.deviceMake == deviceMake &&
      other.deviceModel == deviceModel &&
      other.deviceToken == deviceToken &&
      other.deviceType == deviceType &&
      other.email == email &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.os == os &&
      other.password == password &&
      other.phone == phone &&
      other.userType == userType &&
      other.webSignUp == webSignUp;
  }

  @override
  int get hashCode {
    return deviceId.hashCode ^
      deviceMake.hashCode ^
      deviceModel.hashCode ^
      deviceToken.hashCode ^
      deviceType.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      os.hashCode ^
      password.hashCode ^
      phone.hashCode ^
      userType.hashCode ^
      webSignUp.hashCode;
  }
}
import 'dart:convert';

class UpdateCustomerProfile {
  final int customerId;
  final String deviceToken;
  final String email;
  final String firstName;
  final String lastName;
  final bool receiveEmail;
  final bool receivePush;
  final bool receiveSMS;
  UpdateCustomerProfile({
    required this.customerId,
    required this.deviceToken,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.receiveEmail,
    required this.receivePush,
    required this.receiveSMS,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'deviceToken': deviceToken,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'receiveEmail': receiveEmail,
      'receivePush': receivePush,
      'receiveSMS': receiveSMS,
    };
  }

  factory UpdateCustomerProfile.fromMap(Map<String, dynamic> map) {
    return UpdateCustomerProfile(
      customerId: map['customerId']?.toInt() ?? 0,
      deviceToken: map['deviceToken'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      receiveEmail: map['receiveEmail'] ?? false,
      receivePush: map['receivePush'] ?? false,
      receiveSMS: map['receiveSMS'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateCustomerProfile.fromJson(String source) => UpdateCustomerProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateCustomerProfile(customerId: $customerId, deviceToken: $deviceToken, email: $email, firstName: $firstName, lastName: $lastName, receiveEmail: $receiveEmail, receivePush: $receivePush, receiveSMS: $receiveSMS)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UpdateCustomerProfile &&
      other.customerId == customerId &&
      other.deviceToken == deviceToken &&
      other.email == email &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.receiveEmail == receiveEmail &&
      other.receivePush == receivePush &&
      other.receiveSMS == receiveSMS;
  }

  @override
  int get hashCode {
    return customerId.hashCode ^
      deviceToken.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      receiveEmail.hashCode ^
      receivePush.hashCode ^
      receiveSMS.hashCode;
  }
}
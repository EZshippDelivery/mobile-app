import 'dart:convert';

class CustomerDetails {
  final int customerId;
  final String email;
  final String firstName;
  final String lastName;
  final String name;
  final int phone;
  final bool premium;
  final String profileUrl;
  final bool receiveEmail;
  final bool receivePush;
  final bool receiveSMS;
  final String referralCode;
  final String userType;
  final String username;
  CustomerDetails({
    required this.customerId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.phone,
    required this.premium,
    required this.profileUrl,
    required this.receiveEmail,
    required this.receivePush,
    required this.receiveSMS,
    required this.referralCode,
    required this.userType,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'phone': phone,
      'premium': premium,
      'profileUrl': profileUrl,
      'receiveEmail': receiveEmail,
      'receivePush': receivePush,
      'receiveSMS': receiveSMS,
      'referralCode': referralCode,
      'userType': userType,
      'username': username,
    };
  }

  factory CustomerDetails.fromMap(Map<String, dynamic> map) {
    return CustomerDetails(
      customerId: map['customerId']?.toInt() ?? 0,
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone']?.toInt() ?? 0,
      premium: map['premium'] ?? false,
      profileUrl: map['profileUrl'] ?? '',
      receiveEmail: map['receiveEmail'] ?? false,
      receivePush: map['receivePush'] ?? false,
      receiveSMS: map['receiveSMS'] ?? false,
      referralCode: map['referralCode'] ?? '',
      userType: map['userType'] ?? '',
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerDetails.fromJson(String source) => CustomerDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CustomerDetails(customerId: $customerId, email: $email, firstName: $firstName, lastName: $lastName, name: $name, phone: $phone, premium: $premium, profileUrl: $profileUrl, receiveEmail: $receiveEmail, receivePush: $receivePush, receiveSMS: $receiveSMS, referralCode: $referralCode, userType: $userType, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CustomerDetails &&
      other.customerId == customerId &&
      other.email == email &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.name == name &&
      other.phone == phone &&
      other.premium == premium &&
      other.profileUrl == profileUrl &&
      other.receiveEmail == receiveEmail &&
      other.receivePush == receivePush &&
      other.receiveSMS == receiveSMS &&
      other.referralCode == referralCode &&
      other.userType == userType &&
      other.username == username;
  }

  @override
  int get hashCode {
    return customerId.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      premium.hashCode ^
      profileUrl.hashCode ^
      receiveEmail.hashCode ^
      receivePush.hashCode ^
      receiveSMS.hashCode ^
      referralCode.hashCode ^
      userType.hashCode ^
      username.hashCode;
  }
}
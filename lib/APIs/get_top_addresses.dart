import 'dart:convert';

class GetAllAddresses {
  final int addressId;
  final int customerId;
  final String address1;
  final String address2;
  final int pincode;
  final String state;
  final String addressType;
  final double longitude;
  final double latitude;
  final String apartment;
  final String landmark;
  final String city;
  GetAllAddresses({
    required this.addressId,
    required this.customerId,
    required this.address1,
    required this.address2,
    required this.pincode,
    required this.state,
    required this.addressType,
    required this.longitude,
    required this.latitude,
    required this.apartment,
    required this.landmark,
    required this.city,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressId': addressId,
      'customerId': customerId,
      'address1': address1,
      'address2': address2,
      'pincode': pincode,
      'state': state,
      'addressType': addressType,
      'longitude': longitude,
      'latitude': latitude,
      'apartment': apartment,
      'landmark': landmark,
      'city': city,
    };
  }

  factory GetAllAddresses.fromMap(Map<String, dynamic> map) {
    return GetAllAddresses(
      addressId: map['addressId']?.toInt() ?? 0,
      customerId: map['customerId']?.toInt() ?? 0,
      address1: map['address1'] ?? '',
      address2: map['address2']??"",
      pincode: map['pincode']?.toInt() ?? 0,
      state: map['state'] ?? '',
      addressType: map['addressType'] ?? '',
      longitude: map['longitude']?.toDouble() ?? 0.0,
      latitude: map['latitude']?.toDouble() ?? 0.0,
      apartment: map['apartment'] ?? '',
      landmark: map['landmark'] ?? '',
      city: map['city'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAllAddresses.fromJson(String source) => GetAllAddresses.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GetAllAddresses(addressId: $addressId, customerId: $customerId, address1: $address1, address2: $address2, pincode: $pincode, state: $state, addressType: $addressType, longitude: $longitude, latitude: $latitude, apartment: $apartment, landmark: $landmark, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetAllAddresses &&
        other.addressId == addressId &&
        other.customerId == customerId &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.pincode == pincode &&
        other.state == state &&
        other.addressType == addressType &&
        other.longitude == longitude &&
        other.latitude == latitude &&
        other.apartment == apartment &&
        other.landmark == landmark &&
        other.city == city;
  }

  @override
  int get hashCode {
    return addressId.hashCode ^
        customerId.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        pincode.hashCode ^
        state.hashCode ^
        addressType.hashCode ^
        longitude.hashCode ^
        latitude.hashCode ^
        apartment.hashCode ^
        landmark.hashCode ^
        city.hashCode;
  }
}




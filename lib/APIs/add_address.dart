import 'dart:convert';

class AddAddress {
  String address1;
  String address2;
  String apartment;
  String city;
  String complexName;
  int customerId;
  String landmark;
  double latitude;
  double longitude;
  int pincode;
  String stag;
  String state;
  String type;
  AddAddress({
    required this.address1,
    required this.address2,
    required this.apartment,
    required this.city,
    required this.complexName,
    required this.customerId,
    required this.landmark,
    required this.latitude,
    required this.longitude,
    required this.pincode,
    required this.stag,
    required this.state,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'address1': address1,
      'address2': address2,
      'apartment': apartment,
      'city': city,
      'complexName': complexName,
      'customerId': customerId,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'pincode': pincode,
      'stag': stag,
      'state': state,
      'type': type,
    };
  }

  factory AddAddress.fromMap(Map<String, dynamic> map) {
    return AddAddress(
      address1: map['address1'] ?? '',
      address2: map['address2'] ?? '',
      apartment: map['apartment'] ?? '',
      city: map['city'] ?? '',
      complexName: map['complexName'] ?? '',
      customerId: map['customerId']?.toInt() ?? 0,
      landmark: map['landmark'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      pincode: map['pincode']?.toInt() ?? 0,
      stag: map['stag'] ?? '',
      state: map['state'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AddAddress.fromJson(String source) => AddAddress.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddAddress(address1: $address1, address2: $address2, apartment: $apartment, city: $city, complexName: $complexName, customerId: $customerId, landmark: $landmark, latitude: $latitude, longitude: $longitude, pincode: $pincode, stag: $stag, state: $state, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AddAddress &&
      other.address1 == address1 &&
      other.address2 == address2 &&
      other.apartment == apartment &&
      other.city == city &&
      other.complexName == complexName &&
      other.customerId == customerId &&
      other.landmark == landmark &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.pincode == pincode &&
      other.stag == stag &&
      other.state == state &&
      other.type == type;
  }

  @override
  int get hashCode {
    return address1.hashCode ^
      address2.hashCode ^
      apartment.hashCode ^
      city.hashCode ^
      complexName.hashCode ^
      customerId.hashCode ^
      landmark.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      pincode.hashCode ^
      stag.hashCode ^
      state.hashCode ^
      type.hashCode;
  }
}
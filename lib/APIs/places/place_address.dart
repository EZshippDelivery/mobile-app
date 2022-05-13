import 'dart:convert';

import 'package:flutter/foundation.dart';

class PlaceAddress {
  final List<Result> results;
  PlaceAddress({
    required this.results,
  });

  Map<String, dynamic> toMap() {
    return {
      'results': results.map((x) => x.toMap()).toList(),
    };
  }

  factory PlaceAddress.fromMap(Map<String, dynamic> map) {
    return PlaceAddress(
      results: List<Result>.from(map['results']?.map((x) => Result.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceAddress.fromJson(String source) => PlaceAddress.fromMap(json.decode(source));

  @override
  String toString() => 'PlaceAddress(results: $results)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PlaceAddress &&
      listEquals(other.results, results);
  }

  @override
  int get hashCode => results.hashCode;
}

class Result {
  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  Result({
    required this.addressComponents,
    required this.formattedAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'address_components': addressComponents.map((x) => x.toMap()).toList(),
      'formatted_address': formattedAddress,
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      addressComponents: List<AddressComponent>.from(map['address_components']?.map((x) => AddressComponent.fromMap(x))),
      formattedAddress: map['formatted_address'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Result.fromJson(String source) => Result.fromMap(json.decode(source));

  @override
  String toString() => 'Result(address_components: $addressComponents, formatted_address: $formattedAddress)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Result &&
      listEquals(other.addressComponents, addressComponents) &&
      other.formattedAddress == formattedAddress;
  }

  @override
  int get hashCode => addressComponents.hashCode ^ formattedAddress.hashCode;
}

class AddressComponent {
  final String longName;
  final String shortName;
  final List<String> types;
  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  Map<String, dynamic> toMap() {
    return {
      'long_name': longName,
      'short_name': shortName,
      'types': types,
    };
  }

  factory AddressComponent.fromMap(Map<String, dynamic> map) {
    return AddressComponent(
      longName: map['long_name'] ?? '',
      shortName: map['short_name'] ?? '',
      types: List<String>.from(map['types']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressComponent.fromJson(String source) => AddressComponent.fromMap(json.decode(source));

  @override
  String toString() => 'Address_component(long_name: $longName, short_name: $shortName, types: $types)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AddressComponent &&
      other.longName == longName &&
      other.shortName == shortName &&
      listEquals(other.types, types);
  }

  @override
  int get hashCode => longName.hashCode ^ shortName.hashCode ^ types.hashCode;
}
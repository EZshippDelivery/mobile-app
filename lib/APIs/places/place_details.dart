// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

class PlaceDetails {
  final Result result;
  PlaceDetails({
    required this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'result': result.toMap(),
    };
  }

  factory PlaceDetails.fromMap(Map<String, dynamic> map) {
    return PlaceDetails(
      result: Result.fromMap(map['result']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceDetails.fromJson(String source) => PlaceDetails.fromMap(json.decode(source));

  @override
  String toString() => 'PlaceDetails(result: $result)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PlaceDetails &&
      other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}

class Result {
  final List<Address_component> address_components;
  final Geometry geometry;
  final String icon;
  final String icon_background_color;
  Result({
    required this.address_components,
    required this.geometry,
    required this.icon,
    required this.icon_background_color,
  });

  Map<String, dynamic> toMap() {
    return {
      'address_components': address_components.map((x) => x.toMap()).toList(),
      'geometry': geometry.toMap(),
      'icon': icon,
      'icon_background_color': icon_background_color,
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      address_components: List<Address_component>.from(map['address_components']?.map((x) => Address_component.fromMap(x))),
      geometry: Geometry.fromMap(map['geometry']),
      icon: map['icon'] ?? '',
      icon_background_color: map['icon_background_color'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Result.fromJson(String source) => Result.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Result(address_components: $address_components, geometry: $geometry, icon: $icon, icon_background_color: $icon_background_color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Result &&
      listEquals(other.address_components, address_components) &&
      other.geometry == geometry &&
      other.icon == icon &&
      other.icon_background_color == icon_background_color;
  }

  @override
  int get hashCode {
    return address_components.hashCode ^
      geometry.hashCode ^
      icon.hashCode ^
      icon_background_color.hashCode;
  }
}

// ignore: camel_case_types
class Address_component {
  final String long_name;
  final String short_name;
  final List<String> types;
  Address_component({
    required this.long_name,
    required this.short_name,
    required this.types,
  });

  Map<String, dynamic> toMap() {
    return {
      'long_name': long_name,
      'short_name': short_name,
      'types': types,
    };
  }

  factory Address_component.fromMap(Map<String, dynamic> map) {
    return Address_component(
      long_name: map['long_name'] ?? '',
      short_name: map['short_name'] ?? '',
      types: List<String>.from(map['types']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Address_component.fromJson(String source) => Address_component.fromMap(json.decode(source));

  @override
  String toString() => 'Address_component(long_name: $long_name, short_name: $short_name, types: $types)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Address_component &&
      other.long_name == long_name &&
      other.short_name == short_name &&
      listEquals(other.types, types);
  }

  @override
  int get hashCode => long_name.hashCode ^ short_name.hashCode ^ types.hashCode;
}

class Geometry {
  final Location location;
  Geometry({
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location.toMap(),
    };
  }

  factory Geometry.fromMap(Map<String, dynamic> map) {
    return Geometry(
      location: Location.fromMap(map['location']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Geometry.fromJson(String source) => Geometry.fromMap(json.decode(source));

  @override
  String toString() => 'Geometry(location: $location)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Geometry &&
      other.location == location;
  }

  @override
  int get hashCode => location.hashCode;
}

class Location {
  final double lat;
  final double lng;
  Location({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source));

  @override
  String toString() => 'Location(lat: $lat, lng: $lng)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Location &&
      other.lat == lat &&
      other.lng == lng;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}
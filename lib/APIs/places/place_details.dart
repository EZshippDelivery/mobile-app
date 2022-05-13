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

  factory PlaceDetails.fromMap(Map<String, dynamic> map, {bool geocode = false}) {
    return PlaceDetails(
      result: Result.fromMap(geocode ? map['results'] : map['result']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceDetails.fromJson(String source) => PlaceDetails.fromMap(json.decode(source));

  @override
  String toString() => 'PlaceDetails(result: $result)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceDetails && other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}

class Result {
  final List<AddressComponent> addressComponents;
  final Geometry geometry;
  final String icon;
  final String iconBackgroundColor;
  Result({
    required this.addressComponents,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'address_components': addressComponents.map((x) => x.toMap()).toList(),
      'geometry': geometry.toMap(),
      'icon': icon,
      'icon_background_color': iconBackgroundColor,
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      addressComponents:
          List<AddressComponent>.from(map['address_components']?.map((x) => AddressComponent.fromMap(x))),
      geometry: Geometry.fromMap(map['geometry']),
      icon: map['icon'] ?? '',
      iconBackgroundColor: map['icon_background_color'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Result.fromJson(String source) => Result.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Result(address_components: $addressComponents, geometry: $geometry, icon: $icon, icon_background_color: $iconBackgroundColor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Result &&
        listEquals(other.addressComponents, addressComponents) &&
        other.geometry == geometry &&
        other.icon == icon &&
        other.iconBackgroundColor == iconBackgroundColor;
  }

  @override
  int get hashCode {
    return addressComponents.hashCode ^ geometry.hashCode ^ icon.hashCode ^ iconBackgroundColor.hashCode;
  }
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

    return other is Geometry && other.location == location;
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

    return other is Location && other.lat == lat && other.lng == lng;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}

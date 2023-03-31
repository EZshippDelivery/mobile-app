// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

class PlaceSearch {
  final String description;
  final String place_id;
  final List<Term> terms;
  PlaceSearch({
    required this.description,
    required this.place_id,
    required this.terms,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'place_id': place_id,
      'terms': terms.map((x) => x.toMap()).toList(),
    };
  }

  factory PlaceSearch.fromMap(Map<String, dynamic> map) {
    return PlaceSearch(
      description: map['description'] ?? '',
      place_id: map['place_id'] ?? '',
      terms: List<Term>.from(map['terms']?.map((x) => Term.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceSearch.fromJson(String source) => PlaceSearch.fromMap(json.decode(source));

  @override
  String toString() => 'PlaceSearch(description: $description, place_id: $place_id, terms: $terms)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PlaceSearch &&
      other.description == description &&
      other.place_id == place_id &&
      listEquals(other.terms, terms);
  }

  @override
  int get hashCode => description.hashCode ^ place_id.hashCode ^ terms.hashCode;
}

class Term {
  final int offset;
  final String value;
  Term({
    required this.offset,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'offset': offset,
      'value': value,
    };
  }

  factory Term.fromMap(Map<String, dynamic> map) {
    return Term(
      offset: map['offset']?.toInt() ?? 0,
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Term.fromJson(String source) => Term.fromMap(json.decode(source));

  @override
  String toString() => 'Term(offset: $offset, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Term &&
      other.offset == offset &&
      other.value == value;
  }

  @override
  int get hashCode => offset.hashCode ^ value.hashCode;
}
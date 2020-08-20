import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  final String name;
  final String url;

  /// pokemon palette color
  Color color = null;

  String get imageUrl {
    final split = url.split("/");
    final index = split[split.length - 2];
    return 'https://pokeres.bastionbot.org/images/pokemon/$index.png';
  }

  Pokemon({this.name, this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);
  Map<String, dynamic> toJson() => _$PokemonToJson(this);
}

@JsonSerializable()
class PokemonInfo {
  static const int maxHp = 300;
  static const int maxAttack = 300;
  static const int maxDefense = 300;
  static const int maxSpeed = 300;
  static const int maxExp = 1000;

  final int id;
  final String name;
  final int height;
  final int weight;
  @JsonKey(name: 'base_experience')
  final int experience;
  final List<TypeResponse> types;
  final int hp = Random().nextInt(maxHp);
  final int attack = Random().nextInt(maxAttack);
  final int defense = Random().nextInt(maxDefense);
  final int speed = Random().nextInt(maxSpeed);
  final int exp = Random().nextInt(maxExp);

  PokemonInfo(
      {this.id,
      this.name,
      this.height,
      this.weight,
      this.experience,
      this.types});

  factory PokemonInfo.fromJson(Map<String, dynamic> json) =>
      _$PokemonInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PokemonInfoToJson(this);

  String get idString => '#${NumberFormat('000').format(id)}';
  String get weightString => NumberFormat('0.0 KG').format(weight / 10);
  String get heightString => NumberFormat('0.0 M').format(height / 10);
  String get hpString => '$hp/$maxHp';
  String get attackString => '$attack/$maxAttack';
  String get defenseString => '$defense/$maxDefense';
  String get speedString => '$speed/$maxSpeed';
  String get expString => '$exp/$maxExp';
}

@JsonSerializable()
class TypeResponse {
  final int slot;
  final Type type;

  TypeResponse({this.slot, this.type});

  factory TypeResponse.fromJson(Map<String, dynamic> json) =>
      _$TypeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TypeResponseToJson(this);
}

@JsonSerializable()
class Type {
  final String name;

  Type({this.name});

  factory Type.fromJson(Map<String, dynamic> json) => _$TypeFromJson(json);
  Map<String, dynamic> toJson() => _$TypeToJson(this);
}

@JsonSerializable()
class PokemonResponse {
  final int count;
  final String next;
  final String previous;
  final List<Pokemon> results;

  PokemonResponse({this.count, this.next, this.previous, this.results});

  factory PokemonResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PokemonResponseToJson(this);
}

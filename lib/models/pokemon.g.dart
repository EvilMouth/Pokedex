// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) {
  return Pokemon(
    name: json['name'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };

PokemonInfo _$PokemonInfoFromJson(Map<String, dynamic> json) {
  return PokemonInfo(
    id: json['id'] as int,
    name: json['name'] as String,
    height: json['height'] as int,
    weight: json['weight'] as int,
    experience: json['base_experience'] as int,
    types: (json['types'] as List)
        ?.map((e) =>
            e == null ? null : TypeResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PokemonInfoToJson(PokemonInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'height': instance.height,
      'weight': instance.weight,
      'base_experience': instance.experience,
      'types': instance.types,
    };

TypeResponse _$TypeResponseFromJson(Map<String, dynamic> json) {
  return TypeResponse(
    slot: json['slot'] as int,
    type: json['type'] == null
        ? null
        : Type.fromJson(json['type'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TypeResponseToJson(TypeResponse instance) =>
    <String, dynamic>{
      'slot': instance.slot,
      'type': instance.type,
    };

Type _$TypeFromJson(Map<String, dynamic> json) {
  return Type(
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$TypeToJson(Type instance) => <String, dynamic>{
      'name': instance.name,
    };

PokemonResponse _$PokemonResponseFromJson(Map<String, dynamic> json) {
  return PokemonResponse(
    count: json['count'] as int,
    next: json['next'] as String,
    previous: json['previous'] as String,
    results: (json['results'] as List)
        ?.map((e) =>
            e == null ? null : Pokemon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PokemonResponseToJson(PokemonResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

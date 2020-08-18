import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  final String name;
  final String url;

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

class PokemonInfo {}

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

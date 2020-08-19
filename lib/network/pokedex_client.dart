import 'package:Pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class PokedexService {
  Future<List<Pokemon>> fetchPokemonList({int limit, int offset});
  Future<PokemonInfo> fetchPokemonInfo({String name});
}

class PokedexClient implements PokedexService {
  static PokedexClient instance = PokedexClient();

  Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://pokeapi.co/api/v2/',
  ))
    ..interceptors.add(LogInterceptor(
      responseBody: true,
    ));

  @override
  Future<List<Pokemon>> fetchPokemonList(
      {int limit = 20, int offset = 0}) async {
    final response = await _dio.get(
      'pokemon',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );
    final data = response.data;
    final pokemonResponse = PokemonResponse.fromJson(data);
    return pokemonResponse.results;
  }

  @override
  Future<PokemonInfo> fetchPokemonInfo({@required String name}) async {
    final response = await _dio.get('pokemon/$name');
    final data = response.data;
    final pokemonInfo = PokemonInfo.fromJson(data);
    return pokemonInfo;
  }
}

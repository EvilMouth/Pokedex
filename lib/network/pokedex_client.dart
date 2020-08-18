import 'package:Pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class PokedexService {}

class PokedexClient implements PokedexService {
  static PokedexClient instance = PokedexClient();

  Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://pokeapi.co/api/v2/',
  ))
    ..interceptors.add(LogInterceptor(
      responseBody: true,
    ));

  Future<List<Pokemon>> fetchPokemonList(
      {int limit = 20, int offset = 0}) async {
    final response = await _dio.get('pokemon');
    final data = response.data;
    final pokemonResponse = PokemonResponse.fromJson(data);
    return pokemonResponse.results;
  }

  dynamic fetchPokemonInfo({@required String name}) async {
    final response = await _dio.get('pokemon/$name');
  }
}

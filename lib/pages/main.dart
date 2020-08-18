import 'package:Pokedex/constants/strings.dart';
import 'package:Pokedex/models/pokemon.dart';
import 'package:Pokedex/network/pokedex_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detail.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MyStrings.appName)),
      body: ChangeNotifierProvider(
        lazy: false,
        create: (context) => MainViewModel(),
        child: _MainBody(),
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          _buildPokemonList(context),
          Center(
            // show progress if loading
            child: context.select<MainViewModel, bool>(
                    (viewModel) => viewModel.loading)
                ? CircularProgressIndicator()
                : null,
          ),
        ],
      ),
    );
  }

  _buildPokemonList(BuildContext context) {
    final pokemonList = context.select<MainViewModel, List<Pokemon>>(
        (viewModel) => viewModel.pokemonList);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          // load more
          context.read<MainViewModel>().fetchPokemonListMore();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: pokemonList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 0.86,
        ),
        itemBuilder: (context, index) {
          return _buildPokemonItem(context, pokemonList[index]);
        },
      ),
    );
  }

  _buildPokemonItem(BuildContext context, Pokemon pokemon) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(pokemon: pokemon)));
      },
      child: Card(
        color: Colors.blue,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
              child: Hero(
                tag: 'pokemon_${pokemon.name}_imageUrl',
                child: Image.network(
                  pokemon.imageUrl,
                  width: 120.0,
                  height: 120.0,
                ),
              ),
            ),
            Hero(
              tag: 'pokemon_${pokemon.name}_name',
              child: Text(
                pokemon.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainViewModel with ChangeNotifier {
  static const int PAGE_SIZE = 20;

  bool _loading = false;
  bool get loading => _loading;
  int _page = 0;
  List<Pokemon> _pokemonList = [];
  List<Pokemon> get pokemonList => _pokemonList;

  MainViewModel() {
    _fetchPokemonList(page: _page = 0);
  }

  fetchPokemonListMore() {
    if (loading) return;
    _fetchPokemonList(page: ++_page);
  }

  _fetchPokemonList({int page = 0}) async {
    if (loading) return;
    markLoading(true);
    final pokemonList = await PokedexClient.instance.fetchPokemonList(
      limit: PAGE_SIZE,
      offset: page * PAGE_SIZE,
    );
    updatePokemonList(page, pokemonList);
    markLoading(false);
  }

  markLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  updatePokemonList(int page, List<Pokemon> pokemonList) {
    if (page == 0) {
      _pokemonList = pokemonList;
    } else {
      _pokemonList += pokemonList;
    }
    notifyListeners();
  }
}

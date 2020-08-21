import 'package:Pokedex/extensions/palette_image.dart';
import 'package:Pokedex/base/view_model.dart';
import 'package:Pokedex/constants/strings.dart';
import 'package:Pokedex/models/pokemon.dart';
import 'package:Pokedex/network/pokedex_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
          Visibility(
            // just observe loading state by using select
            visible: context
                .select<MainViewModel, bool>((viewModel) => viewModel.loading),
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  _buildPokemonList(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          context.read<MainViewModel>().fetchPokemonListMore();
        }
        return false;
      },
      child: Selector<MainViewModel, MainViewModel>(
        shouldRebuild: (previous, next) => false,
        selector: (context, viewModel) => viewModel,
        builder: (context, viewModel, child) =>
            Selector<MainViewModel, List<Pokemon>>(
          shouldRebuild: (previous, next) => false,
          selector: (context, viewModel) => viewModel.pokemonList,
          builder: (context, pokemonList, child) => GridView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: pokemonList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              childAspectRatio: 0.86,
            ),
            itemBuilder: (context, index) {
              return Selector<MainViewModel, Pokemon>(
                selector: (context, viewModel) => viewModel.pokemonList[index],
                builder: (context, pokemon, child) => _PokenmonItem(
                  key: ValueKey(pokemon),
                  viewModel: viewModel,
                  pokemon: pokemon,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PokenmonItem extends StatelessWidget {
  _PokenmonItem({Key key, @required this.viewModel, @required this.pokemon})
      : super(key: key);

  final MainViewModel viewModel;
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: pokemon.color ?? Colors.grey,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        splashColor: Colors.red,
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailPage(pokemon: pokemon)));
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
              child: Hero(
                tag: 'pokemon_${pokemon.name}_imageUrl',
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  width: 120.0,
                  height: 120.0,
                  imageBuilder: (context, image) => Image(
                    image: image,
                    width: 120.0,
                    height: 120.0,
                  )..listenIf(
                      check: (_) => pokemon.color == null,
                      callback: (color) =>
                          viewModel.updatePokemonColor(pokemon, color),
                    ),
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

class MainViewModel extends BaseViewModelWithLoadingState {
  static const int PAGE_SIZE = 20;

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

  updatePokemonList(int page, List<Pokemon> pokemonList) {
    if (page == 0) {
      _pokemonList = pokemonList;
    } else {
      _pokemonList += pokemonList;
    }
    notifyListeners();
  }

  updatePokemonColor(Pokemon pokemon, Color color) {
    final index = _pokemonList.indexOf(pokemon);
    if (index != -1) {
      _pokemonList[index] = Pokemon(
        name: pokemon.name,
        url: pokemon.url,
      )..color = color;
      notifyListeners();
    }
  }
}

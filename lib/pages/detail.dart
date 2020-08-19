import 'package:Pokedex/base/view_model.dart';
import 'package:Pokedex/constants/strings.dart';
import 'package:Pokedex/models/pokemon.dart';
import 'package:Pokedex/network/pokedex_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  DetailPage({Key key, @required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: ChangeNotifierProvider(
        lazy: false,
        create: (context) => DetailViewModel(pokemon),
        child: Builder(
          builder: (context) => Stack(
            children: [
              Column(
                children: [
                  _DetailPokemonHeader(),
                  SizedBox(height: 24.0),
                  _DetailPokemonInfo(),
                  SizedBox(height: 24.0),
                  _DetailPokemonStatus(),
                ],
              ),
              Center(
                // show progress if loading
                child: context.select<DetailViewModel, bool>(
                        (viewModel) => viewModel.loading)
                    ? CircularProgressIndicator()
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailPokemonHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailViewModel>(
      builder: (context, viewModel, _) => Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              // status bar height
              height: MediaQuery.of(context).padding.top,
            ),
            Row(
              // tool bar
              children: [
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  MyStrings.appName,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  viewModel.pokemonInfo?.idString ?? '',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16.0),
              ],
            ),
            Container(
              height: 210.0,
              padding: const EdgeInsets.all(10.0),
              child: Hero(
                tag: 'pokemon_${viewModel.pokemon.name}_imageUrl',
                child: Image.network(viewModel.pokemon.imageUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailPokemonInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailViewModel>(
      builder: (context, viewModel, _) => Container(
        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
        child: Column(
          children: [
            Hero(
              flightShuttleBuilder: (_, __, ___, ____, to) => DefaultTextStyle(
                style: DefaultTextStyle.of(to).style,
                child: to.widget,
              ),
              tag: 'pokemon_${viewModel.pokemon.name}_name',
              child: Text(
                viewModel.pokemon.name,
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        viewModel.pokemonInfo?.weightString ?? '',
                        style: const TextStyle(
                          fontSize: 21.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Weight',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        viewModel.pokemonInfo?.heightString ?? '',
                        style: const TextStyle(
                          fontSize: 21.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Height',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailPokemonStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailViewModel>(
      builder: (context, viewModel, _) => Container(
        child: Column(
          children: [
            Text(
              'Base Status',
              style: const TextStyle(
                fontSize: 21.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailViewModel extends BaseViewModelWithLoadingState {
  final Pokemon pokemon;
  PokemonInfo _pokemonInfo;
  PokemonInfo get pokemonInfo => _pokemonInfo;

  DetailViewModel(this.pokemon) {
    _fetchPokemonInfo(pokemon.name);
  }

  _fetchPokemonInfo(String name) async {
    markLoading(true);
    final pokemonInfo =
        await PokedexClient.instance.fetchPokemonInfo(name: name);
    _updatePokemonInfo(pokemonInfo);
    markLoading(false);
  }

  _updatePokemonInfo(PokemonInfo pokemonInfo) {
    _pokemonInfo = pokemonInfo;
    notifyListeners();
  }
}

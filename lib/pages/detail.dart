import 'package:Pokedex/extensions/palette_image.dart';
import 'package:Pokedex/base/view_model.dart';
import 'package:Pokedex/constants/strings.dart';
import 'package:Pokedex/main.dart';
import 'package:Pokedex/models/pokemon.dart';
import 'package:Pokedex/network/pokedex_client.dart';
import 'package:Pokedex/utils/pokemon_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                  SizedBox(height: 12.0),
                  _DetailPokemonInfo(),
                  SizedBox(height: 24.0),
                  _DetailPokemonStats(),
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
      builder: (context, viewModel, _) => Column(
        children: [
          Container(
            height: 285.0,
            decoration: BoxDecoration(
              color: viewModel.pokemon.color ?? Colors.grey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
            ),
            child: Stack(
              children: [
                Column(
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
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Hero(
                      tag: 'pokemon_${viewModel.pokemon.name}_imageUrl',
                      child: Image(
                        image: CachedNetworkImageProvider(
                            viewModel.pokemon.imageUrl),
                        width: 190.0,
                        height: 190.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 29.0),
          Hero(
            flightShuttleBuilder: (_, __, ___, ____, to) => DefaultTextStyle(
              style: DefaultTextStyle.of(to).style,
              softWrap: false,
              overflow: TextOverflow.visible,
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
        ],
      ),
    );
  }
}

class _DetailPokemonInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailViewModel>(
      builder: (context, viewModel, _) => viewModel.pokemonInfo == null
          ? Container()
          : Container(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: Column(
                children: [
                  Wrap(
                    spacing: 20.0,
                    runSpacing: 10.0,
                    children: viewModel.pokemonInfo.types
                            ?.map<Widget>(
                                (type) => _buildPokemonTypeCard(type.type.name))
                            ?.toList() ??
                        [],
                  ),
                  SizedBox(height: 35.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              viewModel.pokemonInfo.weightString,
                              style: const TextStyle(
                                fontSize: 21.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              MyStrings.weight,
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              viewModel.pokemonInfo.heightString,
                              style: const TextStyle(
                                fontSize: 21.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              MyStrings.height,
                              style: const TextStyle(
                                color: Colors.white54,
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

  _buildPokemonTypeCard(String type) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35.0, 5.0, 35.0, 5.0),
      decoration: BoxDecoration(
        color: PokemonTypeUtils.getTypeColor(type),
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DetailPokemonStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailViewModel>(
      builder: (context, viewModel, _) => viewModel.pokemonInfo == null
          ? Container()
          : Container(
              child: Column(
                children: [
                  Text(
                    'Base Stats',
                    style: const TextStyle(
                      fontSize: 21.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildPokemonStatsBar(
                    text: MyStrings.hp,
                    color: Colors.red,
                    progress: viewModel.pokemonInfo.hp / PokemonInfo.maxHp,
                  ),
                  SizedBox(height: 16.0),
                  _buildPokemonStatsBar(
                    text: MyStrings.atk,
                    color: Colors.yellow,
                    progress:
                        viewModel.pokemonInfo.attack / PokemonInfo.maxAttack,
                  ),
                  SizedBox(height: 16.0),
                  _buildPokemonStatsBar(
                    text: MyStrings.def,
                    color: Colors.blue,
                    progress:
                        viewModel.pokemonInfo.defense / PokemonInfo.maxDefense,
                  ),
                  SizedBox(height: 16.0),
                  _buildPokemonStatsBar(
                    text: MyStrings.spd,
                    color: Colors.blue[100],
                    progress:
                        viewModel.pokemonInfo.speed / PokemonInfo.maxSpeed,
                  ),
                  SizedBox(height: 16.0),
                  _buildPokemonStatsBar(
                    text: MyStrings.exp,
                    color: Colors.green,
                    progress:
                        viewModel.pokemonInfo.experience / PokemonInfo.maxExp,
                  ),
                ],
              ),
            ),
    );
  }

  // todo custom
  _buildPokemonStatsBar({String text, Color color, double progress}) {
    return Container(
      padding: const EdgeInsets.only(
        left: 32.0,
        right: 32.0,
      ),
      child: Row(
        children: [
          Container(
            width: 35.0, //fixme
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 32.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9.0),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 18.0,
                ),
              ),
            ),
          ),
        ],
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

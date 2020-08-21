import 'package:Pokedex/events/pokemon.dart';
import 'package:Pokedex/extensions/palette_image.dart';
import 'package:Pokedex/base/view_model.dart';
import 'package:Pokedex/constants/strings.dart';
import 'package:Pokedex/models/pokemon.dart';
import 'package:Pokedex/network/pokedex_client.dart';
import 'package:Pokedex/utils/bus.dart';
import 'package:Pokedex/utils/pokemon_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _DetailViewModel extends BaseViewModelWithLoadingState {
  final BuildContext context;

  Pokemon _pokemon;
  Pokemon get pokemon => _pokemon;
  PokemonInfo _pokemonInfo;
  PokemonInfo get pokemonInfo => _pokemonInfo;

  _DetailViewModel(this.context, this._pokemon) {
    _fetchPokemonInfo(pokemon.name);
  }

  _fetchPokemonInfo(String name) async {
    markLoading(true);
    PokedexClient.instance
        .fetchPokemonInfo(name: name)
        .then((pokemonInfo) => _updatePokemonInfo(pokemonInfo))
        .catchError(
          (err, stack) => Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(err.toString()),
            ),
          ),
        )
        .whenComplete(() => markLoading(false));
  }

  _updatePokemonInfo(PokemonInfo pokemonInfo) {
    _pokemonInfo = pokemonInfo;
    notifyListeners();
  }

  updatePokemonColor(Color color) {
    if (pokemon.color == color) return;
    _pokemon = Pokemon(
      name: pokemon.name,
      url: pokemon.url,
    )..color = color;
    notifyListeners();
    // notify main list
    bus.fire(PokemonColorEvent(pokemon));
  }
}

class DetailPage extends StatelessWidget {
  DetailPage({Key key, @required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: ChangeNotifierProvider(
          create: (context) => _DetailViewModel(context, pokemon),
          child: _DetailBody(),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Selector<_DetailViewModel, _DetailViewModel>(
          shouldRebuild: (previous, next) => false,
          selector: (context, viewModel) => viewModel,
          builder: (context, viewModel, child) =>
              Selector<_DetailViewModel, PokemonInfo>(
            selector: (context, viewModel) => viewModel.pokemonInfo,
            builder: (context, pokemonInfo, child) => Column(
              children: [
                Selector<_DetailViewModel, Pokemon>(
                  selector: (context, viewModel) => viewModel.pokemon,
                  builder: (context, pokemon, child) => _DetailPokemonHeader(
                    viewModel: viewModel,
                    pokemon: pokemon,
                    pokemonInfo: pokemonInfo,
                  ),
                ),
                SizedBox(height: 12.0),
                Visibility(
                  visible: pokemonInfo != null,
                  child: _DetailPokemonInfo(
                    pokemonInfo: pokemonInfo,
                  ),
                ),
                SizedBox(height: 24.0),
                Visibility(
                  visible: pokemonInfo != null,
                  child: _DetailPokemonStats(
                    pokemonInfo: pokemonInfo,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: context
              .select<_DetailViewModel, bool>((viewModel) => viewModel.loading),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class _DetailPokemonHeader extends StatelessWidget {
  _DetailPokemonHeader(
      {Key key,
      @required this.viewModel,
      @required this.pokemon,
      @required this.pokemonInfo})
      : super(key: key);

  final _DetailViewModel viewModel;
  final Pokemon pokemon;
  final PokemonInfo pokemonInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 285.0,
          decoration: BoxDecoration(
            color: pokemon.color ?? Colors.grey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
          ),
          child: Column(
            children: [
              // status bar height
              SizedBox(height: MediaQuery.of(context).padding.top),
              Expanded(
                child: Stack(
                  children: [
                    // tool bar
                    Row(
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
                          pokemonInfo?.idString ?? '',
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
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Hero(
                        tag: 'pokemon_${pokemon.name}_imageUrl',
                        child: CachedNetworkImage(
                          imageUrl: pokemon.imageUrl,
                          imageBuilder: (context, image) => Image(
                            image: image,
                            width: 190.0,
                            height: 190.0,
                          )..listenIf(
                              check: (_) => pokemon.color == Colors.grey,
                              callback: (color) =>
                                  viewModel.updatePokemonColor(color),
                            ),
                        ),
                      ),
                    ),
                  ],
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
          tag: 'pokemon_${pokemon.name}_name',
          child: Text(
            pokemon.name,
            style: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailPokemonInfo extends StatelessWidget {
  _DetailPokemonInfo({Key key, @required this.pokemonInfo}) : super(key: key);

  final PokemonInfo pokemonInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
      child: Column(
        children: [
          Wrap(
            spacing: 20.0,
            runSpacing: 10.0,
            children: pokemonInfo.types
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
                      pokemonInfo.weightString,
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
                      pokemonInfo.heightString,
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
  _DetailPokemonStats({Key key, @required this.pokemonInfo}) : super(key: key);

  final PokemonInfo pokemonInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            progress: pokemonInfo.hp / PokemonInfo.maxHp,
          ),
          SizedBox(height: 16.0),
          _buildPokemonStatsBar(
            text: MyStrings.atk,
            color: Colors.yellow,
            progress: pokemonInfo.attack / PokemonInfo.maxAttack,
          ),
          SizedBox(height: 16.0),
          _buildPokemonStatsBar(
            text: MyStrings.def,
            color: Colors.blue,
            progress: pokemonInfo.defense / PokemonInfo.maxDefense,
          ),
          SizedBox(height: 16.0),
          _buildPokemonStatsBar(
            text: MyStrings.spd,
            color: Colors.blue[100],
            progress: pokemonInfo.speed / PokemonInfo.maxSpeed,
          ),
          SizedBox(height: 16.0),
          _buildPokemonStatsBar(
            text: MyStrings.exp,
            color: Colors.green,
            progress: pokemonInfo.experience / PokemonInfo.maxExp,
          ),
        ],
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
            width: 35.0, //todo barrier
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

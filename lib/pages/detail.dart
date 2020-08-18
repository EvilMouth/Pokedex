import 'package:Pokedex/constants/strings.dart';
import 'package:Pokedex/models/pokemon.dart';
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
        create: (context) => DetailViewModel(),
        child: Column(
          children: [
            Container(
              // header
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
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 210.0,
                    padding: const EdgeInsets.all(10.0),
                    child: Hero(
                      tag: 'pokemon_${pokemon.name}_imageUrl',
                      child: Image.network(pokemon.imageUrl),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Hero(
              flightShuttleBuilder: (_, __, ___, ____, to) => DefaultTextStyle(
                style: DefaultTextStyle.of(to).style,
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
            )
          ],
        ),
      ),
    );
  }
}

class DetailViewModel with ChangeNotifier {}

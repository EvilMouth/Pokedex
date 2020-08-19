import 'package:flutter/material.dart';

class PokemonTypeUtils {
  static Color getTypeColor(String type) {
    switch (type) {
      case "fighting":
        return const Color(0xFF9F422A);
      case "flying":
        return const Color(0xFF90B1C5);
      case "poison":
        return const Color(0xFF642785);
      case "ground":
        return const Color(0xFFAD7235);
      case "rock":
        return const Color(0xFF4B190E);
      case "bug":
        return const Color(0xFF179A55);
      case "ghost":
        return const Color(0xFF363069);
      case "steel":
        return const Color(0xFF5C756D);
      case "fire":
        return const Color(0xFFB22328);
      case "water":
        return const Color(0xFF2648DC);
      case "grass":
        return const Color(0xFF007C42);
      case "electric":
        return const Color(0xFFE0E64B);
      case "psychic":
        return const Color(0xFFAC296B);
      case "ice":
        return const Color(0xFF7ECFF2);
      case "dragon":
        return const Color(0xFF378A94);
      case "fairy":
        return const Color(0xFF9E1A44);
      case "dark":
        return const Color(0xFF040706);
      default:
        return const Color(0xFFB1A5A5);
    }
  }
}

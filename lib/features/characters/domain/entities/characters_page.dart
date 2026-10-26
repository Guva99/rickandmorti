import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:equatable/equatable.dart';

final class CharactersPage extends Equatable {
  const CharactersPage({required this.characters, required this.hasNext});

  static const empty = CharactersPage(characters: [], hasNext: false);

  final List<Character> characters;
  final bool hasNext;

  @override
  List<Object?> get props => [characters, hasNext];
}

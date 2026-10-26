import 'package:equatable/equatable.dart';

enum CharacterStatus { alive, dead, unknown }

final class Character extends Equatable {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final CharacterStatus status;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final String imageUrl;

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    gender,
    origin,
    location,
    imageUrl,
  ];
}

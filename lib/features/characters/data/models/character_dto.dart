import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';

final class CharacterDto {
  const CharacterDto({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  factory CharacterDto.fromJson(Object? json) => switch (json) {
    {
      'id': final int id,
      'name': final String name,
      'status': final String status,
      'species': final String species,
      'gender': final String gender,
      'origin': {'name': final String origin},
      'location': {'name': final String location},
      'image': final String image,
    } =>
      CharacterDto(
        id: id,
        name: name,
        status: status,
        species: species,
        gender: gender,
        origin: origin,
        location: location,
        image: image,
      ),
    _ => throw FormatException('Unexpected character payload', json),
  };

  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final String image;

  Character toEntity() => Character(
    id: id,
    name: name,
    status: switch (status) {
      'Alive' => CharacterStatus.alive,
      'Dead' => CharacterStatus.dead,
      _ => CharacterStatus.unknown,
    },
    species: species,
    gender: gender,
    origin: origin,
    location: location,
    imageUrl: image,
  );
}

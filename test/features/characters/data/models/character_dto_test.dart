import 'package:clatch_rcikmorti/features/characters/data/models/character_dto.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  final results = fixture('characters_page.json')['results'] as List<Object?>;

  group('CharacterDto.fromJson', () {
    test('parses a character from a real API response', () {
      final dto = CharacterDto.fromJson(results.first);

      expect(
        dto.toEntity(),
        const Character(
          id: 1,
          name: 'Rick Sanchez',
          status: CharacterStatus.alive,
          species: 'Human',
          gender: 'Male',
          origin: 'Earth (C-137)',
          location: 'Citadel of Ricks',
          imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        ),
      );
    });

    test('maps every status the API returns', () {
      final statuses = [
        for (final json in results)
          CharacterDto.fromJson(json).toEntity().status,
      ];

      expect(statuses, [
        CharacterStatus.alive,
        CharacterStatus.unknown,
        CharacterStatus.dead,
      ]);
    });

    test('throws FormatException when a required field is missing', () {
      final json = {...results.first! as Map<String, dynamic>}..remove('name');

      expect(() => CharacterDto.fromJson(json), throwsFormatException);
    });

    test('throws FormatException when a field has the wrong type', () {
      final json = {...results.first! as Map<String, dynamic>, 'id': '1'};

      expect(() => CharacterDto.fromJson(json), throwsFormatException);
    });
  });
}

import 'package:clatch_rcikmorti/features/characters/data/models/character_dto.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/characters_page.dart';

final class PageDto {
  const PageDto({required this.results, required this.hasNext});

  factory PageDto.fromJson(Object? json) => switch (json) {
    {
      'info': {'next': final String? next},
      'results': final List<Object?> results,
    } =>
      PageDto(
        results: results.map(CharacterDto.fromJson).toList(),
        hasNext: next != null,
      ),
    _ => throw FormatException('Unexpected characters page payload', json),
  };

  final List<CharacterDto> results;
  final bool hasNext;

  CharactersPage toEntity() => CharactersPage(
    characters: [for (final dto in results) dto.toEntity()],
    hasNext: hasNext,
  );
}

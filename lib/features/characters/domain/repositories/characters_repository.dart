import 'package:clatch_rcikmorti/core/result/result.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/characters_page.dart';

abstract interface class CharactersRepository {
  Future<Result<CharactersPage>> getCharacters({
    required int page,
    String name = '',
  });
}

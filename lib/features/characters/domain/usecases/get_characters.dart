import 'package:clatch_rcikmorti/core/result/result.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/characters_page.dart';
import 'package:clatch_rcikmorti/features/characters/domain/repositories/characters_repository.dart';

class GetCharacters {
  const GetCharacters(this._repository);

  final CharactersRepository _repository;

  Future<Result<CharactersPage>> call({required int page, String name = ''}) =>
      _repository.getCharacters(page: page, name: name);
}

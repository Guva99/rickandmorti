import 'package:clatch_rcikmorti/core/error/failure.dart';
import 'package:clatch_rcikmorti/core/network/dio_failure.dart';
import 'package:clatch_rcikmorti/core/result/result.dart';
import 'package:clatch_rcikmorti/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/characters_page.dart';
import 'package:clatch_rcikmorti/features/characters/domain/repositories/characters_repository.dart';
import 'package:dio/dio.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  const CharactersRepositoryImpl(this._remote);

  final CharactersRemoteDataSource _remote;

  @override
  Future<Result<CharactersPage>> getCharacters({
    required int page,
    String name = '',
  }) async {
    try {
      final dto = await _remote.fetchCharacters(page: page, name: name);
      return Success(dto.toEntity());
    } on DioException catch (error) {
      // The API answers 404 instead of an empty list when nothing matches.
      if (error.response?.statusCode == 404) {
        return const Success(CharactersPage.empty);
      }
      return Failed(error.toFailure());
    } on FormatException {
      return const Failed(UnexpectedFailure());
    }
  }
}

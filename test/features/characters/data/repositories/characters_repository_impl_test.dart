import 'package:clatch_rcikmorti/core/error/failure.dart';
import 'package:clatch_rcikmorti/core/result/result.dart';
import 'package:clatch_rcikmorti/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:clatch_rcikmorti/features/characters/data/models/character_dto.dart';
import 'package:clatch_rcikmorti/features/characters/data/models/page_dto.dart';
import 'package:clatch_rcikmorti/features/characters/data/repositories/characters_repository_impl.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/characters_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemoteDataSource extends Mock
    implements CharactersRemoteDataSource {}

void main() {
  late CharactersRemoteDataSource remote;
  late CharactersRepositoryImpl repository;

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = CharactersRepositoryImpl(remote);
  });

  void stubFetch(Future<PageDto> Function() answer) => when(
    () => remote.fetchCharacters(
      page: any(named: 'page'),
      name: any(named: 'name'),
    ),
  ).thenAnswer((_) => answer());

  DioException badResponse(int statusCode) {
    final options = RequestOptions(path: '/character');
    return DioException.badResponse(
      statusCode: statusCode,
      requestOptions: options,
      response: Response(requestOptions: options, statusCode: statusCode),
    );
  }

  test('maps DTOs to domain entities', () async {
    stubFetch(
      () async => const PageDto(
        hasNext: true,
        results: [
          CharacterDto(
            id: 8,
            name: 'Adjudicator Rick',
            status: 'Dead',
            species: 'Human',
            gender: 'Male',
            origin: 'unknown',
            location: 'Citadel of Ricks',
            image: 'https://rickandmortyapi.com/api/character/avatar/8.jpeg',
          ),
        ],
      ),
    );

    final result = await repository.getCharacters(page: 2, name: 'rick');

    expect(
      result,
      const Success(
        CharactersPage(
          hasNext: true,
          characters: [
            Character(
              id: 8,
              name: 'Adjudicator Rick',
              status: CharacterStatus.dead,
              species: 'Human',
              gender: 'Male',
              origin: 'unknown',
              location: 'Citadel of Ricks',
              imageUrl:
                  'https://rickandmortyapi.com/api/character/avatar/8.jpeg',
            ),
          ],
        ),
      ),
    );
    verify(() => remote.fetchCharacters(page: 2, name: 'rick')).called(1);
  });

  test('treats 404 as an empty page', () async {
    stubFetch(() => throw badResponse(404));

    final result = await repository.getCharacters(page: 1, name: 'zzz');

    expect(result, const Success(CharactersPage.empty));
  });

  test('maps server errors to ServerFailure', () async {
    stubFetch(() => throw badResponse(500));

    final result = await repository.getCharacters(page: 1);

    expect(result, const Failed<CharactersPage>(ServerFailure(500)));
  });

  test('maps connection errors to NetworkFailure', () async {
    stubFetch(
      () => throw DioException.connectionError(
        requestOptions: RequestOptions(path: '/character'),
        reason: 'Connection refused',
      ),
    );

    final result = await repository.getCharacters(page: 1);

    expect(result, const Failed<CharactersPage>(NetworkFailure()));
  });

  test('maps timeouts to NetworkFailure', () async {
    stubFetch(
      () => throw DioException.receiveTimeout(
        timeout: const Duration(seconds: 15),
        requestOptions: RequestOptions(path: '/character'),
      ),
    );

    final result = await repository.getCharacters(page: 1);

    expect(result, const Failed<CharactersPage>(NetworkFailure()));
  });

  test('maps malformed payloads to UnexpectedFailure', () async {
    stubFetch(() => throw const FormatException());

    final result = await repository.getCharacters(page: 1);

    expect(result, const Failed<CharactersPage>(UnexpectedFailure()));
  });
}

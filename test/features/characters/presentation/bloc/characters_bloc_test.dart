import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:clatch_rcikmorti/core/error/failure.dart';
import 'package:clatch_rcikmorti/core/result/result.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/characters_page.dart';
import 'package:clatch_rcikmorti/features/characters/domain/usecases/get_characters.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetCharacters extends Mock implements GetCharacters {}

Character _character(int id) => Character(
  id: id,
  name: 'Character $id',
  status: CharacterStatus.alive,
  species: 'Human',
  gender: 'Male',
  origin: 'Earth (C-137)',
  location: 'Citadel of Ricks',
  imageUrl: 'https://rickandmortyapi.com/api/character/avatar/$id.jpeg',
);

void main() {
  late GetCharacters getCharacters;

  final firstPage = CharactersPage(
    characters: [_character(1), _character(2)],
    hasNext: true,
  );
  final lastPage = CharactersPage(characters: [_character(3)], hasNext: false);
  final rickPage = CharactersPage(characters: [_character(10)], hasNext: false);
  final mortyPage = CharactersPage(
    characters: [_character(20)],
    hasNext: false,
  );

  final loaded = CharactersState(
    status: CharactersStatus.success,
    items: firstPage.characters,
    nextPage: 2,
  );
  const afterDebounce = Duration(milliseconds: 450);

  setUp(() => getCharacters = _MockGetCharacters());

  void stub(
    Result<CharactersPage> result, {
    required int page,
    String name = '',
  }) => when(
    () => getCharacters(page: page, name: name),
  ).thenAnswer((_) async => result);

  CharactersBloc build() => CharactersBloc(getCharacters);

  test('starts in the initial state', () {
    expect(build().state, const CharactersState());
  });

  group('first page', () {
    blocTest<CharactersBloc, CharactersState>(
      'loads characters on start',
      setUp: () => stub(Success(firstPage), page: 1),
      build: build,
      act: (bloc) => bloc.add(const CharactersStarted()),
      expect: () => [
        const CharactersState(status: CharactersStatus.loading),
        loaded,
      ],
    );

    blocTest<CharactersBloc, CharactersState>(
      'emits failure when the first page fails',
      setUp: () => stub(const Failed(NetworkFailure()), page: 1),
      build: build,
      act: (bloc) => bloc.add(const CharactersStarted()),
      expect: () => [
        const CharactersState(status: CharactersStatus.loading),
        const CharactersState(
          status: CharactersStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
    );

    blocTest<CharactersBloc, CharactersState>(
      'retries the first page after a failure',
      setUp: () => stub(Success(firstPage), page: 1),
      build: build,
      seed: () => const CharactersState(
        status: CharactersStatus.failure,
        failure: NetworkFailure(),
      ),
      act: (bloc) => bloc.add(const CharactersRetried()),
      expect: () => [
        const CharactersState(status: CharactersStatus.loading),
        loaded,
      ],
    );
  });

  group('pagination', () {
    blocTest<CharactersBloc, CharactersState>(
      'appends the next page',
      setUp: () => stub(Success(lastPage), page: 2),
      build: build,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CharactersNextPageRequested()),
      expect: () => [
        loaded.copyWith(isLoadingMore: true),
        loaded.copyWith(
          items: [...firstPage.characters, ...lastPage.characters],
          nextPage: 3,
          hasReachedEnd: true,
        ),
      ],
    );

    blocTest<CharactersBloc, CharactersState>(
      'ignores the request when the end is reached',
      build: build,
      seed: () => loaded.copyWith(hasReachedEnd: true),
      act: (bloc) => bloc.add(const CharactersNextPageRequested()),
      expect: () => <CharactersState>[],
      verify: (_) => verifyZeroInteractions(getCharacters),
    );

    blocTest<CharactersBloc, CharactersState>(
      'ignores the request while a page is loading',
      build: build,
      seed: () => loaded.copyWith(isLoadingMore: true),
      act: (bloc) => bloc.add(const CharactersNextPageRequested()),
      expect: () => <CharactersState>[],
      verify: (_) => verifyZeroInteractions(getCharacters),
    );

    blocTest<CharactersBloc, CharactersState>(
      'keeps loaded items when the next page fails',
      setUp: () => stub(const Failed(ServerFailure(500)), page: 2),
      build: build,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CharactersNextPageRequested()),
      expect: () => [
        loaded.copyWith(isLoadingMore: true),
        loaded.copyWith(loadMoreFailure: const ServerFailure(500)),
      ],
    );

    blocTest<CharactersBloc, CharactersState>(
      'does not retry a failed page on scroll',
      build: build,
      seed: () => loaded.copyWith(loadMoreFailure: const NetworkFailure()),
      act: (bloc) => bloc.add(const CharactersNextPageRequested()),
      expect: () => <CharactersState>[],
      verify: (_) => verifyZeroInteractions(getCharacters),
    );

    blocTest<CharactersBloc, CharactersState>(
      'retries the failed next page',
      setUp: () => stub(Success(lastPage), page: 2),
      build: build,
      seed: () => loaded.copyWith(loadMoreFailure: const NetworkFailure()),
      act: (bloc) => bloc.add(const CharactersRetried()),
      expect: () => [
        loaded.copyWith(isLoadingMore: true),
        loaded.copyWith(
          items: [...firstPage.characters, ...lastPage.characters],
          nextPage: 3,
          hasReachedEnd: true,
        ),
      ],
    );
  });

  group('search', () {
    blocTest<CharactersBloc, CharactersState>(
      'debounces input and searches only for the final query',
      setUp: () => stub(Success(rickPage), page: 1, name: 'rick'),
      build: build,
      seed: () => loaded,
      act: (bloc) => bloc
        ..add(const CharactersQueryChanged('r'))
        ..add(const CharactersQueryChanged('ri'))
        ..add(const CharactersQueryChanged('rick ')),
      wait: afterDebounce,
      expect: () => [
        const CharactersState(status: CharactersStatus.loading, query: 'rick'),
        CharactersState(
          status: CharactersStatus.success,
          items: rickPage.characters,
          query: 'rick',
          nextPage: 2,
          hasReachedEnd: true,
        ),
      ],
      verify: (_) {
        verify(() => getCharacters(page: 1, name: 'rick')).called(1);
        verifyNoMoreInteractions(getCharacters);
      },
    );

    blocTest<CharactersBloc, CharactersState>(
      'shows an empty result when nothing matches',
      setUp: () =>
          stub(const Success(CharactersPage.empty), page: 1, name: 'x'),
      build: build,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CharactersQueryChanged('x')),
      wait: afterDebounce,
      expect: () => [
        const CharactersState(status: CharactersStatus.loading, query: 'x'),
        const CharactersState(
          status: CharactersStatus.success,
          query: 'x',
          nextPage: 2,
          hasReachedEnd: true,
        ),
      ],
    );

    blocTest<CharactersBloc, CharactersState>(
      'skips a query that is already loaded',
      build: build,
      seed: () => loaded,
      act: (bloc) => bloc.add(const CharactersQueryChanged('  ')),
      wait: afterDebounce,
      expect: () => <CharactersState>[],
      verify: (_) => verifyZeroInteractions(getCharacters),
    );

    final rickResponse = Completer<Result<CharactersPage>>();
    blocTest<CharactersBloc, CharactersState>(
      'ignores a response to an outdated query',
      setUp: () {
        when(
          () => getCharacters(page: 1, name: 'rick'),
        ).thenAnswer((_) => rickResponse.future);
        stub(Success(mortyPage), page: 1, name: 'morty');
      },
      build: build,
      act: (bloc) async {
        bloc.add(const CharactersQueryChanged('rick'));
        await Future<void>.delayed(afterDebounce);
        bloc.add(const CharactersQueryChanged('morty'));
        await Future<void>.delayed(afterDebounce);
        rickResponse.complete(Success(rickPage));
      },
      expect: () => [
        const CharactersState(status: CharactersStatus.loading, query: 'rick'),
        const CharactersState(status: CharactersStatus.loading, query: 'morty'),
        CharactersState(
          status: CharactersStatus.success,
          items: mortyPage.characters,
          query: 'morty',
          nextPage: 2,
          hasReachedEnd: true,
        ),
      ],
    );

    final staleNextPage = Completer<Result<CharactersPage>>();
    blocTest<CharactersBloc, CharactersState>(
      'drops a next page that belongs to the previous query',
      setUp: () {
        when(
          () => getCharacters(page: 2),
        ).thenAnswer((_) => staleNextPage.future);
        stub(Success(mortyPage), page: 1, name: 'morty');
      },
      build: build,
      seed: () => loaded,
      act: (bloc) async {
        bloc
          ..add(const CharactersNextPageRequested())
          ..add(const CharactersQueryChanged('morty'));
        await Future<void>.delayed(afterDebounce);
        staleNextPage.complete(Success(lastPage));
      },
      expect: () => [
        loaded.copyWith(isLoadingMore: true),
        const CharactersState(status: CharactersStatus.loading, query: 'morty'),
        CharactersState(
          status: CharactersStatus.success,
          items: mortyPage.characters,
          query: 'morty',
          nextPage: 2,
          hasReachedEnd: true,
        ),
      ],
    );
  });

  group('refresh', () {
    final scrolled = loaded.copyWith(
      items: [...firstPage.characters, ...lastPage.characters],
      nextPage: 3,
    );

    blocTest<CharactersBloc, CharactersState>(
      'keeps the list on screen and replaces it with the first page',
      setUp: () => stub(Success(firstPage), page: 1),
      build: build,
      seed: () => scrolled,
      act: (bloc) => bloc.add(const CharactersRefreshed()),
      expect: () => [
        scrolled.copyWith(status: CharactersStatus.loading),
        loaded,
      ],
    );

    blocTest<CharactersBloc, CharactersState>(
      'keeps the list when the refresh fails',
      setUp: () => stub(const Failed(NetworkFailure()), page: 1),
      build: build,
      seed: () => scrolled,
      act: (bloc) => bloc.add(const CharactersRefreshed()),
      expect: () => [
        scrolled.copyWith(status: CharactersStatus.loading),
        scrolled.copyWith(failure: const NetworkFailure()),
      ],
    );
  });
}

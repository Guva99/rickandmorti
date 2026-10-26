import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clatch_rcikmorti/core/error/failure.dart';
import 'package:clatch_rcikmorti/core/result/result.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:clatch_rcikmorti/features/characters/domain/usecases/get_characters.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(this._getCharacters) : super(const CharactersState()) {
    on<CharactersStarted>(_onReload, transformer: restartable());
    on<CharactersRefreshed>(_onReload, transformer: restartable());
    on<CharactersQueryChanged>(
      _onQueryChanged,
      transformer: _debounceRestartable(searchDebounce),
    );
    on<CharactersNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
    on<CharactersRetried>(_onRetried, transformer: droppable());
  }

  static const searchDebounce = Duration(milliseconds: 400);

  final GetCharacters _getCharacters;

  Future<void> _onReload(
    CharactersEvent event,
    Emitter<CharactersState> emit,
  ) async {
    emit(state.copyWith(status: CharactersStatus.loading));
    await _loadFirstPage(emit);
  }

  Future<void> _onQueryChanged(
    CharactersQueryChanged event,
    Emitter<CharactersState> emit,
  ) async {
    final query = event.query.trim();
    if (query == state.query && state.status == CharactersStatus.success) {
      return;
    }
    emit(CharactersState(status: CharactersStatus.loading, query: query));
    await _loadFirstPage(emit);
  }

  Future<void> _onNextPageRequested(
    CharactersNextPageRequested event,
    Emitter<CharactersState> emit,
  ) async {
    // Scrolling must not hammer a failing page; the footer offers a retry.
    if (state.loadMoreFailure != null) return;
    await _loadNextPage(emit);
  }

  Future<void> _onRetried(
    CharactersRetried event,
    Emitter<CharactersState> emit,
  ) => state.loadMoreFailure == null
      ? _onReload(event, emit)
      : _loadNextPage(emit);

  Future<void> _loadFirstPage(Emitter<CharactersState> emit) async {
    final query = state.query;
    final result = await _getCharacters(page: 1, name: query);
    if (state.query != query) return;

    switch (result) {
      case Success(value: final page):
        emit(
          CharactersState(
            status: CharactersStatus.success,
            items: page.characters,
            query: query,
            nextPage: 2,
            hasReachedEnd: !page.hasNext,
          ),
        );
      case Failed(:final failure):
        // A failed refresh keeps the already loaded list usable.
        emit(
          state.copyWith(
            status: state.items.isEmpty
                ? CharactersStatus.failure
                : CharactersStatus.success,
            failure: failure,
          ),
        );
    }
  }

  Future<void> _loadNextPage(Emitter<CharactersState> emit) async {
    if (state.status != CharactersStatus.success ||
        state.hasReachedEnd ||
        state.isLoadingMore) {
      return;
    }

    final request = state;
    emit(state.copyWith(isLoadingMore: true));
    final result = await _getCharacters(
      page: request.nextPage,
      name: request.query,
    );
    // A refresh or a new query may have replaced the list in the meantime.
    if (state.query != request.query || state.nextPage != request.nextPage) {
      return;
    }

    switch (result) {
      case Success(value: final page):
        emit(
          state.copyWith(
            items: [...state.items, ...page.characters],
            nextPage: state.nextPage + 1,
            hasReachedEnd: !page.hasNext,
            isLoadingMore: false,
          ),
        );
      case Failed(:final failure):
        emit(state.copyWith(isLoadingMore: false, loadMoreFailure: failure));
    }
  }
}

EventTransformer<E> _debounceRestartable<E>(Duration duration) =>
    (events, mapper) => restartable<E>()(events.debounce(duration), mapper);

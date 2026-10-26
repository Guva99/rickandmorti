part of 'characters_bloc.dart';

enum CharactersStatus { initial, loading, success, failure }

final class CharactersState extends Equatable {
  const CharactersState({
    this.status = CharactersStatus.initial,
    this.items = const [],
    this.query = '',
    this.nextPage = 1,
    this.hasReachedEnd = false,
    this.isLoadingMore = false,
    this.failure,
    this.loadMoreFailure,
  });

  final CharactersStatus status;
  final List<Character> items;
  final String query;
  final int nextPage;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final Failure? failure;
  final Failure? loadMoreFailure;

  // Failures describe the latest request only, so they are not carried over.
  CharactersState copyWith({
    CharactersStatus? status,
    List<Character>? items,
    int? nextPage,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    Failure? failure,
    Failure? loadMoreFailure,
  }) => CharactersState(
    status: status ?? this.status,
    items: items ?? this.items,
    query: query,
    nextPage: nextPage ?? this.nextPage,
    hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    failure: failure,
    loadMoreFailure: loadMoreFailure,
  );

  @override
  List<Object?> get props => [
    status,
    items,
    query,
    nextPage,
    hasReachedEnd,
    isLoadingMore,
    failure,
    loadMoreFailure,
  ];
}

part of 'characters_bloc.dart';

sealed class CharactersEvent {
  const CharactersEvent();
}

final class CharactersStarted extends CharactersEvent {
  const CharactersStarted();
}

final class CharactersQueryChanged extends CharactersEvent {
  const CharactersQueryChanged(this.query);

  final String query;
}

final class CharactersNextPageRequested extends CharactersEvent {
  const CharactersNextPageRequested();
}

final class CharactersRefreshed extends CharactersEvent {
  const CharactersRefreshed();
}

final class CharactersRetried extends CharactersEvent {
  const CharactersRetried();
}

import 'package:clatch_rcikmorti/core/network/dio_client.dart';
import 'package:clatch_rcikmorti/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:clatch_rcikmorti/features/characters/data/repositories/characters_repository_impl.dart';
import 'package:clatch_rcikmorti/features/characters/domain/repositories/characters_repository.dart';
import 'package:clatch_rcikmorti/features/characters/domain/usecases/get_characters.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  getIt
    ..registerLazySingleton<Dio>(createDio)
    ..registerLazySingleton(() => CharactersRemoteDataSource(getIt()))
    ..registerLazySingleton<CharactersRepository>(
      () => CharactersRepositoryImpl(getIt()),
    )
    ..registerLazySingleton(() => GetCharacters(getIt()))
    ..registerFactory(() => CharactersBloc(getIt()));
}

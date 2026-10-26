import 'package:clatch_rcikmorti/features/characters/data/models/page_dto.dart';
import 'package:dio/dio.dart';

class CharactersRemoteDataSource {
  const CharactersRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PageDto> fetchCharacters({required int page, String name = ''}) async {
    final response = await _dio.get<Object?>(
      '/character',
      queryParameters: {'page': page, if (name.isNotEmpty) 'name': name},
    );
    return PageDto.fromJson(response.data);
  }
}

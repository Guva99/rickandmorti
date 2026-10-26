import 'package:clatch_rcikmorti/features/characters/data/models/page_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  final json = fixture('characters_page.json');

  group('PageDto.fromJson', () {
    test('parses results and the presence of a next page', () {
      final dto = PageDto.fromJson(json);

      expect(dto.results.map((c) => c.name), [
        'Rick Sanchez',
        'Abradolf Lincler',
        'Adjudicator Rick',
      ]);
      expect(dto.hasNext, isTrue);
    });

    test('has no next page when info.next is null', () {
      final info = json['info'] as Map<String, dynamic>;
      final lastPage = {
        ...json,
        'info': {...info, 'next': null},
      };

      expect(PageDto.fromJson(lastPage).hasNext, isFalse);
    });

    test('throws FormatException on an unexpected payload', () {
      expect(
        () => PageDto.fromJson(const {'error': 'There is nothing here'}),
        throwsFormatException,
      );
    });
  });
}

import 'package:dab_api/src/domain/core/failure.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/dtos/phorge_project_dto.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_project_source.dart';
import 'package:dab_api/src/infrastructure/repositories/provider_metadata_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockPhorgeProjectSource extends Mock implements PhorgeProjectSource {}

void main() {
  late MockPhorgeProjectSource mockSource;
  late ProviderMetadataRepository repository;

  setUp(() {
    mockSource = MockPhorgeProjectSource();
    repository = ProviderMetadataRepository(projectSource: mockSource);
  });

  group('ProviderMetadataRepository', () {
    const tUserId = 'user123';

    final tPhorgeProjects = [
      const PhorgeProjectDto(
        id: 1,
        phid: 'PHID-PROJ-111',
        name: 'Backend',
        color: 'red',
        icon: 'tag',
      ),
      const PhorgeProjectDto(
        id: 2,
        phid: 'PHID-PROJ-222',
        name: 'Bug',
        color: 'orange',
      ),
    ];

    test(
      'should return list of ProviderMetadata when connector call is successful',
      () async {
        // Arrange
        when(
          () => mockSource.fetchActiveSprintProjects('PHID-USER-1234'),
        ).thenAnswer((_) async => tPhorgeProjects);

        // Act
        final result = await repository.getMetadata(tUserId);

        // Assert
        expect(result.isRight(), isTrue);

        final metadataList = result.getOrElse(
          (l) => throw Exception('Left side returned'),
        );
        expect(metadataList.length, 2);

        final first = metadataList.first;
        expect(first.id, 'PHID-PROJ-111');
        expect(first.name, 'Backend');
        expect(first.provider, 'Phorge');
        expect(first.type, 'tag');
        expect(first.color, 'red');
        expect(first.icon, 'tag');

        final second = metadataList[1];
        expect(second.name, 'Bug');
        expect(second.color, 'orange');
        expect(second.icon, isNull);

        verify(
          () => mockSource.fetchActiveSprintProjects('PHID-USER-1234'),
        ).called(1);
      },
    );

    test(
      'should return DatabaseFailure when connector throws an exception',
      () async {
        // Arrange
        when(
          () => mockSource.fetchActiveSprintProjects('PHID-USER-1234'),
        ).thenThrow(Exception('Conduit Error'));

        // Act
        final result = await repository.getMetadata(tUserId);

        // Assert
        expect(result.isLeft(), isTrue);

        final failure = result.match(
          (l) => l,
          (r) => throw Exception('Right side returned'),
        );
        expect(failure, isA<DatabaseFailure>());
        expect(failure.message, contains('Conduit Error'));

        verify(
          () => mockSource.fetchActiveSprintProjects('PHID-USER-1234'),
        ).called(1);
      },
    );
  });
}

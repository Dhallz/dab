import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_wire_fields_dto.dart';
import 'package:dab_api/src/domain/gateways/abs_i_phorge_gateway.dart';
import 'package:dab_api/src/infrastructure/repositories/provider_metadata_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAbsIPhorgeGateway extends Mock implements AbsIPhorgeGateway {}

void main() {
  late MockAbsIPhorgeGateway mockGateway;
  late ProviderMetadataRepository repository;

  setUp(() {
    mockGateway = MockAbsIPhorgeGateway();
    repository = ProviderMetadataRepository(phorgeGateway: mockGateway);
  });

  group('ProviderMetadataRepository', () {
    const tUserId = 'user123';

    late final tPhorgeProjects = [
      PhorgeProjectDto(
        id: 1,
        phid: 'PHID-PROJ-111',
        fields: const PhorgeProjectWireFieldsDto(
          name: 'Backend',
          color: 'red',
          icon: 'tag',
        ),
      ),
      PhorgeProjectDto(
        id: 2,
        phid: 'PHID-PROJ-222',
        fields: const PhorgeProjectWireFieldsDto(
          name: 'Bug',
          color: 'orange',
        ),
      ),
    ];

    test(
      'should return list of ProviderMetadata when connector call is successful',
      () async {
        when(
          () => mockGateway.fetchActiveSprintProjects(any()),
        ).thenAnswer((_) async => Right(tPhorgeProjects));

        final result = await repository.getMetadata(tUserId);

        expect(result.isRight(), isTrue);

        final metadataList = result.getOrElse(
          (l) => throw Exception('Left side returned'),
        );
        expect(metadataList.length, 6);

        final first = metadataList[0];
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

        expect(
          metadataList.map((m) => m.id),
          containsAll(['slack-global', 'discord-global']),
        );

        verify(() => mockGateway.fetchActiveSprintProjects('PHID-USER-1234'))
            .called(1);
      },
    );

    test(
      'should return Failure when gateway returns Left',
      () async {
        when(
          () => mockGateway.fetchActiveSprintProjects(any()),
        ).thenAnswer(
          (_) async => Left(
            DatabaseFailure(
              'Phorge sprint project fetch failed: Exception: Conduit Error',
            ),
          ),
        );

        final result = await repository.getMetadata(tUserId);

        expect(result.isLeft(), isTrue);

        final failure = result.match(
          (l) => l,
          (r) => throw Exception('Right side returned'),
        );
        expect(failure, isA<DatabaseFailure>());
        expect(failure.message, contains('Conduit Error'));

        verify(() => mockGateway.fetchActiveSprintProjects('PHID-USER-1234'))
            .called(1);
      },
    );
  });
}

import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_wire_fields_conduit_hook.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_project_wire_fields.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: `fields` object from Conduit `project.search`.
/// CONTRACT: Mirrors [ApplicationSearch object fields documented for Projects](https://we.phorge.it/conduit/method/project.search/) (`Object Fields`).
@MappableClass(hook: PhorgeProjectWireFieldsConduitHook())
class PhorgeProjectWireFields with PhorgeProjectWireFieldsMappable {
  final String name;

  /// Primary hashtag slug.
  final String? slug;

  final String? subtype;

  /// Milestone sequence number when this row is a milestone.
  final int? milestone;

  /// Brief parent-project description for milestones / subprojects.
  final Map<String, dynamic>? parent;

  final int depth;

  /// Conduit may return `{ "key": "…", … }` or legacy string forms.
  final Object? icon;

  final Object? color;

  /// Policy space [`PHID-SPC-…`].
  final String? spacePHID;

  /// Epoch seconds (object creation).
  final int? dateCreated;

  /// Epoch seconds (last update).
  final int? dateModified;

  final Map<String, dynamic>? policy;

  /// Short description (`wild` in Conduit; often string markup).
  final Object? description;

  const PhorgeProjectWireFields({
    required this.name,
    this.slug,
    this.subtype,
    this.milestone,
    this.parent,
    required this.depth,
    this.icon,
    this.color,
    this.spacePHID,
    this.dateCreated,
    this.dateModified,
    this.policy,
    this.description,
  });
}

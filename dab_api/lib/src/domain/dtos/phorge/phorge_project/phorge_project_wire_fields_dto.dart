import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_project_wire_fields_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: `fields` object from Conduit `project.search`.
/// CONTRACT: Mirrors [ApplicationSearch object fields documented for Projects](https://we.phorge.it/conduit/method/project.search/) (`Object Fields`). Omit or null on the wire ⇒ null here (no synthetic defaults).
@MappableClass()
class PhorgeProjectWireFieldsDto with PhorgeProjectWireFieldsDtoMappable {
  final String? name;

  /// Primary hashtag slug.
  final String? slug;

  final String? subtype;

  /// Milestone sequence number when this row is a milestone.
  final int? milestone;

  /// Brief parent-project description for milestones / subprojects.
  final Map<String, dynamic>? parent;

  final int? depth;

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

  const PhorgeProjectWireFieldsDto({
    this.name,
    this.slug,
    this.subtype,
    this.milestone,
    this.parent,
    this.depth,
    this.icon,
    this.color,
    this.spacePHID,
    this.dateCreated,
    this.dateModified,
    this.policy,
    this.description,
  });
}

import 'package:dart_mappable/dart_mappable.dart';

part 'activity_category.mapper.dart';

@MappableEnum()
enum ActivityCategory {
  commit,
  revision,
  task,
  message,
  generic;

  String get label {
    switch (this) {
      case ActivityCategory.commit:
      case ActivityCategory.revision:
        return 'Engineering';
      case ActivityCategory.task:
        return 'Product';
      case ActivityCategory.message:
        return 'Communication';
      case ActivityCategory.generic:
        return 'Activity';
    }
  }
}

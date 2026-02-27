import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/app/app_cubit.dart';

/// Base class for all Cubits in the project.
abstract class AbsCubit<S> extends Cubit<S> {
  static late AppCubit appCubit;

  AbsCubit(super.initialState);

  /// Access to global application state (Theme, Locale, etc.)
  AppCubit get app => appCubit;
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/app/app_cubit.dart';

/// Base class for all Blocs in the project.
abstract class AbsBloc<E, S> extends Bloc<E, S> {
  static late AppCubit appCubit;

  AbsBloc(super.initialState);

  /// Access to global application state (Theme, Locale, etc.)
  AppCubit get app => appCubit;
}

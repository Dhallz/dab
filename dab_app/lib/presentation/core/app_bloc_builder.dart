import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper around [BlocBuilder] that provides a safe [onInit] callback.
/// Works with both [Bloc] and [Cubit] via the [StateStreamableSource] interface.
class AppBlocBuilder<B extends StateStreamableSource<S>, S>
    extends StatefulWidget {
  final void Function(BuildContext context, B bloc)? onInit;
  final Widget Function(BuildContext context, S state, B bloc) builder;
  final bool Function(S previous, S current)? buildWhen;
  final bool withLogs;

  const AppBlocBuilder({
    super.key,
    required this.builder,
    this.onInit,
    this.buildWhen,
    this.withLogs = false,
  });

  @override
  State<AppBlocBuilder<B, S>> createState() => _AppBlocBuilderState<B, S>();
}

class _AppBlocBuilderState<B extends StateStreamableSource<S>, S>
    extends State<AppBlocBuilder<B, S>> {
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<B>();
    // Safely called exactly once when the widget enters the tree.
    widget.onInit?.call(context, _bloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: _bloc,
      buildWhen: widget.buildWhen,
      builder: (context, state) {
        if (widget.withLogs) {
          debugPrint('🟢 [${_bloc.runtimeType}] State: $state');
        }
        return widget.builder(context, state, _bloc);
      },
    );
  }
}

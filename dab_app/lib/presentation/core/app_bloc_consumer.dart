import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper around [BlocConsumer] that provides a safe [onInit] callback.
/// Works with both [Bloc] and [Cubit] via the [StateStreamableSource] interface.
class AppBlocConsumer<B extends StateStreamableSource<S>, S>
    extends StatefulWidget {
  final void Function(BuildContext context, B bloc)? onInit;
  final Widget Function(BuildContext context, S state, B bloc) builder;
  final void Function(BuildContext context, S state, B bloc) listener;
  final bool Function(S previous, S current)? buildWhen;
  final bool Function(S previous, S current)? listenWhen;
  final bool withLogs;

  const AppBlocConsumer({
    super.key,
    required this.builder,
    required this.listener,
    this.onInit,
    this.buildWhen,
    this.listenWhen,
    this.withLogs = false,
  });

  @override
  State<AppBlocConsumer<B, S>> createState() => _AppBlocConsumerState<B, S>();
}

class _AppBlocConsumerState<B extends StateStreamableSource<S>, S>
    extends State<AppBlocConsumer<B, S>> {
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
    return BlocConsumer<B, S>(
      bloc: _bloc,
      listenWhen: widget.listenWhen,
      listener: (context, state) => widget.listener(context, state, _bloc),
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

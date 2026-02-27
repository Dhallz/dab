import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper around [BlocListener] that provides a safe [onInit] callback.
/// Works with both [Bloc] and [Cubit] via the [StateStreamableSource] interface.
class AppBlocListener<B extends StateStreamableSource<S>, S>
    extends StatefulWidget {
  final void Function(BuildContext context, B bloc)? onInit;
  final void Function(BuildContext context, S state, B bloc) listener;
  final bool Function(S previous, S current)? listenWhen;
  final Widget child;

  const AppBlocListener({
    super.key,
    required this.listener,
    required this.child,
    this.onInit,
    this.listenWhen,
  });

  @override
  State<AppBlocListener<B, S>> createState() => _AppBlocListenerState<B, S>();
}

class _AppBlocListenerState<B extends StateStreamableSource<S>, S>
    extends State<AppBlocListener<B, S>> {
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
    return BlocListener<B, S>(
      bloc: _bloc,
      listenWhen: widget.listenWhen,
      listener: (context, state) => widget.listener(context, state, _bloc),
      child: widget.child,
    );
  }
}

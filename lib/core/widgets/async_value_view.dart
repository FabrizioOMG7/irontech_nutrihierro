import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueView<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) dataBuilder;
  final String errorPrefix;
  final Widget? loading;

  const AsyncValueView({
    super.key,
    required this.value,
    required this.dataBuilder,
    this.errorPrefix = 'Error',
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: dataBuilder,
      loading: () => loading ?? const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$errorPrefix: $error')),
    );
  }
}

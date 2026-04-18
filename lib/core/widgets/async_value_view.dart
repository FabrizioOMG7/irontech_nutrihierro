import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueView<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) dataBuilder;
  final String errorPrefix;
  final String? loadingMessage;
  final Widget? loading;

  const AsyncValueView({
    super.key,
    required this.value,
    required this.dataBuilder,
    this.errorPrefix = 'Error',
    this.loadingMessage,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: dataBuilder,
      loading: () => loading ?? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (loadingMessage != null) ...[
              const SizedBox(height: 12),
              Text(loadingMessage!),
            ],
          ],
        ),
      ),
      error: (error, _) => Center(
        child: Text(
          '$errorPrefix: $error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

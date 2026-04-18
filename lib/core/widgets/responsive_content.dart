import 'package:flutter/material.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';

class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= AppBreakpoints.tablet ? AppSpacing.lg : AppSpacing.md;
        final effectivePadding = padding.copyWith(
          left: padding.left + horizontalPadding,
          right: padding.right + horizontalPadding,
        );
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxContentWidth),
            child: Padding(
              padding: effectivePadding,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

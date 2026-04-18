import 'package:flutter/material.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';

class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= AppBreakpoints.tablet ? AppSpacing.lg : AppSpacing.md;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxContentWidth),
            child: Padding(
              padding: padding.add(EdgeInsets.symmetric(horizontal: horizontalPadding)),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

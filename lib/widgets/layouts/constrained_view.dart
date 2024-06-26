import 'package:ark_jots/utils/consts.dart';
import 'package:flutter/widgets.dart';

/// Horizontally constrains [child] into the center.
class ConstrainedView extends StatelessWidget {
  const ConstrainedView({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Consts.layoutBig),
          child: child,
        ),
      ),
    );
  }
}

class SliverConstrainedView extends StatelessWidget {
  const SliverConstrainedView({super.key, required this.sliver});

  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final side = (constraints.crossAxisExtent - Consts.layoutMedium) / 2;
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: side < 10 ? 10 : side),
          sliver: sliver,
        );
      },
    );
  }
}

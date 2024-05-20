import 'package:ark_jots/modules/user/user_models.dart';
import 'package:ark_jots/utils/consts.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    required this.id,
    required this.user,
    required this.imageUrl,
  });

  final int? id;
  final bool isViewer = true;
  final User? user;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textRailItems = <String, bool>{};

    return SliverPersistentHeader(
      pinned: true,
      delegate: _Delegate(
        id: id,
        isViewer: isViewer,
        user: user,
        imageUrl: imageUrl,
        textRailItems: textRailItems,
        topOffset: MediaQuery.paddingOf(context).top,
        imageWidth: size.width < 430.0 ? size.width * 0.30 : 100.0,
      ),
    );
  }
}

class _Delegate extends SliverPersistentHeaderDelegate {
  _Delegate({
    required this.id,
    required this.isViewer,
    required this.user,
    required this.imageUrl,
    required this.topOffset,
    required this.imageWidth,
    required this.textRailItems,
  });

  final int? id;
  final bool isViewer;
  final User? user;
  final String? imageUrl;
  final double topOffset;
  final double imageWidth;
  final Map<String, bool> textRailItems;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final height = maxExtent;
    final bannerOffset = height - _bannerBaseHeight - topOffset;

    var transition = shrinkOffset > _bannerBaseHeight
        ? (shrinkOffset - _bannerBaseHeight) / (imageWidth / 4)
        : 0.0;
    if (transition > 1) transition = 1;

    final image = user?.imageUrl ?? imageUrl;
    final theme = Theme.of(context);

    final avatar = ClipRRect(
      borderRadius: Consts.borderRadiusMin,
      child: SizedBox(
        height: imageWidth,
        width: imageWidth,
        child: image != null ? Image.network(image) : null,
      ),
    );

    final infoContent = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        id != null ? Hero(tag: id!, child: avatar) : avatar,
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // onTap: () => Toast.copy(context, user!.name),
                  child: Text(
                    user!.name,
                    overflow: TextOverflow.fade,
                    style: theme.textTheme.titleLarge!.copyWith(
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: theme.colorScheme.background,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ],
          ),
        ),
      ],
    );

    final topRow = Row(
      children: [
        isViewer
            ? const SizedBox(width: 10)
            : TopBarIcon(
                tooltip: 'Close',
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
        Expanded(
          child: user?.name == null
              ? const SizedBox()
              : Opacity(
                  opacity: transition,
                  child: Text(
                    user!.name,
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        ),
        TopBarIcon(
          tooltip: 'Settings',
          icon: Ionicons.cog_outline,
          onTap: () => Navigator.pushNamed(context, "/settings"),
        ),
      ],
    );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        if (transition < 1) ...[
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   bottom: bannerOffset,
          //   child: user?.bannerUrl != null
          //       ? Image.network(user!.bannerUrl!)
          //       : DecoratedBox(
          //           decoration: BoxDecoration(
          //             color: theme.colorScheme.surfaceVariant,
          //           ),
          //         ),
          // ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bannerOffset,
            child: Container(
              alignment: Alignment.topCenter,
              color: theme.colorScheme.background,
              child: Container(
                height: 0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      spreadRadius: 25,
                      color: theme.colorScheme.background,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: infoContent,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topOffset + Consts.tapTargetSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.background,
                    theme.colorScheme.background.withAlpha(200),
                    theme.colorScheme.background.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topOffset + Consts.tapTargetSize,
            child: Opacity(
              opacity: transition,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                ),
              ),
            ),
          ),
        ],
        Positioned(
          left: 0,
          right: 0,
          top: topOffset,
          height: Consts.tapTargetSize,
          child: topRow,
        ),
      ],
    );

    return transition < 1
        ? body
        : ClipRect(
            child: BackdropFilter(
              filter: Consts.blurFilter,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.navigationBarTheme.backgroundColor,
                ),
                child: body,
              ),
            ),
          );
  }

  // static const _bannerBaseHeight = 200.0;
  static const _bannerBaseHeight = 100.0;

  @override
  double get minExtent => topOffset + Consts.tapTargetSize;

  @override
  double get maxExtent => topOffset + _bannerBaseHeight + imageWidth / 2;

  @override
  bool shouldRebuild(covariant _Delegate oldDelegate) =>
      user != oldDelegate.user;
}

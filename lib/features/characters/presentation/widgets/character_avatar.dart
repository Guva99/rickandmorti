import 'package:cached_network_image/cached_network_image.dart';
import 'package:clatch_rcikmorti/core/theme/app_colors.dart';
import 'package:clatch_rcikmorti/core/theme/app_motion.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:flutter/material.dart';

class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({
    required this.character,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  final Character character;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => Hero(
    tag: 'character-avatar-${character.id}',
    flightShuttleBuilder: _flight,
    child: _Image(url: character.imageUrl, borderRadius: borderRadius),
  );

  Widget _flight(
    BuildContext context,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final from = _radiusOf(fromHeroContext);
    final to = _radiusOf(toHeroContext);
    final (begin, end) = direction == HeroFlightDirection.push
        ? (from, to)
        : (to, from);

    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) => _Image(
        url: character.imageUrl,
        borderRadius: BorderRadius.lerp(begin, end, animation.value) ?? end,
      ),
    );
  }

  static BorderRadius _radiusOf(BuildContext heroContext) =>
      switch (heroContext.widget) {
        Hero(child: _Image(:final borderRadius)) => borderRadius,
        _ => BorderRadius.zero,
      };
}

class _Image extends StatelessWidget {
  const _Image({required this.url, required this.borderRadius});

  final String url;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: borderRadius,
    child: CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      fadeInDuration: context.motion(AppMotion.medium),
      fadeOutDuration: context.motion(AppMotion.fast),
      placeholder: (_, _) => const ColoredBox(color: AppColors.skeleton),
      errorWidget: (_, _, _) => const ColoredBox(
        color: AppColors.skeleton,
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    ),
  );
}

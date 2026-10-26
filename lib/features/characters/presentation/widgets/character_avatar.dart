import 'package:cached_network_image/cached_network_image.dart';
import 'package:clatch_rcikmorti/core/theme/app_colors.dart';
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
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: borderRadius,
    child: CachedNetworkImage(
      imageUrl: character.imageUrl,
      fit: BoxFit.cover,
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

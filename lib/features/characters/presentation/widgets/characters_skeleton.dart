import 'package:clatch_rcikmorti/core/theme/app_colors.dart';
import 'package:clatch_rcikmorti/core/theme/app_dimens.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/character_tile.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/characters_grid.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class CharactersSkeleton extends StatelessWidget {
  const CharactersSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Shimmer(
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: charactersGridPadding,
      gridDelegate: charactersGridDelegate,
      itemCount: 12,
      itemBuilder: (_, _) => const _SkeletonTile(),
    ),
  );
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          _Bone(
            width: CharacterTile.avatarSize,
            height: CharacterTile.avatarSize,
            borderRadius: AppRadius.sm,
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bone(width: 160, height: 16),
                SizedBox(height: AppSpacing.sm),
                _Bone(width: 96, height: 12),
                SizedBox(height: AppSpacing.md),
                _Bone(width: 64, height: 18),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Bone extends StatelessWidget {
  const _Bone({
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.skeleton,
      borderRadius: borderRadius,
    ),
  );
}

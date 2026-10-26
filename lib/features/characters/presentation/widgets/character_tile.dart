import 'package:clatch_rcikmorti/core/theme/app_colors.dart';
import 'package:clatch_rcikmorti/core/theme/app_dimens.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/character_avatar.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/character_name.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/pressable_card.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class CharacterTile extends StatelessWidget {
  const CharacterTile({
    required this.character,
    required this.onTap,
    super.key,
  });

  static const height = 104.0;
  static const double avatarSize = height - AppSpacing.md * 2;

  final Character character;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PressableCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            SizedBox.square(
              dimension: avatarSize,
              child: CharacterAvatar(
                character: character,
                borderRadius: AppRadius.sm,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CharacterName(
                    character: character,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    character.species,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  StatusBadge(status: character.status),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

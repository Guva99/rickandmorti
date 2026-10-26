import 'dart:math';

import 'package:clatch_rcikmorti/core/theme/app_colors.dart';
import 'package:clatch_rcikmorti/core/theme/app_dimens.dart';
import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/character_avatar.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/fact_tile.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class CharacterDetailsPage extends StatelessWidget {
  const CharacterDetailsPage({required this.character, super.key});

  static Route<void> route(Character character) => MaterialPageRoute(
    builder: (_) => CharacterDetailsPage(character: character),
  );

  static const _maxContentWidth = 720.0;

  final Character character;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = max(
      AppSpacing.lg,
      (width - _maxContentWidth) / 2,
    );
    final facts = [
      (Icons.science_outlined, 'Species', character.species),
      (Icons.wc_rounded, 'Gender', character.gender),
      (Icons.public_rounded, 'Origin', character.origin),
      (Icons.place_outlined, 'Last known location', character.location),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _ImageAppBar(character: character, height: min(width, 440)),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.sm,
                horizontalPadding,
                AppSpacing.xl,
              ),
              sliver: SliverList.list(
                children: [
                  Text(
                    character.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: StatusBadge(status: character.status),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  for (final (icon, label, value) in facts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: FactTile(icon: icon, label: label, value: value),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageAppBar extends StatelessWidget {
  const _ImageAppBar({required this.character, required this.height});

  final Character character;
  final double height;

  @override
  Widget build(BuildContext context) => SliverAppBar(
    expandedHeight: height,
    pinned: true,
    stretch: true,
    leading: const _BackButton(),
    flexibleSpace: FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.expand,
        children: [
          CharacterAvatar(character: character),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.6, 1],
                colors: [Colors.transparent, AppColors.background],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.sm),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
      child: const BackButton(color: AppColors.textPrimary),
    ),
  );
}

import 'dart:math';

import 'package:clatch_rcikmorti/core/theme/app_dimens.dart';
import 'package:clatch_rcikmorti/core/theme/app_motion.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/pages/character_details_page.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/character_tile.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/entrance_transition.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/list_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const charactersGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 440,
  mainAxisExtent: CharacterTile.height,
  mainAxisSpacing: AppSpacing.md,
  crossAxisSpacing: AppSpacing.md,
);

const charactersGridPadding = EdgeInsets.symmetric(horizontal: AppSpacing.lg);

class CharactersGrid extends StatefulWidget {
  const CharactersGrid({super.key});

  @override
  State<CharactersGrid> createState() => _CharactersGridState();
}

class _CharactersGridState extends State<CharactersGrid> {
  final _revealed = <int>{};
  var _revealedThisFrame = 0;

  // Only tiles revealed within one frame form a staircase, so tiles that
  // scroll into view later appear right away instead of waiting their turn.
  Duration _nextRevealDelay() {
    if (_revealedThisFrame == 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _revealedThisFrame = 0,
      );
    }
    final step = min(_revealedThisFrame++, AppMotion.maxStaggerSteps);
    return AppMotion.staggerStep * step;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CharactersBloc>();
    final state = context.watch<CharactersBloc>().state;

    return _LoadMoreListener(
      onLoadMore: () => bloc.add(const CharactersNextPageRequested()),
      child: RefreshIndicator(
        onRefresh: () {
          bloc.add(const CharactersRefreshed());
          return bloc.stream.firstWhere(
            (state) => state.status != CharactersStatus.loading,
          );
        },
        child: CustomScrollView(
          key: const PageStorageKey('characters'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: charactersGridPadding,
              sliver: SliverGrid.builder(
                gridDelegate: charactersGridDelegate,
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final character = state.items[index];
                  final isFirstAppearance = _revealed.add(character.id);
                  return EntranceTransition(
                    enabled: isFirstAppearance,
                    delay: isFirstAppearance
                        ? _nextRevealDelay()
                        : Duration.zero,
                    child: CharacterTile(
                      character: character,
                      onTap: () => Navigator.of(
                        context,
                      ).push(CharacterDetailsPage.route(context, character)),
                    ),
                  );
                },
              ),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverToBoxAdapter(
                child: ListFooter(
                  isLoading: state.isLoadingMore,
                  failure: state.loadMoreFailure,
                  onRetry: () => bloc.add(const CharactersRetried()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadMoreListener extends StatelessWidget {
  const _LoadMoreListener({required this.onLoadMore, required this.child});

  static const _threshold = 300.0;

  final VoidCallback onLoadMore;
  final Widget child;

  bool _check(ScrollMetrics metrics) {
    if (metrics.extentAfter < _threshold) onLoadMore();
    return false;
  }

  // Metrics notifications cover the case when a page is too short to scroll.
  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) => _check(notification.metrics),
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) => _check(notification.metrics),
          child: child,
        ),
      );
}

import 'package:clatch_rcikmorti/core/theme/app_dimens.dart';
import 'package:clatch_rcikmorti/core/theme/app_motion.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/characters_grid.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/characters_skeleton.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/message_view.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocListener<CharactersBloc, CharactersState>(
        listenWhen: (previous, current) =>
            current.items.isNotEmpty &&
            current.failure != null &&
            current.failure != previous.failure,
        listener: (context, state) {
          if (state.failure case final failure?) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(failure.message)));
          }
        },
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppLayout.maxContentWidth,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(),
                    Expanded(child: _CatalogBody()),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.lg,
      AppSpacing.lg,
      AppSpacing.md,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Characters', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.md),
        const SearchField(),
      ],
    ),
  );
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharactersBloc>().state;

    final view = switch (state) {
      _ when state.items.isNotEmpty => const CharactersGrid(),
      CharactersState(status: CharactersStatus.failure, :final failure?) =>
        MessageView(
          key: const ValueKey(CharactersStatus.failure),
          icon: Icons.cloud_off_rounded,
          title: 'Could not load characters',
          message: failure.message,
          action: FilledButton(
            onPressed: () =>
                context.read<CharactersBloc>().add(const CharactersRetried()),
            child: const Text('Try again'),
          ),
        ),
      CharactersState(status: CharactersStatus.success) => MessageView(
        key: const ValueKey(CharactersStatus.success),
        icon: Icons.person_search_rounded,
        title: 'Nobody here',
        message: 'No characters match “${state.query}”. Try another name.',
      ),
      _ => const CharactersSkeleton(),
    };

    return AnimatedSwitcher(
      duration: context.motion(AppMotion.medium),
      switchInCurve: AppMotion.curve,
      switchOutCurve: AppMotion.curve,
      child: view,
    );
  }
}
